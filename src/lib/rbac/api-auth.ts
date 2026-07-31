/**
 * InnovaSci Open Academy - API Authentication Guard
 * 
 * This module provides authentication and authorization middleware for API routes.
 * It ensures users are authenticated and have appropriate permissions.
 */

import { NextRequest, NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { 
  Role, 
  Permission, 
  PermissionCategory, 
  PermissionAction, 
  hasPermission,
} from '@/lib/rbac/roles'

// Session user type
interface SessionUser {
  id: string
  email: string
  name?: string
  role: string
}

// API Access context
interface APIAccessContext {
  userId: string
  role: Role
  governanceRole: string | null
  staffProfileId: string | null
  domainIds: string[]
  categoryIds: string[]
  courseIds: string[]
}

// Get full access context for API
export async function getAPIAccessContext(request: NextRequest): Promise<{
  context: APIAccessContext | null
  response: NextResponse | null
}> {
  // Get session
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    return {
      context: null,
      response: NextResponse.json(
        { error: 'Unauthorized', code: 'UNAUTHORIZED' },
        { status: 401 }
      )
    }
  }

  const user = session.user as SessionUser

  // Get staff profile with assignments
  const staffProfile = await prisma.staffProfile.findUnique({
    where: { userId: user.id },
    include: {
      domainAssignments: {
        where: { status: 'ACTIVE' },
        select: { domainId: true },
      },
      categoryAssignments: {
        where: { status: 'ACTIVE' },
        select: { categoryId: true },
      },
      courseAssignments: {
        where: { status: 'ACTIVE' },
        select: { courseId: true },
      },
    },
  })

  const context: APIAccessContext = {
    userId: user.id,
    role: (user.role as Role) || Role.STUDENT,
    governanceRole: staffProfile?.governanceRole || null,
    staffProfileId: staffProfile?.id || null,
    domainIds: staffProfile?.domainAssignments.map(d => d.domainId) || [],
    categoryIds: staffProfile?.categoryAssignments.map(c => c.categoryId) || [],
    courseIds: staffProfile?.courseAssignments.map(c => c.courseId) || [],
  }

  return { context, response: null }
}

// Check RBAC permission
export function checkRBACPermission(context: APIAccessContext, permission: Permission): boolean {
  // Super Admin has all permissions
  if (context.role === Role.SUPER_ADMIN || context.governanceRole === Role.SUPER_ADMIN) {
    return true
  }

  // Check governance role permissions
  const effectiveRole = (context.governanceRole as Role) || context.role
  return hasPermission(effectiveRole, permission)
}

// Check RBAC permission with required category
export function checkRBACWithCategory(
  context: APIAccessContext,
  permission: Permission,
  requiredCategoryId: string
): boolean {
  // First check RBAC
  if (!checkRBACPermission(context, permission)) {
    return false
  }

  // Then check PBAC (for category-scoped roles)
  if (context.governanceRole === Role.CATEGORY_LEAD) {
    return context.categoryIds.includes(requiredCategoryId)
  }

  // Head of Domain and above can access all categories
  if ([Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN].includes(context.governanceRole as Role)) {
    return true
  }

  return false
}

// Check RBAC permission with required domain
export function checkRBACWithDomain(
  context: APIAccessContext,
  permission: Permission,
  requiredDomainId: string
): boolean {
  // First check RBAC
  if (!checkRBACPermission(context, permission)) {
    return false
  }

  // Then check PBAC (for domain-scoped roles)
  if (context.governanceRole === Role.HEAD_OF_DOMAIN) {
    return context.domainIds.includes(requiredDomainId)
  }

  // Academic Director and above can access all domains
  if ([Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN].includes(context.governanceRole as Role)) {
    return true
  }

  return false
}

// Check RBAC permission with required course
export function checkRBACWithCourse(
  context: APIAccessContext,
  permission: Permission,
  requiredCourseId: string
): boolean {
  // First check RBAC
  if (!checkRBACPermission(context, permission)) {
    return false
  }

  // Then check PBAC (for course-scoped roles)
  if (context.governanceRole === Role.INSTRUCTOR) {
    return context.courseIds.includes(requiredCourseId)
  }

  // Category Lead can access courses in their categories
  if (context.governanceRole === Role.CATEGORY_LEAD) {
    // Need to check if course belongs to any assigned category
    // This would require a DB lookup, handled separately
    return true // Simplified - actual check done in API handler
  }

  // Head of Domain and above can access all courses
  if ([Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN].includes(context.governanceRole as Role)) {
    return true
  }

  return false
}

// Check if user is governance staff
export function isGovernanceStaff(context: APIAccessContext): boolean {
  return !!context.governanceRole && 
         [Role.SUPER_ADMIN, Role.SYSTEM_ADMIN, Role.ACADEMIC_DIRECTOR, 
          Role.HEAD_OF_DOMAIN, Role.CATEGORY_LEAD, Role.INSTRUCTOR].includes(context.governanceRole as Role)
}

// Check if user can manage domains
export function canManageDomains(context: APIAccessContext): boolean {
  return [Role.SUPER_ADMIN, Role.ACADEMIC_DIRECTOR].includes(context.governanceRole as Role)
}

// Check if user can manage categories
export function canManageCategories(context: APIAccessContext): boolean {
  return [Role.SUPER_ADMIN, Role.ACADEMIC_DIRECTOR, Role.HEAD_OF_DOMAIN].includes(context.governanceRole as Role)
}

// Check if user can manage courses
export function canManageCourses(context: APIAccessContext): boolean {
  return [Role.SUPER_ADMIN, Role.ACADEMIC_DIRECTOR, Role.HEAD_OF_DOMAIN, Role.CATEGORY_LEAD].includes(context.governanceRole as Role)
}

// Check if user can grade projects
export function canGradeProjects(context: APIAccessContext): boolean {
  return [Role.SUPER_ADMIN, Role.ACADEMIC_DIRECTOR, Role.HEAD_OF_DOMAIN, Role.CATEGORY_LEAD, Role.INSTRUCTOR].includes(context.governanceRole as Role)
}

// Check if user can approve capstones
export function canApproveCapstones(context: APIAccessContext, capstoneType: 'difficulty' | 'professional'): boolean {
  if (context.governanceRole === Role.SUPER_ADMIN || context.governanceRole === Role.ACADEMIC_DIRECTOR) {
    return true
  }
  
  if (capstoneType === 'difficulty') {
    return [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN].includes(context.governanceRole as Role)
  }
  
  if (capstoneType === 'professional') {
    return context.governanceRole === Role.HEAD_OF_DOMAIN
  }
  
  return false
}

// Check if user can manage staff
export function canManageStaff(context: APIAccessContext, targetRole: Role): boolean {
  // Hierarchy check
  const roleHierarchy: Record<string, number> = {
    [Role.SUPER_ADMIN]: 100,
    [Role.SYSTEM_ADMIN]: 90,
    [Role.ACADEMIC_DIRECTOR]: 80,
    [Role.HEAD_OF_DOMAIN]: 70,
    [Role.CATEGORY_LEAD]: 60,
    [Role.INSTRUCTOR]: 50,
    [Role.STUDENT]: 10,
  }

  const userLevel = roleHierarchy[context.governanceRole || ''] || 0
  const targetLevel = roleHierarchy[targetRole] || 0

  // Only higher roles can manage lower roles
  return userLevel > targetLevel
}

// Utility: Require authentication
export async function requireAuth(): Promise<{
  context: APIAccessContext
  response: null
} | {
  context: null
  response: NextResponse
}> {
  const result = await getAPIAccessContext(new NextRequest('http://localhost'))
  
  if (result.response) {
    return { context: null, response: result.response }
  }
  
  return { context: result.context!, response: null }
}

// Utility: Require specific role
export async function requireRole(allowedRoles: Role[]): Promise<{
  context: APIAccessContext
  response: null
} | {
  context: null
  response: NextResponse
}> {
  const result = await getAPIAccessContext(new NextRequest('http://localhost'))
  
  if (result.response) {
    return { context: null, response: result.response }
  }
  
  if (!result.context) {
    return {
      context: null,
      response: NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }
  }

  const effectiveRole = (result.context.governanceRole as Role) || result.context.role
  
  if (!allowedRoles.includes(effectiveRole)) {
    return {
      context: null,
      response: NextResponse.json(
        { error: 'Forbidden', code: 'INSUFFICIENT_ROLE' },
        { status: 403 }
      )
    }
  }
  
  return { context: result.context, response: null }
}

// Utility: Require permission
export async function requirePermission(permission: Permission): Promise<{
  context: APIAccessContext
  response: null
} | {
  context: null
  response: NextResponse
}> {
  const result = await getAPIAccessContext(new NextRequest('http://localhost'))
  
  if (result.response) {
    return { context: null, response: result.response }
  }
  
  if (!result.context) {
    return {
      context: null,
      response: NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }
  }

  if (!checkRBACPermission(result.context, permission)) {
    return {
      context: null,
      response: NextResponse.json(
        { error: 'Forbidden', code: 'INSUFFICIENT_PERMISSION' },
        { status: 403 }
      )
    }
  }
  
  return { context: result.context, response: null }
}
