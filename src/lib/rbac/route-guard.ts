/**
 * InnovaSci Open Academy - Route Guard
 * 
 * This module provides route-level access control for governance portals.
 * It ensures users can only access routes appropriate for their role.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role, Permission, PermissionCategory, PermissionAction, hasPermission } from '@/lib/rbac/roles'
import { getDashboardRouteByRole, DASHBOARD_ROUTES } from '@/lib/navigation'

// Route permission requirements
interface RouteRequirement {
  requiredRole?: Role | Role[]
  requiredPermission?: Permission
  requiredCategory?: PermissionCategory
  requiredAction?: PermissionAction
  allowSuperAdmin?: boolean
  allowSystemAdmin?: boolean
  allowAcademicDirector?: boolean
  allowHeadOfDomain?: boolean
  allowCategoryLead?: boolean
  allowInstructor?: boolean
  assignedDomainRequired?: boolean
  assignedCategoryRequired?: boolean
  assignedCourseRequired?: boolean
}

// Dashboard route requirements
export const DASHBOARD_ROUTE_REQUIREMENTS: Record<string, RouteRequirement> = {
  // Super Admin Routes
  '/governance/super-admin': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/domains': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/categories': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/courses': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/users': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/roles': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/settings': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },
  '/governance/super-admin/audit-logs': {
    requiredRole: Role.SUPER_ADMIN,
    allowSuperAdmin: true,
  },

  // System Admin Routes
  '/governance/system-admin': {
    requiredRole: [Role.SYSTEM_ADMIN, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowSystemAdmin: true,
  },
  '/governance/system-admin/storage': {
    requiredRole: [Role.SYSTEM_ADMIN, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowSystemAdmin: true,
  },
  '/governance/system-admin/database': {
    requiredRole: [Role.SYSTEM_ADMIN, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowSystemAdmin: true,
  },
  '/governance/system-admin/settings': {
    requiredRole: [Role.SYSTEM_ADMIN, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowSystemAdmin: true,
  },

  // Academic Director Routes
  '/governance/academic-director': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },
  '/governance/academic-director/domains': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },
  '/governance/academic-director/categories': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },
  '/governance/academic-director/courses': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },
  '/governance/academic-director/instructors': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },
  '/governance/academic-director/capstones': {
    requiredRole: [Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
  },

  // Head of Domain Routes
  '/governance/head-of-domain': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/my-domain': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/categories': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/courses': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/category-leads': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/instructors': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },
  '/governance/head-of-domain/capstones': {
    requiredRole: [Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    assignedDomainRequired: true,
  },

  // Category Lead Routes
  '/governance/category-lead': {
    requiredRole: [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    assignedCategoryRequired: true,
  },
  '/governance/category-lead/my-category': {
    requiredRole: [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    assignedCategoryRequired: true,
  },
  '/governance/category-lead/courses': {
    requiredRole: [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    assignedCategoryRequired: true,
  },
  '/governance/category-lead/instructors': {
    requiredRole: [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    assignedCategoryRequired: true,
  },
  '/governance/category-lead/category-capstone': {
    requiredRole: [Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    assignedCategoryRequired: true,
  },

  // Instructor Routes
  '/governance/instructor': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/courses': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/lessons': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/mini-projects': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/submissions': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/grades': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
  '/governance/instructor/students': {
    requiredRole: [Role.INSTRUCTOR, Role.CATEGORY_LEAD, Role.HEAD_OF_DOMAIN, Role.ACADEMIC_DIRECTOR, Role.SUPER_ADMIN],
    allowSuperAdmin: true,
    allowAcademicDirector: true,
    allowHeadOfDomain: true,
    allowCategoryLead: true,
    allowInstructor: true,
    assignedCourseRequired: true,
  },
}

// Check if role is in allowed roles
function isRoleAllowed(userRole: string, allowedRoles?: Role | Role[]): boolean {
  if (!allowedRoles) return false
  if (Array.isArray(allowedRoles)) {
    return allowedRoles.includes(userRole as Role)
  }
  return userRole === allowedRoles
}

// Get user's governance scope
async function getUserGovernanceScope(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      staffProfile: {
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
      },
    },
  })

  if (!user?.staffProfile) {
    return null
  }

  return {
    governanceRole: user.staffProfile.governanceRole as Role,
    domainIds: user.staffProfile.domainAssignments.map(d => d.domainId),
    categoryIds: user.staffProfile.categoryAssignments.map(c => c.categoryId),
    courseIds: user.staffProfile.courseAssignments.map(c => c.courseId),
  }
}

// Route guard function
export async function checkRouteAccess(
  path: string,
  userId: string
): Promise<{ allowed: boolean; redirect?: string; error?: string }> {
  // Get route requirements
  const requirements = DASHBOARD_ROUTE_REQUIREMENTS[path]

  // If no specific requirements, allow access
  if (!requirements) {
    return { allowed: true }
  }

  // Get user's governance scope
  const scope = await getUserGovernanceScope(userId)

  if (!scope) {
    return { 
      allowed: false, 
      redirect: '/forbidden',
      error: 'No governance role assigned' 
    }
  }

  // Check role-based access
  if (requirements.requiredRole) {
    if (!isRoleAllowed(scope.governanceRole, requirements.requiredRole)) {
      // Redirect to appropriate dashboard
      const redirect = getDashboardRouteByRole(scope.governanceRole)
      return { 
        allowed: false, 
        redirect: redirect !== path ? redirect : '/forbidden',
        error: 'Insufficient role permissions' 
      }
    }
  }

  // Check domain assignment requirement
  if (requirements.assignedDomainRequired) {
    if (scope.domainIds.length === 0 && scope.governanceRole === Role.HEAD_OF_DOMAIN) {
      return { 
        allowed: false, 
        redirect: '/forbidden',
        error: 'No domain assigned' 
      }
    }
  }

  // Check category assignment requirement
  if (requirements.assignedCategoryRequired) {
    if (scope.categoryIds.length === 0 && scope.governanceRole === Role.CATEGORY_LEAD) {
      return { 
        allowed: false, 
        redirect: '/forbidden',
        error: 'No category assigned' 
      }
    }
  }

  // Check course assignment requirement
  if (requirements.assignedCourseRequired) {
    if (scope.courseIds.length === 0 && scope.governanceRole === Role.INSTRUCTOR) {
      return { 
        allowed: false, 
        redirect: '/forbidden',
        error: 'No courses assigned' 
      }
    }
  }

  return { allowed: true }
}

// Middleware helper for Next.js
export function unauthorizedResponse(message?: string) {
  return NextResponse.json(
    { error: message || 'Unauthorized', code: 'UNAUTHORIZED' },
    { status: 401 }
  )
}

export function forbiddenResponse(message?: string) {
  return NextResponse.json(
    { error: message || 'Access denied', code: 'FORBIDDEN' },
    { status: 403 }
  )
}
