/**
 * InnovaSci Open Academy - RBAC Seed
 * 
 * This seed initializes RBAC roles, permissions, and creates seed users.
 * 
 * Environment Variables Required:
 * - SUPER_ADMIN_PASSWORD
 * - SYSTEM_ADMIN_PASSWORD
 * - ACADEMIC_DIRECTOR_PASSWORD
 * - HEAD_OF_DOMAIN_PASSWORD
 * - CATEGORY_LEAD_PASSWORD
 * - INSTRUCTOR_PASSWORD
 */

import { PrismaClient } from "@prisma/client"
import * as bcrypt from "bcryptjs"

const prisma = new PrismaClient()

// Get passwords from environment variables
const getPassword = (envVar: string, defaultPassword: string): string => {
  return process.env[envVar] || defaultPassword
}

// Seed user credentials
const SEED_USERS = [
  {
    email: "super@innovasci.com",
    password: getPassword("SUPER_ADMIN_PASSWORD", "Supa$$$"),
    role: "SUPER_ADMIN",
    roleName: "Super Administrator",
    portal: "ADMINISTRATION",
    profile: { fullName: "Super Administrator" }
  },
  {
    email: "systemadmin@innovasci.com",
    password: getPassword("SYSTEM_ADMIN_PASSWORD", "Systemadmin$$$$4"),
    role: "SYSTEM_ADMIN",
    roleName: "System Administrator",
    portal: "ADMINISTRATION",
    profile: { fullName: "System Administrator" }
  },
  {
    email: "directoracademic@innovasci.com",
    password: getPassword("ACADEMIC_DIRECTOR_PASSWORD", "Director$$$$2"),
    role: "ACADEMIC_DIRECTOR",
    roleName: "Academic Director",
    portal: "ACADEMIC",
    profile: { fullName: "Academic Director" }
  },
  {
    email: "head@innovasci.com",
    password: getPassword("HEAD_OF_DOMAIN_PASSWORD", "Head$$$$3"),
    role: "HEAD_OF_DOMAIN",
    roleName: "Head of Domain",
    portal: "ACADEMIC",
    profile: { fullName: "Head of Domain" }
  },
  {
    email: "lead@innovasci.com",
    password: getPassword("CATEGORY_LEAD_PASSWORD", "Lead$$$$4"),
    role: "CATEGORY_LEAD",
    roleName: "Category Lead",
    portal: "ACADEMIC",
    profile: { fullName: "Category Lead" }
  },
  {
    email: "instructor@innovasci.com",
    password: getPassword("INSTRUCTOR_PASSWORD", "Instructor$$$$2"),
    role: "INSTRUCTOR",
    roleName: "Instructor",
    portal: "INSTRUCTOR",
    profile: { fullName: "Instructor" }
  },
]

// Role definitions
const ROLES = [
  { name: "SUPER_ADMIN", displayName: "Super Administrator", portal: "ADMINISTRATION", level: 100, description: "Full platform access" },
  { name: "SYSTEM_ADMIN", displayName: "System Administrator", portal: "ADMINISTRATION", level: 90, description: "Technical operations" },
  { name: "ACADEMIC_DIRECTOR", displayName: "Academic Director", portal: "ACADEMIC", level: 80, description: "Academic governance" },
  { name: "HEAD_OF_DOMAIN", displayName: "Head of Domain", portal: "ACADEMIC", level: 70, description: "Domain management" },
  { name: "CATEGORY_LEAD", displayName: "Category Lead", portal: "ACADEMIC", level: 60, description: "Category management" },
  { name: "INSTRUCTOR", displayName: "Instructor", portal: "INSTRUCTOR", level: 50, description: "Course instruction" },
  { name: "STUDENT", displayName: "Student", portal: "STUDENT", level: 10, description: "Learning access" },
]

// Permission definitions
const PERMISSIONS = [
  // Users
  { name: "USERS_VIEW", category: "USERS", description: "View users" },
  { name: "USERS_CREATE", category: "USERS", description: "Create users" },
  { name: "USERS_UPDATE", category: "USERS", description: "Update users" },
  { name: "USERS_DELETE", category: "USERS", description: "Delete users" },
  { name: "USERS_MANAGE", category: "USERS", description: "Full user management" },
  // Domains
  { name: "DOMAINS_VIEW", category: "DOMAINS", description: "View domains" },
  { name: "DOMAINS_CREATE", category: "DOMAINS", description: "Create domains" },
  { name: "DOMAINS_UPDATE", category: "DOMAINS", description: "Update domains" },
  { name: "DOMAINS_DELETE", category: "DOMAINS", description: "Delete domains" },
  { name: "DOMAINS_MANAGE", category: "DOMAINS", description: "Full domain management" },
  { name: "DOMAINS_APPROVE", category: "DOMAINS", description: "Approve domains" },
  // Categories
  { name: "CATEGORIES_VIEW", category: "CATEGORIES", description: "View categories" },
  { name: "CATEGORIES_CREATE", category: "CATEGORIES", description: "Create categories" },
  { name: "CATEGORIES_UPDATE", category: "CATEGORIES", description: "Update categories" },
  { name: "CATEGORIES_DELETE", category: "CATEGORIES", description: "Delete categories" },
  { name: "CATEGORIES_MANAGE", category: "CATEGORIES", description: "Full category management" },
  { name: "CATEGORIES_APPROVE", category: "CATEGORIES", description: "Approve categories" },
  // Courses
  { name: "COURSES_VIEW", category: "COURSES", description: "View courses" },
  { name: "COURSES_CREATE", category: "COURSES", description: "Create courses" },
  { name: "COURSES_UPDATE", category: "COURSES", description: "Update courses" },
  { name: "COURSES_DELETE", category: "COURSES", description: "Delete courses" },
  { name: "COURSES_MANAGE", category: "COURSES", description: "Full course management" },
  { name: "COURSES_PUBLISH", category: "COURSES", description: "Publish courses" },
  { name: "COURSES_APPROVE", category: "COURSES", description: "Approve courses" },
  // Projects
  { name: "PROJECTS_VIEW", category: "PROJECTS", description: "View projects" },
  { name: "PROJECTS_CREATE", category: "PROJECTS", description: "Create projects" },
  { name: "PROJECTS_UPDATE", category: "PROJECTS", description: "Update projects" },
  { name: "PROJECTS_DELETE", category: "PROJECTS", description: "Delete projects" },
  { name: "PROJECTS_MANAGE", category: "PROJECTS", description: "Full project management" },
  { name: "PROJECTS_REVIEW", category: "PROJECTS", description: "Review projects" },
  { name: "PROJECTS_GRADE", category: "PROJECTS", description: "Grade projects" },
  { name: "CAPSTONES_VIEW", category: "PROJECTS", description: "View capstones" },
  { name: "CAPSTONES_REVIEW", category: "PROJECTS", description: "Review capstones" },
  { name: "CAPSTONES_APPROVE", category: "PROJECTS", description: "Approve capstones" },
  // Certificates
  { name: "CERTIFICATES_VIEW", category: "CERTIFICATES", description: "View certificates" },
  { name: "CERTIFICATES_MANAGE", category: "CERTIFICATES", description: "Full certificate management" },
  // System
  { name: "SYSTEM_VIEW", category: "SYSTEM", description: "View system info" },
  { name: "SYSTEM_MONITOR", category: "SYSTEM", description: "Monitor system" },
  { name: "SYSTEM_CONFIGURE", category: "SYSTEM", description: "Configure system" },
  { name: "SYSTEM_MANAGE", category: "SYSTEM", description: "Full system management" },
  // Storage
  { name: "STORAGE_VIEW", category: "STORAGE", description: "View storage" },
  { name: "STORAGE_UPLOAD", category: "STORAGE", description: "Upload to storage" },
  { name: "STORAGE_DELETE", category: "STORAGE", description: "Delete from storage" },
  { name: "STORAGE_MANAGE", category: "STORAGE", description: "Full storage management" },
  // Database
  { name: "DATABASE_VIEW", category: "DATABASE", description: "View database" },
  { name: "DATABASE_BACKUP", category: "DATABASE", description: "Backup database" },
  { name: "DATABASE_RESTORE", category: "DATABASE", description: "Restore database" },
  { name: "DATABASE_MANAGE", category: "DATABASE", description: "Full database management" },
  // Support
  { name: "SUPPORT_VIEW", category: "SUPPORT", description: "View support tickets" },
  { name: "SUPPORT_CREATE", category: "SUPPORT", description: "Create support tickets" },
  { name: "SUPPORT_UPDATE", category: "SUPPORT", description: "Update support tickets" },
  { name: "SUPPORT_MANAGE", category: "SUPPORT", description: "Full support management" },
  // Portal
  { name: "PORTAL_VIEW", category: "PORTAL", description: "View portal" },
  { name: "PORTAL_MANAGE", category: "PORTAL", description: "Full portal management" },
  // Analytics
  { name: "ANALYTICS_VIEW", category: "ANALYTICS", description: "View analytics" },
  { name: "ANALYTICS_EXPORT", category: "ANALYTICS", description: "Export analytics" },
  // Content
  { name: "CONTENT_VIEW", category: "CONTENT", description: "View content" },
  { name: "CONTENT_CREATE", category: "CONTENT", description: "Create content" },
  { name: "CONTENT_UPDATE", category: "CONTENT", description: "Update content" },
  { name: "CONTENT_DELETE", category: "CONTENT", description: "Delete content" },
  { name: "CONTENT_MANAGE", category: "CONTENT", description: "Full content management" },
  // Enrollments
  { name: "ENROLLMENTS_VIEW", category: "ENROLLMENTS", description: "View enrollments" },
  { name: "ENROLLMENTS_CREATE", category: "ENROLLMENTS", description: "Create enrollments" },
  { name: "ENROLLMENTS_UPDATE", category: "ENROLLMENTS", description: "Update enrollments" },
  { name: "ENROLLMENTS_MANAGE", category: "ENROLLMENTS", description: "Full enrollment management" },
]

// Role-Permission mappings
const ROLE_PERMISSIONS: Record<string, string[]> = {
  SUPER_ADMIN: PERMISSIONS.map(p => p.name), // All permissions
  SYSTEM_ADMIN: [
    "SYSTEM_VIEW", "SYSTEM_MONITOR", "SYSTEM_CONFIGURE", "SYSTEM_MANAGE",
    "STORAGE_VIEW", "STORAGE_UPLOAD", "STORAGE_DELETE", "STORAGE_MANAGE",
    "DATABASE_VIEW", "DATABASE_BACKUP", "DATABASE_RESTORE", "DATABASE_MANAGE",
    "SUPPORT_VIEW", "SUPPORT_UPDATE", "SUPPORT_MANAGE",
    "PORTAL_VIEW", "PORTAL_MANAGE",
    "ANALYTICS_VIEW", "ANALYTICS_EXPORT",
  ],
  ACADEMIC_DIRECTOR: [
    "DOMAINS_VIEW", "DOMAINS_CREATE", "DOMAINS_UPDATE", "DOMAINS_APPROVE",
    "CATEGORIES_VIEW", "CATEGORIES_CREATE", "CATEGORIES_UPDATE", "CATEGORIES_APPROVE",
    "COURSES_VIEW", "COURSES_CREATE", "COURSES_UPDATE", "COURSES_APPROVE",
    "PROJECTS_VIEW", "PROJECTS_REVIEW", "PROJECTS_GRADE",
    "CAPSTONES_VIEW", "CAPSTONES_REVIEW", "CAPSTONES_APPROVE",
    "CERTIFICATES_VIEW", "CERTIFICATES_MANAGE",
    "CONTENT_VIEW", "CONTENT_CREATE", "CONTENT_UPDATE", "CONTENT_DELETE", "CONTENT_MANAGE",
    "ENROLLMENTS_VIEW", "ENROLLMENTS_MANAGE",
    "ANALYTICS_VIEW", "ANALYTICS_EXPORT",
  ],
  HEAD_OF_DOMAIN: [
    "CATEGORIES_VIEW", "CATEGORIES_UPDATE",
    "COURSES_VIEW", "COURSES_UPDATE",
    "PROJECTS_VIEW", "PROJECTS_REVIEW", "PROJECTS_GRADE",
    "CAPSTONES_VIEW", "CAPSTONES_REVIEW", "CAPSTONES_APPROVE",
    "CONTENT_VIEW", "CONTENT_UPDATE",
    "ENROLLMENTS_VIEW",
    "ANALYTICS_VIEW",
  ],
  CATEGORY_LEAD: [
    "CATEGORIES_VIEW",
    "COURSES_VIEW", "COURSES_UPDATE",
    "PROJECTS_VIEW", "PROJECTS_REVIEW", "PROJECTS_GRADE",
    "CAPSTONES_VIEW", "CAPSTONES_REVIEW", "CAPSTONES_APPROVE",
    "CONTENT_VIEW", "CONTENT_UPDATE",
    "ENROLLMENTS_VIEW",
    "ANALYTICS_VIEW",
  ],
  INSTRUCTOR: [
    "COURSES_VIEW", "COURSES_UPDATE",
    "PROJECTS_VIEW", "PROJECTS_GRADE",
    "CONTENT_VIEW", "CONTENT_CREATE", "CONTENT_UPDATE",
    "ENROLLMENTS_VIEW",
  ],
  STUDENT: [
    "COURSES_VIEW",
    "PROJECTS_VIEW",
    "ENROLLMENTS_VIEW",
  ],
}

async function main() {
  console.log("🚀 Starting RBAC seed...\n")

  try {
    // 1. Create Roles
    console.log("📋 Creating roles...")
    for (const roleData of ROLES) {
      const role = await prisma.role.upsert({
        where: { name: roleData.name },
        update: roleData,
        create: roleData,
      })
      console.log(`  ✓ Role: ${role.displayName}`)
    }

    // 2. Create Permissions
    console.log("\n🔐 Creating permissions...")
    for (const permData of PERMISSIONS) {
      const perm = await prisma.permission.upsert({
        where: { name: permData.name },
        update: permData,
        create: permData,
      })
      console.log(`  ✓ Permission: ${perm.name}`)
    }

    // 3. Assign Permissions to Roles
    console.log("\n🔗 Assigning permissions to roles...")
    for (const [roleName, permNames] of Object.entries(ROLE_PERMISSIONS)) {
      const role = await prisma.role.findUnique({ where: { name: roleName } })
      if (!role) continue

      for (const permName of permNames) {
        const perm = await prisma.permission.findUnique({ where: { name: permName } })
        if (!perm) continue

        await prisma.rolePermission.upsert({
          where: {
            roleId_permissionId: { roleId: role.id, permissionId: perm.id },
          },
          update: {},
          create: { roleId: role.id, permissionId: perm.id },
        })
      }
      console.log(`  ✓ ${roleName}: ${permNames.length} permissions`)
    }

    // 4. Create Seed Users
    console.log("\n👤 Creating seed users...")
    for (const userData of SEED_USERS) {
      const hashedPassword = await bcrypt.hash(userData.password, 12)
      const role = await prisma.role.findUnique({ where: { name: userData.role } })
      
      if (!role) {
        console.log(`  ⚠️ Role ${userData.role} not found, skipping user ${userData.email}`)
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
        where: {
          userId_roleId: { userId: user.id, roleId: role.id },
        },
        update: { isActive: true },
        create: { userId: user.id, roleId: role.id },
      })

      // Assign portal
      await prisma.portalAssignment.upsert({
        where: { userId: user.id },
        update: { portal: userData.portal },
        create: { userId: user.id, portal: userData.portal },
      })

      console.log(`  ✓ ${userData.email} (${userData.roleName})`)
    }

    console.log("\n✅ RBAC seed completed successfully!\n")
    console.log("📝 Seed Users:\n")
    for (const userData of SEED_USERS) {
      console.log(`  ${userData.roleName} (${userData.portal} Portal):`)
      console.log(`    Email:    ${userData.email}`)
      console.log(`    Password: ${userData.password}`)
      console.log()
    }

  } catch (error) {
    console.error("\n❌ Error seeding RBAC:", error)
    throw error
  }
}

main()
  .catch((e) => {
    console.error("Fatal error:", e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
