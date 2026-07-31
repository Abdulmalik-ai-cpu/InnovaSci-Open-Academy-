import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

// POST /api/setup - Seed database with sample academic content (no admin user)
// This endpoint creates sample categories and courses for demonstration purposes
export async function POST() {
  try {
    console.log("Starting database setup...")

    // Find or create Domains
    let domainTech = await prisma.domain.findFirst({
      where: { slug: "technology" }
    })
    if (!domainTech) {
      domainTech = await prisma.domain.create({
        data: { 
          name: "Technology", 
          slug: "technology",
          shortDescription: "Technology and software development courses"
        }
      })
    }

    let domainBusiness = await prisma.domain.findFirst({
      where: { slug: "business" }
    })
    if (!domainBusiness) {
      domainBusiness = await prisma.domain.create({
        data: { 
          name: "Business", 
          slug: "business",
          shortDescription: "Business and entrepreneurship courses"
        }
      })
    }

    // Find or create Categories
    let catDataScience = await prisma.category.findFirst({
      where: { slug: "data-science", domainId: domainTech.id }
    })
    if (!catDataScience) {
      catDataScience = await prisma.category.create({
        data: { name: "Data Science", slug: "data-science", domainId: domainTech.id }
      })
    }
    
    let catWebDev = await prisma.category.findFirst({
      where: { slug: "web-development", domainId: domainTech.id }
    })
    if (!catWebDev) {
      catWebDev = await prisma.category.create({
        data: { name: "Web Development", slug: "web-development", domainId: domainTech.id }
      })
    }
    
    let catMobileDev = await prisma.category.findFirst({
      where: { slug: "mobile-development", domainId: domainTech.id }
    })
    if (!catMobileDev) {
      catMobileDev = await prisma.category.create({
        data: { name: "Mobile Development", slug: "mobile-development", domainId: domainTech.id }
      })
    }

    // Initialize System Settings
    await prisma.systemSetting.upsert({
      where: { key: "maintenance_mode" },
      update: {},
      create: {
        key: "maintenance_mode",
        value: "false",
        type: "boolean",
        category: "general",
        description: "Enable maintenance mode to block student access",
        isPublic: true,
      },
    })
    await prisma.systemSetting.upsert({
      where: { key: "maintenance_message" },
      update: {},
      create: {
        key: "maintenance_message",
        value: "We are performing scheduled maintenance. Please check back soon.",
        type: "string",
        category: "general",
        description: "Message to display during maintenance mode",
        isPublic: true,
      },
    })
    console.log("✓ System settings initialized")

    // Create Sample Courses
    const course1 = await prisma.course.upsert({
      where: { slug: "introduction-to-data-science" },
      update: {},
      create: {
        title: "Introduction to Data Science",
        slug: "introduction-to-data-science",
        categoryId: catDataScience.id,
        shortDescription: "Learn the fundamentals of data science with Python and R",
        fullDescription: "This comprehensive course covers data analysis, visualization, machine learning, and statistical modeling.",
        difficultyLevel: "beginner",
        language: "English",
        durationHours: 40,
        price: 99.99,
        isFree: false,
        status: "published",
        introVideoUrl: "https://example.com/intro",
      },
    })

    const course2 = await prisma.course.upsert({
      where: { slug: "web-development-masterclass" },
      update: {},
      create: {
        title: "Web Development Masterclass",
        slug: "web-development-masterclass",
        categoryId: catWebDev.id,
        shortDescription: "Full-stack web development with React, Node.js, and modern tools",
        fullDescription: "Learn to build modern web applications from scratch using cutting-edge technologies.",
        difficultyLevel: "intermediate",
        language: "English",
        durationHours: 60,
        price: 149.99,
        isFree: false,
        status: "published",
        introVideoUrl: "https://example.com/intro",
      },
    })

    const course3 = await prisma.course.upsert({
      where: { slug: "mobile-app-development" },
      update: {},
      create: {
        title: "Mobile App Development",
        slug: "mobile-app-development",
        categoryId: catMobileDev.id,
        shortDescription: "Build iOS and Android apps with React Native",
        difficultyLevel: "intermediate",
        language: "English",
        durationHours: 45,
        price: 0,
        isFree: true,
        status: "published",
        introVideoUrl: "https://example.com/intro",
      },
    })
    console.log("✓ 3 courses created")

    // Create Module and Lessons for course1
    const module1 = await prisma.module.upsert({
      where: { courseId_orderIndex: { courseId: course1.id, orderIndex: 0 } },
      update: {},
      create: {
        courseId: course1.id,
        title: "Getting Started",
        description: "Introduction and setup",
        orderIndex: 0,
      },
    })
    
    await prisma.lesson.upsert({
      where: { id: "lesson-1" },
      update: {},
      create: {
        id: "lesson-1",
        courseId: course1.id,
        moduleId: module1.id,
        title: "Welcome to Data Science",
        description: "Course overview",
        orderIndex: 0,
        lessonType: "video",
        duration: 600,
      },
    })
    
    await prisma.lesson.upsert({
      where: { id: "lesson-2" },
      update: {},
      create: {
        id: "lesson-2",
        courseId: course1.id,
        moduleId: module1.id,
        title: "Setting Up Your Environment",
        description: "Install Python and Jupyter",
        orderIndex: 1,
        lessonType: "video",
        duration: 1200,
      },
    })
    console.log("✓ Module and lessons created")


    return NextResponse.json({
      success: true,
      message: "Setup completed successfully! Sample academic content created."
    })

  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : String(error)
    console.error("Setup error:", errorMessage)
    return NextResponse.json(
      { success: false, error: "Setup failed", details: errorMessage },
      { status: 500 }
    )
  }
}

// GET /api/setup - Check database status
export async function GET() {
  try {
    const [userCount, courseCount, enrollmentCount] = await Promise.all([
      prisma.user.count(),
      prisma.course.count(),
      prisma.enrollment.count(),
    ])

    return NextResponse.json({
      success: true,
      databaseConnected: true,
      data: {
        users: userCount,
        courses: courseCount,
        enrollments: enrollmentCount
      },
      needsSetup: courseCount === 0
    })
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : String(error)
    return NextResponse.json({
      success: false,
      databaseConnected: false,
      error: errorMessage,
      needsSetup: true
    })
  }
}
