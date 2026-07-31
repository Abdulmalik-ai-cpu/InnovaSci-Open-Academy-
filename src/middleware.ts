import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"
import { getToken } from "next-auth/jwt"
import { ROLES, ROLE_PORTAL_MAP, PORTALS, Portal } from "@/lib/rbac/roles"

// Routes that require authentication
const PROTECTED_ROUTES = [
  '/instructor',
  '/academic',
  '/administration',
  '/dashboard',
]

// Portal prefixes
const PORTAL_ROUTES: Record<Portal, string> = {
  [PORTALS.INSTRUCTOR]: '/instructor',
  [PORTALS.ACADEMIC]: '/academic',
  [PORTALS.ADMINISTRATION]: '/administration',
  [PORTALS.STUDENT]: '/dashboard',
}

// Public routes (no authentication required)
const PUBLIC_ROUTES = [
  '/',
  '/auth/login',
  '/auth/signup',
  '/auth/forgot-password',
  '/courses',
  '/domains',
  '/learning-paths',
  '/scholarships',
  '/membership',
  '/contact',
  '/forum',
  '/knowledge-base',
  '/about',
  '/privacy',
  '/terms',
  '/forbidden',
  '/maintenance',
  '/offline',
]

// Exempt paths from middleware
const EXEMPT_PATHS = [
  "/maintenance",
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

  // Check if route is public
  const isPublicRoute = PUBLIC_ROUTES.some(route => pathname === route || pathname.startsWith(route + '/'))

  // Get the token
  const token = await getToken({ req: request, secret: process.env.NEXTAUTH_SECRET })
  const isAuthenticated = !!token

  // Redirect unauthenticated users from protected routes to login
  if (!isAuthenticated && !isPublicRoute) {
    const loginUrl = new URL('/auth/login', request.url)
    loginUrl.searchParams.set('callbackUrl', pathname)
    return NextResponse.redirect(loginUrl)
  }

  // If not authenticated, allow public routes
  if (!isAuthenticated) {
    return NextResponse.next()
  }

  // Get user's portal and role from token
  const userRole = (token.role as string) || ROLES.STUDENT
  const userPortal = (token.portal as string) || ROLE_PORTAL_MAP[userRole as keyof typeof ROLE_PORTAL_MAP] || PORTALS.STUDENT
  const userPortalRoute = PORTAL_ROUTES[userPortal as Portal]

  // Handle root redirect after login
  if (pathname === '/') {
    return NextResponse.redirect(new URL(userPortalRoute, request.url))
  }

  // Check if accessing a portal route
  const isPortalRoute = PROTECTED_ROUTES.some(route => pathname.startsWith(route))

  if (isPortalRoute) {
    // Determine which portal is being accessed
    let accessedPortal: Portal | null = null
    for (const [portal, route] of Object.entries(PORTAL_ROUTES)) {
      if (pathname.startsWith(route)) {
        accessedPortal = portal as Portal
        break
      }
    }

    // If no portal match, allow (e.g., /dashboard for students)
    if (!accessedPortal) {
      return NextResponse.next()
    }

    // Check if user is trying to access a different portal
    if (accessedPortal !== userPortal) {
      // User is trying to access a portal they don't belong to - return 403
      return NextResponse.redirect(new URL('/forbidden', request.url))
    }

    // User is in the correct portal - allow access
    return NextResponse.next()
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|public/).*)",
  ],
}
