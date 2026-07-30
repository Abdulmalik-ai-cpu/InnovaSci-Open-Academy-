import { NextRequest, NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams
    const includeInactive = searchParams.get("includeInactive") === "true"

    const where = includeInactive ? {} : { isActive: true }

    const categories = await prisma.category.findMany({
      where,
      include: {
        domain: true,
        _count: {
          select: { courses: true }
        }
      },
      orderBy: { orderIndex: 'asc' }
    })

    return NextResponse.json({
      success: true,
      data: categories
    })
  } catch (error) {
    console.error("Error fetching categories:", error)
    return NextResponse.json(
      { success: false, error: "Failed to fetch categories" },
      { status: 500 }
    )
  }
}
