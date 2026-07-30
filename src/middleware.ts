import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"

// Routes that should be exempted from maintenance mode
const EXEMPT_PATHS = [
  "/maintenance",
  "/auth/login",
  "/auth/signup",
  "/auth/forgot-password",
  "/api/auth",
  "/_next",
  "/favicon.ico",
  "/robots.txt",
  "/sitemap.xml",
]

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl
  
  // Check if path is exempt
  const isExempt = EXEMPT_PATHS.some((path) => pathname.startsWith(path))
  
  if (isExempt) {
    return NextResponse.next()
  }
  
  return NextResponse.next()
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|public/).*)",
  ],
}
