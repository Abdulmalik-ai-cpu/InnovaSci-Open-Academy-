import { NextResponse } from "next/server"
import { getServerSession } from "next-auth"
import { getToken } from "next-auth/jwt"
import { authOptions } from "@/lib/auth"
import type { NextRequest } from "next/server"

export async function GET(request: NextRequest) {
  try {
    // Get session from NextAuth
    const session = await getServerSession(authOptions)
    
    // Get the JWT token
    const token = await getToken({ 
      req: request, 
      secret: process.env.NEXTAUTH_SECRET 
    })
    
    if (!session?.user) {
      return NextResponse.json({ user: null })
    }

    const role = token?.role as string | undefined

    const response = {
      user: {
        id: session.user.id || token?.id,
        email: session.user.email || token?.email,
        name: session.user.name || token?.name,
        role: role || "STUDENT"
      }
    }

    return NextResponse.json(response)
  } catch (error) {
    console.error("[Session API] Error:", error)
    return NextResponse.json({ user: null }, { status: 500 })
  }
}
