import { NextRequest, NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"
import bcrypt from "bcryptjs"

const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { 
      email, 
      password, 
      fullName, 
      country, 
      countryCode,
      state,
      stateCode,
      city,
      streetAddress,
      postalCode,
      phone,
      currency,
      currencySymbol,
      timezone,
      preferredGateway,
      language
    } = body

    // Validate required fields
    if (!email || !password || !fullName) {
      return NextResponse.json(
        { error: "Email, password, and full name are required" },
        { status: 400 }
      )
    }

    if (!countryCode) {
      return NextResponse.json(
        { error: "Country is required" },
        { status: 400 }
      )
    }

    const normalizedEmail = email.trim().toLowerCase()
    if (!EMAIL_REGEX.test(normalizedEmail)) {
      return NextResponse.json(
        { error: "Invalid email format" },
        { status: 400 }
      )
    }

    if (password.length < 8) {
      return NextResponse.json(
        { error: "Password must be at least 8 characters" },
        { status: 400 }
      )
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12)

    // Create user in Prisma database
    try {
      console.log("[Register] Creating user:", normalizedEmail)
      
      // First check if user already exists
      const existingUser = await prisma.user.findUnique({
        where: { email: normalizedEmail }
      })
      
      if (existingUser) {
        return NextResponse.json(
          { error: "An account with this email already exists" },
          { status: 409 }
        )
      }
      
      // Create user with STUDENT role
      const user = await prisma.user.create({
        data: {
          email: normalizedEmail,
          passwordHash,
          role: "STUDENT",
          status: "ACTIVE",
          emailVerified: new Date(),
        },
      })

      console.log("[Register] User created:", user.id)

      // Keep new accounts aligned with the migrated RBAC model. The scalar
      // role remains the compatibility fallback, while these relations power
      // permissions and portal-aware authorization for seeded environments.
      const studentRole = await prisma.role.findUnique({
        where: { name: "STUDENT" },
      })

      if (studentRole) {
        await prisma.userRole.create({
          data: {
            userId: user.id,
            roleId: studentRole.id,
            isActive: true,
          },
        })
      }

      await prisma.portalAssignment.create({
        data: {
          userId: user.id,
          portal: "STUDENT",
        },
      })

      // Create profile
      await prisma.profile.create({
        data: {
          userId: user.id,
          fullName: fullName.trim(),
          username: normalizedEmail.split("@")[0].toLowerCase(),
          country: country || null,
          countryCode: countryCode || null,
          state: state || null,
          stateCode: stateCode || null,
          city: city || null,
          streetAddress: streetAddress || null,
          postalCode: postalCode || null,
          phone: phone || null,
          currency: currency || null,
          currencySymbol: currencySymbol || null,
          language: language || null,
          timezone: timezone || null,
          preferredGateway: preferredGateway || null,
          preferences: timezone ? { timezone } : {},
        },
      })

      console.log("[Register] Profile created for user:", user.id)

      // Get user with profile
      const userWithProfile = await prisma.user.findUnique({
        where: { id: user.id },
        include: { profile: true }
      })

      return NextResponse.json(
        {
          success: true,
          message: "Account created successfully",
          user: {
            id: user.id,
            email: user.email,
            role: user.role,
            profile: userWithProfile?.profile,
          },
        },
        { status: 201 }
      )
    } catch (prismaError: any) {
      console.error("[Register] Prisma error:", prismaError?.message)
      console.error("[Register] Error code:", prismaError?.code)
      
      // Handle specific Prisma errors
      if (prismaError?.code === 'P2002') {
        return NextResponse.json(
          { error: "An account with this email already exists" },
          { status: 409 }
        )
      }
      
      // Handle connection errors specifically
      const errorMessage = prismaError?.message?.toLowerCase() || ''
      if (errorMessage.includes('connection refused') || 
          errorMessage.includes('connect ETIMEDOUT') ||
          errorMessage.includes('connect ECONNREFUSED') ||
          errorMessage.includes('connection timeout')) {
        return NextResponse.json(
          { error: "Database connection error. Please try again later." },
          { status: 503 }
        )
      }
      
      // Generic error for any other Prisma issue
      return NextResponse.json(
        { error: "Registration failed. Please try again." },
        { status: 500 }
      )
    }
  } catch (error: any) {
    console.error("[Register] Unexpected error:", error)
    
    return NextResponse.json(
      { error: "Registration failed. Please try again." },
      { status: 500 }
    )
  }
}
