/**
 * InnovaSci Open Academy - PBAC Service
 * 
 * This module provides Policy-Based Access Control functionality.
 * PBAC extends RBAC by adding scope-based filtering.
 */

import { prisma } from '@/lib/prisma'
import { Role, ROLES } from './roles'

// Policy types
export const POLICY_TYPES = {
  DOMAIN: 'DOMAIN',
  CATEGORY: 'CATEGORY',
  COURSE: 'COURSE',
  USER: 'USER',
} as const

export type PolicyType = typeof POLICY_TYPES[keyof typeof POLICY_TYPES]

// Policy operators
export const POLICY_OPERATORS = {
  EQUALS: 'EQUALS',
  IN: 'IN',
  NOT_IN: 'NOT_IN',
  EXISTS: 'EXISTS',
  NOT_EXISTS: 'NOT_EXISTS',
} as const

export type PolicyOperator = typeof POLICY_OPERATORS[keyof typeof POLICY_OPERATORS]

// User scope context
export interface UserScope {
  userId: string
  role: Role
  domainIds: string[] // Domains the user can access
  categoryIds: string[] // Categories the user can access
  courseIds: string[] // Courses the user can access
}

// Get user's scope context
export async function getUserScope(userId: string): Promise<UserScope | null> {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      userRoles: {
        where: { isActive: true },
        include: { role: true },
      },
      domainAssignments: { where: { status: 'ACTIVE' } },
      categoryAssignments: { where: { status: 'ACTIVE' } },
      courseAssignments: { where: { status: 'ACTIVE' } },
    },
  })

  if (!user) return null

  // Get primary role (highest level)
  const primaryRole = user.userRoles.reduce<Role | null>((highest, ur) => {
    if (!highest) return ur.role.name as Role
    const highestLevel = getRoleLevel(highest)
    const currentLevel = getRoleLevel(ur.role.name as Role)
    return currentLevel > highestLevel ? ur.role.name as Role : highest
  }, null)

  if (!primaryRole) return null

  return {
    userId: user.id,
    role: primaryRole,
    domainIds: user.domainAssignments.map(da => da.domainId),
    categoryIds: user.categoryAssignments.map(ca => ca.categoryId),
    courseIds: user.courseAssignments.map(ca => ca.courseId),
  }
}

// Get role level
function getRoleLevel(role: Role): number {
  const levels: Record<Role, number> = {
    [ROLES.SUPER_ADMIN]: 100,
    [ROLES.SYSTEM_ADMIN]: 90,
    [ROLES.ACADEMIC_DIRECTOR]: 80,
    [ROLES.HEAD_OF_DOMAIN]: 70,
    [ROLES.CATEGORY_LEAD]: 60,
    [ROLES.INSTRUCTOR]: 50,
    [ROLES.STUDENT]: 10,
  }
  return levels[role] || 0
}

// Check if user can access a domain
export async function canAccessDomain(userId: string, domainId: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Super Admin and Academic Director can access all domains
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  // Head of Domain can only access assigned domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    return scope.domainIds.includes(domainId)
  }

  // Category Lead can access domains through their categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    // Check if any of user's categories belong to this domain
    const categories = await prisma.category.findMany({
      where: { id: { in: scope.categoryIds }, domainId },
      select: { id: true },
    })
    return categories.length > 0
  }

  // Instructor can access domains through their courses
  if (scope.role === ROLES.INSTRUCTOR) {
    const courses = await prisma.course.findMany({
      where: {
        id: { in: scope.courseIds },
        category: { domainId },
      },
      select: { id: true },
    })
    return courses.length > 0
  }

  return false
}

// Check if user can access a category
export async function canAccessCategory(userId: string, categoryId: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Super Admin and Academic Director can access all categories
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  // Head of Domain can access categories in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    const category = await prisma.category.findUnique({
      where: { id: categoryId },
      select: { domainId: true },
    })
    if (!category) return false
    return category.domainId ? scope.domainIds.includes(category.domainId) : false
  }

  // Category Lead can only access assigned categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    return scope.categoryIds.includes(categoryId)
  }

  // Instructor can access categories through their courses
  if (scope.role === ROLES.INSTRUCTOR) {
    const courses = await prisma.course.findMany({
      where: {
        id: { in: scope.courseIds },
        categoryId,
      },
      select: { id: true },
    })
    return courses.length > 0
  }

  return false
}

// Check if user can access a course
export async function canAccessCourse(userId: string, courseId: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Super Admin and Academic Director can access all courses
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  // Head of Domain can access courses in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      include: { category: true },
    })
    if (!course || !course.category) return false
    return course.category.domainId ? scope.domainIds.includes(course.category.domainId) : false
  }

  // Category Lead can access courses in their categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      select: { categoryId: true },
    })
    if (!course) return false
    return course.categoryId ? scope.categoryIds.includes(course.categoryId) : false
  }

  // Instructor can only access assigned courses
  if (scope.role === ROLES.INSTRUCTOR) {
    return scope.courseIds.includes(courseId)
  }

  return false
}

// Check if user can manage (create, update, delete) a domain
export async function canManageDomain(userId: string, domainId?: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Only Super Admin and Academic Director can manage domains
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  return false
}

// Check if user can manage (create, update, delete) a category
export async function canManageCategory(userId: string, categoryId?: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Super Admin and Academic Director can manage all categories
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  // Head of Domain can manage categories in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN && categoryId) {
    const category = await prisma.category.findUnique({
      where: { id: categoryId },
      select: { domainId: true },
    })
    if (!category) return false
    return category.domainId ? scope.domainIds.includes(category.domainId) : false
  }

  return false
}

// Check if user can manage (create, update, delete) a course
export async function canManageCourse(userId: string, courseId?: string): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  // Super Admin and Academic Director can manage all courses
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    return true
  }

  // Head of Domain can manage courses in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN && courseId) {
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      include: { category: true },
    })
    if (!course || !course.category) return false
    return course.category.domainId ? scope.domainIds.includes(course.category.domainId) : false
  }

  // Category Lead can manage courses in their categories
  if (scope.role === ROLES.CATEGORY_LEAD && courseId) {
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      select: { categoryId: true },
    })
    if (!course) return false
    return course.categoryId ? scope.categoryIds.includes(course.categoryId) : false
  }

  return false
}

// Get domains accessible by user
export async function getAccessibleDomains(userId: string): Promise<string[]> {
  const scope = await getUserScope(userId)
  if (!scope) return []

  // Super Admin and Academic Director can access all domains
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    const domains = await prisma.domain.findMany({
      where: { status: { not: 'ARCHIVED' } },
      select: { id: true },
    })
    return domains.map(d => d.id)
  }

  // Head of Domain can access assigned domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    return scope.domainIds
  }

  // Category Lead can access domains through their categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    const categories = await prisma.category.findMany({
      where: { id: { in: scope.categoryIds } },
      select: { domainId: true },
    })
    const domainIds = categories.map(c => c.domainId).filter((id): id is string => id !== null)
    return Array.from(new Set(domainIds))
  }

  // Instructor can access domains through their courses
  if (scope.role === ROLES.INSTRUCTOR) {
    const courses = await prisma.course.findMany({
      where: { id: { in: scope.courseIds } },
      include: { category: { select: { domainId: true } } },
    })
    const domainIds = courses
      .filter(c => c.category !== null)
      .map(c => c.category!.domainId)
      .filter((id): id is string => id !== null)
    return Array.from(new Set(domainIds))
  }

  return []
}

// Get categories accessible by user
export async function getAccessibleCategories(userId: string, domainId?: string): Promise<string[]> {
  const scope = await getUserScope(userId)
  if (!scope) return []

  // Super Admin and Academic Director can access all categories
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    const where: any = { status: 'ACTIVE' }
    if (domainId) where.domainId = domainId
    const categories = await prisma.category.findMany({
      where,
      select: { id: true },
    })
    return categories.map(c => c.id)
  }

  // Head of Domain can access categories in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    const where: any = { domainId: { in: scope.domainIds }, status: 'ACTIVE' }
    if (domainId) where.domainId = domainId
    const categories = await prisma.category.findMany({
      where,
      select: { id: true },
    })
    return categories.map(c => c.id)
  }

  // Category Lead can access assigned categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    const where: any = { id: { in: scope.categoryIds }, status: 'ACTIVE' }
    if (domainId) where.domainId = domainId
    const categories = await prisma.category.findMany({
      where,
      select: { id: true },
    })
    return categories.map(c => c.id)
  }

  // Instructor can access categories through their courses
  if (scope.role === ROLES.INSTRUCTOR) {
    const where: any = { status: 'ACTIVE', courses: { some: { id: { in: scope.courseIds } } } }
    if (domainId) where.domainId = domainId
    const categories = await prisma.category.findMany({
      where,
      select: { id: true },
    })
    return categories.map(c => c.id)
  }

  return []
}

// Get courses accessible by user
export async function getAccessibleCourses(userId: string, categoryId?: string): Promise<string[]> {
  const scope = await getUserScope(userId)
  if (!scope) return []

  // Super Admin and Academic Director can access all courses
  if (scope.role === ROLES.SUPER_ADMIN || scope.role === ROLES.ACADEMIC_DIRECTOR) {
    const where: any = { status: { not: 'archived' } }
    if (categoryId) where.categoryId = categoryId
    const courses = await prisma.course.findMany({
      where,
      select: { id: true },
    })
    return courses.map(c => c.id)
  }

  // Head of Domain can access courses in their domains
  if (scope.role === ROLES.HEAD_OF_DOMAIN) {
    const where: any = {
      category: { domainId: { in: scope.domainIds } },
      status: { not: 'archived' },
    }
    if (categoryId) where.categoryId = categoryId
    const courses = await prisma.course.findMany({
      where,
      select: { id: true },
    })
    return courses.map(c => c.id)
  }

  // Category Lead can access courses in their categories
  if (scope.role === ROLES.CATEGORY_LEAD) {
    const where: any = {
      categoryId: { in: scope.categoryIds },
      status: { not: 'archived' },
    }
    if (categoryId) where.categoryId = categoryId
    const courses = await prisma.course.findMany({
      where,
      select: { id: true },
    })
    return courses.map(c => c.id)
  }

  // Instructor can access assigned courses
  if (scope.role === ROLES.INSTRUCTOR) {
    const where: any = { id: { in: scope.courseIds }, status: { not: 'archived' } }
    if (categoryId) where.categoryId = categoryId
    const courses = await prisma.course.findMany({
      where,
      select: { id: true },
    })
    return courses.map(c => c.id)
  }

  return []
}

// Check if user can approve capstone
export async function canApproveCapstone(userId: string, capstoneType: 'mini' | 'category' | 'professional'): Promise<boolean> {
  const scope = await getUserScope(userId)
  if (!scope) return false

  switch (capstoneType) {
    case 'mini':
      // Instructor can approve mini projects
      return scope.role === ROLES.INSTRUCTOR || scope.role === ROLES.CATEGORY_LEAD || 
             scope.role === ROLES.HEAD_OF_DOMAIN || scope.role === ROLES.ACADEMIC_DIRECTOR ||
             scope.role === ROLES.SUPER_ADMIN
    case 'category':
      // Category Lead can approve category capstones
      return scope.role === ROLES.CATEGORY_LEAD || scope.role === ROLES.HEAD_OF_DOMAIN ||
             scope.role === ROLES.ACADEMIC_DIRECTOR || scope.role === ROLES.SUPER_ADMIN
    case 'professional':
      // Head of Domain can approve professional capstones
      return scope.role === ROLES.HEAD_OF_DOMAIN || scope.role === ROLES.ACADEMIC_DIRECTOR ||
             scope.role === ROLES.SUPER_ADMIN
    default:
      return false
  }
}
