/**
 * InnovaSci Open Academy - RBAC Service
 * 
 * This module provides Role-Based Access Control functionality.
 */

import { prisma } from '@/lib/prisma'
import { Role, ROLES, ROLE_PORTAL_MAP, PORTALS, Portal, ROLE_HIERARCHY } from './roles'
import { Permission, PERMISSIONS } from './permissions'

// Session user type
export interface SessionUser {
  id: string
  email: string
  name?: string
  role: string
  portal?: string
  permissions?: string[]
}

// Check if user has a specific permission
export async function hasPermission(userId: string, permission: Permission): Promise<boolean> {
  // Get user with roles
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      userRoles: {
        where: { isActive: true },
        include: {
          role: {
            include: {
              permissions: {
                include: {
                  permission: true,
                },
              },
            },
          },
        },
      },
    },
  })

  if (!user) return false

  // Check if any role has the permission
  for (const userRole of user.userRoles) {
    for (const rolePermission of userRole.role.permissions) {
      if (rolePermission.permission.name === permission && rolePermission.permission.isActive) {
        return true
      }
    }
  }

  return false
}

// Check if user has any of the specified permissions
export async function hasAnyPermission(userId: string, permissions: Permission[]): Promise<boolean> {
  for (const permission of permissions) {
    if (await hasPermission(userId, permission)) {
      return true
    }
  }
  return false
}

// Check if user has all specified permissions
export async function hasAllPermissions(userId: string, permissions: Permission[]): Promise<boolean> {
  for (const permission of permissions) {
    if (!(await hasPermission(userId, permission))) {
      return false
    }
  }
  return true
}

// Get user's primary role
export async function getUserPrimaryRole(userId: string): Promise<Role | null> {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      userRoles: {
        where: { isActive: true },
        orderBy: {
          role: {
            level: 'desc',
          },
        },
        take: 1,
        include: {
          role: true,
        },
      },
    },
  })

  return user?.userRoles[0]?.role?.name as Role || null
}

// Get user's portal
export async function getUserPortal(userId: string): Promise<Portal | null> {
  const role = await getUserPrimaryRole(userId)
  if (!role) return null
  return ROLE_PORTAL_MAP[role]
}

// Get user's permissions
export async function getUserPermissions(userId: string): Promise<Permission[]> {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      userRoles: {
        where: { isActive: true },
        include: {
          role: {
            include: {
              permissions: {
                include: {
                  permission: true,
                },
              },
            },
          },
        },
      },
    },
  })

  if (!user) return []

  const permissions = new Set<Permission>()
  
  for (const userRole of user.userRoles) {
    for (const rolePermission of userRole.role.permissions) {
      if (rolePermission.permission.isActive) {
        permissions.add(rolePermission.permission.name as Permission)
      }
    }
  }

  return Array.from(permissions)
}

// Check if user role has required role level
export function hasRoleLevel(userRole: Role, requiredRole: Role): boolean {
  return ROLE_HIERARCHY[userRole] >= ROLE_HIERARCHY[requiredRole]
}

// Get all roles
export async function getAllRoles(): Promise<Array<{ id: string; name: string; displayName: string; portal: string; level: number }>> {
  const roles = await prisma.role.findMany({
    where: { isActive: true },
    orderBy: { level: 'desc' },
  })

  return roles.map(r => ({
    id: r.id,
    name: r.name,
    displayName: r.displayName,
    portal: r.portal,
    level: r.level,
  }))
}

// Get role by name
export async function getRoleByName(name: string) {
  return prisma.role.findUnique({
    where: { name },
    include: {
      permissions: {
        include: {
          permission: true,
        },
      },
    },
  })
}

// Assign role to user
export async function assignRoleToUser(userId: string, roleName: string): Promise<void> {
  const role = await prisma.role.findUnique({ where: { name: roleName } })
  if (!role) throw new Error(`Role ${roleName} not found`)

  await prisma.userRole.upsert({
    where: {
      userId_roleId: { userId, roleId: role.id },
    },
    create: { userId, roleId: role.id },
    update: { isActive: true },
  })

  // Update portal assignment
  await prisma.portalAssignment.upsert({
    where: { userId },
    create: { userId, portal: role.portal },
    update: { portal: role.portal },
  })
}

// Remove role from user
export async function removeRoleFromUser(userId: string, roleName: string): Promise<void> {
  const role = await prisma.role.findUnique({ where: { name: roleName } })
  if (!role) return

  await prisma.userRole.update({
    where: {
      userId_roleId: { userId, roleId: role.id },
    },
    data: { isActive: false },
  })
}

// Initialize default roles and permissions in database
export async function initializeRBAC(): Promise<void> {
  // Create roles
  const rolesData = [
    { name: ROLES.SUPER_ADMIN, displayName: 'Super Administrator', portal: PORTALS.ADMINISTRATION, level: 100, description: 'Full platform access' },
    { name: ROLES.SYSTEM_ADMIN, displayName: 'System Administrator', portal: PORTALS.ADMINISTRATION, level: 90, description: 'Technical operations' },
    { name: ROLES.ACADEMIC_DIRECTOR, displayName: 'Academic Director', portal: PORTALS.ACADEMIC, level: 80, description: 'Academic governance' },
    { name: ROLES.HEAD_OF_DOMAIN, displayName: 'Head of Domain', portal: PORTALS.ACADEMIC, level: 70, description: 'Domain management' },
    { name: ROLES.CATEGORY_LEAD, displayName: 'Category Lead', portal: PORTALS.ACADEMIC, level: 60, description: 'Category management' },
    { name: ROLES.INSTRUCTOR, displayName: 'Instructor', portal: PORTALS.INSTRUCTOR, level: 50, description: 'Course instruction' },
    { name: ROLES.STUDENT, displayName: 'Student', portal: PORTALS.STUDENT, level: 10, description: 'Learning access' },
  ]

  for (const roleData of rolesData) {
    await prisma.role.upsert({
      where: { name: roleData.name },
      create: roleData,
      update: roleData,
    })
  }

  // Create all permissions
  for (const [key, perm] of Object.entries(PERMISSIONS)) {
    await prisma.permission.upsert({
      where: { name: perm.name },
      create: {
        name: perm.name,
        category: perm.category,
        description: perm.description,
      },
      update: {
        category: perm.category,
        description: perm.description,
      },
    })
  }

  // Assign permissions to roles
  await assignPermissionsToRoles()
}

async function assignPermissionsToRoles(): Promise<void> {
  // Super Admin - all permissions
  const superAdminRole = await prisma.role.findUnique({ where: { name: ROLES.SUPER_ADMIN } })
  const allPermissions = await prisma.permission.findMany()
  
  if (superAdminRole) {
    for (const perm of allPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: superAdminRole.id, permissionId: perm.id },
        },
        create: { roleId: superAdminRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // System Admin - system, storage, database, support, portal permissions
  const systemAdminRole = await prisma.role.findUnique({ where: { name: ROLES.SYSTEM_ADMIN } })
  const systemPermissions = await prisma.permission.findMany({
    where: {
      category: { in: ['SYSTEM', 'STORAGE', 'DATABASE', 'SUPPORT', 'PORTAL', 'ANALYTICS'] },
    },
  })

  if (systemAdminRole) {
    for (const perm of systemPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: systemAdminRole.id, permissionId: perm.id },
        },
        create: { roleId: systemAdminRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // Academic Director - all academic permissions
  const academicDirectorRole = await prisma.role.findUnique({ where: { name: ROLES.ACADEMIC_DIRECTOR } })
  const academicPermissions = await prisma.permission.findMany({
    where: {
      category: {
        in: ['DOMAINS', 'CATEGORIES', 'COURSES', 'CERTIFICATES', 'ENROLLMENTS', 'PROJECTS', 'CONTENT', 'ANALYTICS'],
      },
    },
  })

  if (academicDirectorRole) {
    for (const perm of academicPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: academicDirectorRole.id, permissionId: perm.id },
        },
        create: { roleId: academicDirectorRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // Head of Domain - domain scoped permissions
  const headOfDomainRole = await prisma.role.findUnique({ where: { name: ROLES.HEAD_OF_DOMAIN } })
  const hodPermissions = await prisma.permission.findMany({
    where: {
      category: { in: ['CATEGORIES', 'COURSES', 'PROJECTS', 'CONTENT', 'ANALYTICS'] },
      name: { in: ['CATEGORIES_VIEW', 'COURSES_VIEW', 'PROJECTS_VIEW', 'CONTENT_VIEW', 'ANALYTICS_VIEW',
                   'CATEGORIES_UPDATE', 'COURSES_UPDATE', 'CONTENT_UPDATE', 'PROJECTS_REVIEW',
                   'CAPSTONES_VIEW', 'CAPSTONES_REVIEW'] },
    },
  })

  if (headOfDomainRole) {
    for (const perm of hodPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: headOfDomainRole.id, permissionId: perm.id },
        },
        create: { roleId: headOfDomainRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // Category Lead - category scoped permissions
  const categoryLeadRole = await prisma.role.findUnique({ where: { name: ROLES.CATEGORY_LEAD } })
  const clPermissions = await prisma.permission.findMany({
    where: {
      category: { in: ['COURSES', 'PROJECTS', 'CONTENT'] },
      name: { in: ['COURSES_VIEW', 'COURSES_UPDATE', 'PROJECTS_VIEW', 'PROJECTS_REVIEW', 'PROJECTS_GRADE',
                   'CONTENT_VIEW', 'CONTENT_UPDATE', 'CAPSTONES_VIEW', 'CAPSTONES_REVIEW', 'ANALYTICS_VIEW'] },
    },
  })

  if (categoryLeadRole) {
    for (const perm of clPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: categoryLeadRole.id, permissionId: perm.id },
        },
        create: { roleId: categoryLeadRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // Instructor - course scoped permissions
  const instructorRole = await prisma.role.findUnique({ where: { name: ROLES.INSTRUCTOR } })
  const instructorPermissions = await prisma.permission.findMany({
    where: {
      category: { in: ['COURSES', 'ENROLLMENTS', 'PROJECTS', 'CONTENT'] },
      name: { in: ['COURSES_VIEW', 'COURSES_UPDATE', 'ENROLLMENTS_VIEW', 'PROJECTS_VIEW', 'PROJECTS_GRADE',
                   'CONTENT_VIEW', 'CONTENT_CREATE', 'CONTENT_UPDATE'] },
    },
  })

  if (instructorRole) {
    for (const perm of instructorPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: instructorRole.id, permissionId: perm.id },
        },
        create: { roleId: instructorRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }

  // Student - basic view permissions
  const studentRole = await prisma.role.findUnique({ where: { name: ROLES.STUDENT } })
  const studentPermissions = await prisma.permission.findMany({
    where: {
      category: { in: ['COURSES', 'ENROLLMENTS', 'PROJECTS'] },
      name: { in: ['COURSES_VIEW', 'ENROLLMENTS_VIEW', 'PROJECTS_VIEW'] },
    },
  })

  if (studentRole) {
    for (const perm of studentPermissions) {
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: studentRole.id, permissionId: perm.id },
        },
        create: { roleId: studentRole.id, permissionId: perm.id },
        update: {},
      })
    }
  }
}
