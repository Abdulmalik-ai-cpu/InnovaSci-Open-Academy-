import { NextRequest, NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export const dynamic = 'force-dynamic'

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ courseId: string }> }
) {
  try {
    const { courseId } = await params

    const miniProject = await prisma.miniProject.findFirst({
      where: { courseId }
    })

    if (!miniProject) {
      return NextResponse.json({
        success: false,
        error: "Mini project not found"
      })
    }

    return NextResponse.json({
      success: true,
      data: miniProject
    })
  } catch (error) {
    console.error("Error fetching mini project:", error)
    return NextResponse.json(
      { success: false, error: "Failed to fetch mini project" },
      { status: 500 }
    )
  }
}
