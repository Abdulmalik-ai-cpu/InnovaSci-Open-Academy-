import { NextRequest, NextResponse } from "next/server"
import { PrismaClient } from "@prisma/client"
import bcrypt from "bcryptjs"

// RBAC Roles
const ROLES = [
  { name: "SUPER_ADMIN", displayName: "Super Administrator", portal: "ADMINISTRATION", level: 100, description: "Full platform access" },
  { name: "SYSTEM_ADMIN", displayName: "System Administrator", portal: "ADMINISTRATION", level: 90, description: "Technical operations" },
  { name: "ACADEMIC_DIRECTOR", displayName: "Academic Director", portal: "ACADEMIC", level: 80, description: "Academic governance" },
  { name: "HEAD_OF_DOMAIN", displayName: "Head of Domain", portal: "ACADEMIC", level: 70, description: "Domain management" },
  { name: "CATEGORY_LEAD", displayName: "Category Lead", portal: "ACADEMIC", level: 60, description: "Category management" },
  { name: "INSTRUCTOR", displayName: "Instructor", portal: "INSTRUCTOR", level: 50, description: "Course instruction" },
  { name: "STUDENT", displayName: "Student", portal: "STUDENT", level: 10, description: "Learning access" },
]

// Seed users configuration
const SEED_USERS = [
  { email: "super@innovasci.com", passwordEnv: "SUPER_ADMIN_PASSWORD", defaultPassword: "Supa$$$", role: "SUPER_ADMIN", roleName: "Super Administrator", portal: "ADMINISTRATION", profile: { fullName: "Super Administrator" } },
  { email: "systemadmin@innovasci.com", passwordEnv: "SYSTEM_ADMIN_PASSWORD", defaultPassword: "Systemadmin$$$$4", role: "SYSTEM_ADMIN", roleName: "System Administrator", portal: "ADMINISTRATION", profile: { fullName: "System Administrator" } },
  { email: "directoracademic@innovasci.com", passwordEnv: "ACADEMIC_DIRECTOR_PASSWORD", defaultPassword: "Director$$$$2", role: "ACADEMIC_DIRECTOR", roleName: "Academic Director", portal: "ACADEMIC", profile: { fullName: "Academic Director" } },
  { email: "head@innovasci.com", passwordEnv: "HEAD_OF_DOMAIN_PASSWORD", defaultPassword: "Head$$$$3", role: "HEAD_OF_DOMAIN", roleName: "Head of Domain", portal: "ACADEMIC", profile: { fullName: "Head of Domain" } },
  { email: "lead@innovasci.com", passwordEnv: "CATEGORY_LEAD_PASSWORD", defaultPassword: "Lead$$$$4", role: "CATEGORY_LEAD", roleName: "Category Lead", portal: "ACADEMIC", profile: { fullName: "Category Lead" } },
  { email: "instructor@innovasci.com", passwordEnv: "INSTRUCTOR_PASSWORD", defaultPassword: "Instructor$$$$2", role: "INSTRUCTOR", roleName: "Instructor", portal: "INSTRUCTOR", profile: { fullName: "Instructor" } },
]

const prisma = new PrismaClient()

export async function POST(request: NextRequest) {
  try {
    // Verify secret key
    const authHeader = request.headers.get("authorization")
    const expectedSecret = process.env.SEED_SECRET || "innovasci-seed-secret-key"
    
    if (authHeader !== `Bearer ${expectedSecret}`) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
    }

    const results: string[] = []

    // Create roles
    for (const roleData of ROLES) {
      try {
        const role = await prisma.role.upsert({
          where: { name: roleData.name },
          update: roleData,
          create: roleData,
        })
        results.push(`✓ Role: ${role.displayName}`)
      } catch (e) {
        results.push(`✗ Role ${roleData.name}: ${(e as Error).message}`)
      }
    }

    // Create users
    for (const userData of SEED_USERS) {
      try {
        const password = process.env[userData.passwordEnv] || userData.defaultPassword
        const hashedPassword = await bcrypt.hash(password, 12)
        
        const role = await prisma.role.findUnique({ where: { name: userData.role } })
        if (!role) {
          results.push(`✗ User ${userData.email}: Role ${userData.role} not found`)
          continue
        }

        const user = await prisma.user.upsert({
          where: { email: userData.email },
          update: {
            passwordHash: hashedPassword,
            role: userData.role,
            status: "ACTIVE",
          },
          create: {
            email: userData.email,
            passwordHash: hashedPassword,
            role: userData.role,
            status: "ACTIVE",
            profile: {
              create: {
                fullName: userData.profile.fullName,
              },
            },
          },
        })

        // Assign role
        await prisma.userRole.upsert({
          where: { userId_roleId: { userId: user.id, roleId: role.id } },
          update: { isActive: true },
          create: { userId: user.id, roleId: role.id },
        })

        // Assign portal
        await prisma.portalAssignment.upsert({
          where: { userId: user.id },
          update: { portal: userData.portal },
          create: { userId: user.id, portal: userData.portal },
        })

        results.push(`✓ ${userData.email} (${userData.roleName})`)
      } catch (e) {
        results.push(`✗ User ${userData.email}: ${(e as Error).message}`)
      }
    }

    return NextResponse.json({
      success: true,
      results,
      users: SEED_USERS.map(u => ({
        email: u.email,
        role: u.roleName,
        password: process.env[u.passwordEnv] || u.defaultPassword,
      })),
    })
  } catch (error) {
    console.error("Seed error:", error)
    return NextResponse.json(
      { error: "Seed failed", details: (error as Error).message },
      { status: 500 }
    )
  }
}
