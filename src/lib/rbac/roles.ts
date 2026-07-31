/**
 * InnovaSci Open Academy - Role Definitions
 * 
 * This file defines all roles, their hierarchy, and associated portals.
 */

// Portals
export const PORTALS = {
  INSTRUCTOR: 'INSTRUCTOR',
  ACADEMIC: 'ACADEMIC',
  ADMINISTRATION: 'ADMINISTRATION',
  STUDENT: 'STUDENT',
} as const

export type Portal = typeof PORTALS[keyof typeof PORTALS]

// Roles
export const ROLES = {
  SUPER_ADMIN: 'SUPER_ADMIN',
  SYSTEM_ADMIN: 'SYSTEM_ADMIN',
  ACADEMIC_DIRECTOR: 'ACADEMIC_DIRECTOR',
  HEAD_OF_DOMAIN: 'HEAD_OF_DOMAIN',
  CATEGORY_LEAD: 'CATEGORY_LEAD',
  INSTRUCTOR: 'INSTRUCTOR',
  STUDENT: 'STUDENT',
} as const

export type Role = typeof ROLES[keyof typeof ROLES]

// Role to Portal mapping
export const ROLE_PORTAL_MAP: Record<Role, Portal> = {
  [ROLES.SUPER_ADMIN]: PORTALS.ADMINISTRATION,
  [ROLES.SYSTEM_ADMIN]: PORTALS.ADMINISTRATION,
  [ROLES.ACADEMIC_DIRECTOR]: PORTALS.ACADEMIC,
  [ROLES.HEAD_OF_DOMAIN]: PORTALS.ACADEMIC,
  [ROLES.CATEGORY_LEAD]: PORTALS.ACADEMIC,
  [ROLES.INSTRUCTOR]: PORTALS.INSTRUCTOR,
  [ROLES.STUDENT]: PORTALS.STUDENT,
}

// Role hierarchy (higher level = more authority)
export const ROLE_HIERARCHY: Record<Role, number> = {
  [ROLES.SUPER_ADMIN]: 100,
  [ROLES.SYSTEM_ADMIN]: 90,
  [ROLES.ACADEMIC_DIRECTOR]: 80,
  [ROLES.HEAD_OF_DOMAIN]: 70,
  [ROLES.CATEGORY_LEAD]: 60,
  [ROLES.INSTRUCTOR]: 50,
  [ROLES.STUDENT]: 10,
}

// Role display names
export const ROLE_DISPLAY_NAMES: Record<Role, string> = {
  [ROLES.SUPER_ADMIN]: 'Super Administrator',
  [ROLES.SYSTEM_ADMIN]: 'System Administrator',
  [ROLES.ACADEMIC_DIRECTOR]: 'Academic Director',
  [ROLES.HEAD_OF_DOMAIN]: 'Head of Domain',
  [ROLES.CATEGORY_LEAD]: 'Category Lead',
  [ROLES.INSTRUCTOR]: 'Instructor',
  [ROLES.STUDENT]: 'Student',
}

// Portal display names
export const PORTAL_DISPLAY_NAMES: Record<Portal, string> = {
  [PORTALS.INSTRUCTOR]: 'Instructor Portal',
  [PORTALS.ACADEMIC]: 'Academic Portal',
  [PORTALS.ADMINISTRATION]: 'Administration Portal',
  [PORTALS.STUDENT]: 'Student Portal',
}

// Default redirects per role after login
export const ROLE_DEFAULT_REDIRECT: Record<Role, string> = {
  [ROLES.SUPER_ADMIN]: '/administration',
  [ROLES.SYSTEM_ADMIN]: '/administration',
  [ROLES.ACADEMIC_DIRECTOR]: '/academic',
  [ROLES.HEAD_OF_DOMAIN]: '/academic',
  [ROLES.CATEGORY_LEAD]: '/academic',
  [ROLES.INSTRUCTOR]: '/instructor',
  [ROLES.STUDENT]: '/dashboard',
}

// Role descriptions
export const ROLE_DESCRIPTIONS: Record<Role, string> = {
  [ROLES.SUPER_ADMIN]: 'Full platform access with unrestricted authority',
  [ROLES.SYSTEM_ADMIN]: 'Technical operations and infrastructure management',
  [ROLES.ACADEMIC_DIRECTOR]: 'Highest academic authority, governs all academic activities',
  [ROLES.HEAD_OF_DOMAIN]: 'Manages assigned domain and its categories',
  [ROLES.CATEGORY_LEAD]: 'Manages assigned category and its courses',
  [ROLES.INSTRUCTOR]: 'Manages assigned courses and enrolled students',
  [ROLES.STUDENT]: 'Learning and course access',
}

// Check if role can access portal
export function canAccessPortal(role: Role, portal: Portal): boolean {
  return ROLE_PORTAL_MAP[role] === portal
}

// Check if role has higher or equal authority
export function hasRoleAuthority(userRole: Role, targetRole: Role): boolean {
  return ROLE_HIERARCHY[userRole] >= ROLE_HIERARCHY[targetRole]
}

// Get roles by portal
export function getRolesByPortal(portal: Portal): Role[] {
  return Object.entries(ROLE_PORTAL_MAP)
    .filter(([, p]) => p === portal)
    .map(([role]) => role as Role)
}

// Get portal for role
export function getPortalForRole(role: Role): Portal {
  return ROLE_PORTAL_MAP[role]
}
