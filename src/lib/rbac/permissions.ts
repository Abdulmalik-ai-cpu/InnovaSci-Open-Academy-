/**
 * InnovaSci Open Academy - Permission Definitions
 * 
 * This file defines all permissions for the platform.
 */

// Permission Categories
export const PERMISSION_CATEGORIES = {
  USERS: 'USERS',
  DOMAINS: 'DOMAINS',
  CATEGORIES: 'CATEGORIES',
  COURSES: 'COURSES',
  CERTIFICATES: 'CERTIFICATES',
  ENROLLMENTS: 'ENROLLMENTS',
  PROJECTS: 'PROJECTS',
  SCHOLARSHIPS: 'SCHOLARSHIPS',
  PAYMENTS: 'PAYMENTS',
  SETTINGS: 'SETTINGS',
  SYSTEM: 'SYSTEM',
  ANALYTICS: 'ANALYTICS',
  CONTENT: 'CONTENT',
  SUPPORT: 'SUPPORT',
  STORAGE: 'STORAGE',
  DATABASE: 'DATABASE',
  PORTAL: 'PORTAL',
  ROLES: 'ROLES',
  POLICIES: 'POLICIES',
} as const

export type PermissionCategory = typeof PERMISSION_CATEGORIES[keyof typeof PERMISSION_CATEGORIES]

// Permission Actions
export const PERMISSION_ACTIONS = {
  VIEW: 'VIEW',
  CREATE: 'CREATE',
  UPDATE: 'UPDATE',
  DELETE: 'DELETE',
  MANAGE: 'MANAGE',
  APPROVE: 'APPROVE',
  REVIEW: 'REVIEW',
  EXPORT: 'EXPORT',
  IMPORT: 'IMPORT',
} as const

export type PermissionAction = typeof PERMISSION_ACTIONS[keyof typeof PERMISSION_ACTIONS]

// All Permissions
export const PERMISSIONS = {
  // User Management
  USERS_VIEW: { name: 'USERS_VIEW', category: PERMISSION_CATEGORIES.USERS, description: 'View users' },
  USERS_CREATE: { name: 'USERS_CREATE', category: PERMISSION_CATEGORIES.USERS, description: 'Create users' },
  USERS_UPDATE: { name: 'USERS_UPDATE', category: PERMISSION_CATEGORIES.USERS, description: 'Update users' },
  USERS_DELETE: { name: 'USERS_DELETE', category: PERMISSION_CATEGORIES.USERS, description: 'Delete users' },
  USERS_MANAGE: { name: 'USERS_MANAGE', category: PERMISSION_CATEGORIES.USERS, description: 'Full user management' },

  // Domain Management
  DOMAINS_VIEW: { name: 'DOMAINS_VIEW', category: PERMISSION_CATEGORIES.DOMAINS, description: 'View domains' },
  DOMAINS_CREATE: { name: 'DOMAINS_CREATE', category: PERMISSION_CATEGORIES.DOMAINS, description: 'Create domains' },
  DOMAINS_UPDATE: { name: 'DOMAINS_UPDATE', category: PERMISSION_CATEGORIES.DOMAINS, description: 'Update domains' },
  DOMAINS_DELETE: { name: 'DOMAINS_DELETE', category: PERMISSION_CATEGORIES.DOMAINS, description: 'Delete domains' },
  DOMAINS_MANAGE: { name: 'DOMAINS_MANAGE', category: PERMISSION_CATEGORIES.DOMAINS, description: 'Full domain management' },
  DOMAINS_APPROVE: { name: 'DOMAINS_APPROVE', category: PERMISSION_CATEGORIES.DOMAINS, description: 'Approve domains' },

  // Category Management
  CATEGORIES_VIEW: { name: 'CATEGORIES_VIEW', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'View categories' },
  CATEGORIES_CREATE: { name: 'CATEGORIES_CREATE', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'Create categories' },
  CATEGORIES_UPDATE: { name: 'CATEGORIES_UPDATE', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'Update categories' },
  CATEGORIES_DELETE: { name: 'CATEGORIES_DELETE', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'Delete categories' },
  CATEGORIES_MANAGE: { name: 'CATEGORIES_MANAGE', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'Full category management' },
  CATEGORIES_APPROVE: { name: 'CATEGORIES_APPROVE', category: PERMISSION_CATEGORIES.CATEGORIES, description: 'Approve categories' },

  // Course Management
  COURSES_VIEW: { name: 'COURSES_VIEW', category: PERMISSION_CATEGORIES.COURSES, description: 'View courses' },
  COURSES_CREATE: { name: 'COURSES_CREATE', category: PERMISSION_CATEGORIES.COURSES, description: 'Create courses' },
  COURSES_UPDATE: { name: 'COURSES_UPDATE', category: PERMISSION_CATEGORIES.COURSES, description: 'Update courses' },
  COURSES_DELETE: { name: 'COURSES_DELETE', category: PERMISSION_CATEGORIES.COURSES, description: 'Delete courses' },
  COURSES_MANAGE: { name: 'COURSES_MANAGE', category: PERMISSION_CATEGORIES.COURSES, description: 'Full course management' },
  COURSES_PUBLISH: { name: 'COURSES_PUBLISH', category: PERMISSION_CATEGORIES.COURSES, description: 'Publish courses' },
  COURSES_APPROVE: { name: 'COURSES_APPROVE', category: PERMISSION_CATEGORIES.COURSES, description: 'Approve courses' },

  // Certificate Management
  CERTIFICATES_VIEW: { name: 'CERTIFICATES_VIEW', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'View certificates' },
  CERTIFICATES_CREATE: { name: 'CERTIFICATES_CREATE', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'Create certificates' },
  CERTIFICATES_UPDATE: { name: 'CERTIFICATES_UPDATE', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'Update certificates' },
  CERTIFICATES_DELETE: { name: 'CERTIFICATES_DELETE', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'Delete certificates' },
  CERTIFICATES_MANAGE: { name: 'CERTIFICATES_MANAGE', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'Full certificate management' },
  CERTIFICATES_ISSUE: { name: 'CERTIFICATES_ISSUE', category: PERMISSION_CATEGORIES.CERTIFICATES, description: 'Issue certificates' },

  // Enrollment Management
  ENROLLMENTS_VIEW: { name: 'ENROLLMENTS_VIEW', category: PERMISSION_CATEGORIES.ENROLLMENTS, description: 'View enrollments' },
  ENROLLMENTS_CREATE: { name: 'ENROLLMENTS_CREATE', category: PERMISSION_CATEGORIES.ENROLLMENTS, description: 'Create enrollments' },
  ENROLLMENTS_UPDATE: { name: 'ENROLLMENTS_UPDATE', category: PERMISSION_CATEGORIES.ENROLLMENTS, description: 'Update enrollments' },
  ENROLLMENTS_DELETE: { name: 'ENROLLMENTS_DELETE', category: PERMISSION_CATEGORIES.ENROLLMENTS, description: 'Delete enrollments' },
  ENROLLMENTS_MANAGE: { name: 'ENROLLMENTS_MANAGE', category: PERMISSION_CATEGORIES.ENROLLMENTS, description: 'Full enrollment management' },

  // Project Management
  PROJECTS_VIEW: { name: 'PROJECTS_VIEW', category: PERMISSION_CATEGORIES.PROJECTS, description: 'View projects' },
  PROJECTS_CREATE: { name: 'PROJECTS_CREATE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Create projects' },
  PROJECTS_UPDATE: { name: 'PROJECTS_UPDATE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Update projects' },
  PROJECTS_DELETE: { name: 'PROJECTS_DELETE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Delete projects' },
  PROJECTS_MANAGE: { name: 'PROJECTS_MANAGE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Full project management' },
  PROJECTS_REVIEW: { name: 'PROJECTS_REVIEW', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Review projects' },
  PROJECTS_APPROVE: { name: 'PROJECTS_APPROVE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Approve projects' },
  PROJECTS_GRADE: { name: 'PROJECTS_GRADE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Grade projects' },

  // Capstone Management
  CAPSTONES_VIEW: { name: 'CAPSTONES_VIEW', category: PERMISSION_CATEGORIES.PROJECTS, description: 'View capstones' },
  CAPSTONES_REVIEW: { name: 'CAPSTONES_REVIEW', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Review capstones' },
  CAPSTONES_APPROVE: { name: 'CAPSTONES_APPROVE', category: PERMISSION_CATEGORIES.PROJECTS, description: 'Approve capstones' },

  // Scholarship Management
  SCHOLARSHIPS_VIEW: { name: 'SCHOLARSHIPS_VIEW', category: PERMISSION_CATEGORIES.SCHOLARSHIPS, description: 'View scholarships' },
  SCHOLARSHIPS_CREATE: { name: 'SCHOLARSHIPS_CREATE', category: PERMISSION_CATEGORIES.SCHOLARSHIPS, description: 'Create scholarships' },
  SCHOLARSHIPS_UPDATE: { name: 'SCHOLARSHIPS_UPDATE', category: PERMISSION_CATEGORIES.SCHOLARSHIPS, description: 'Update scholarships' },
  SCHOLARSHIPS_DELETE: { name: 'SCHOLARSHIPS_DELETE', category: PERMISSION_CATEGORIES.SCHOLARSHIPS, description: 'Delete scholarships' },
  SCHOLARSHIPS_MANAGE: { name: 'SCHOLARSHIPS_MANAGE', category: PERMISSION_CATEGORIES.SCHOLARSHIPS, description: 'Full scholarship management' },

  // Payment Management
  PAYMENTS_VIEW: { name: 'PAYMENTS_VIEW', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'View payments' },
  PAYMENTS_CREATE: { name: 'PAYMENTS_CREATE', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'Create payments' },
  PAYMENTS_UPDATE: { name: 'PAYMENTS_UPDATE', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'Update payments' },
  PAYMENTS_DELETE: { name: 'PAYMENTS_DELETE', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'Delete payments' },
  PAYMENTS_MANAGE: { name: 'PAYMENTS_MANAGE', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'Full payment management' },
  PAYMENTS_REFUND: { name: 'PAYMENTS_REFUND', category: PERMISSION_CATEGORIES.PAYMENTS, description: 'Refund payments' },

  // System Settings
  SETTINGS_VIEW: { name: 'SETTINGS_VIEW', category: PERMISSION_CATEGORIES.SETTINGS, description: 'View settings' },
  SETTINGS_UPDATE: { name: 'SETTINGS_UPDATE', category: PERMISSION_CATEGORIES.SETTINGS, description: 'Update settings' },
  SETTINGS_MANAGE: { name: 'SETTINGS_MANAGE', category: PERMISSION_CATEGORIES.SETTINGS, description: 'Full settings management' },

  // System Administration
  SYSTEM_VIEW: { name: 'SYSTEM_VIEW', category: PERMISSION_CATEGORIES.SYSTEM, description: 'View system info' },
  SYSTEM_MONITOR: { name: 'SYSTEM_MONITOR', category: PERMISSION_CATEGORIES.SYSTEM, description: 'Monitor system' },
  SYSTEM_CONFIGURE: { name: 'SYSTEM_CONFIGURE', category: PERMISSION_CATEGORIES.SYSTEM, description: 'Configure system' },
  SYSTEM_MANAGE: { name: 'SYSTEM_MANAGE', category: PERMISSION_CATEGORIES.SYSTEM, description: 'Full system management' },

  // Analytics
  ANALYTICS_VIEW: { name: 'ANALYTICS_VIEW', category: PERMISSION_CATEGORIES.ANALYTICS, description: 'View analytics' },
  ANALYTICS_EXPORT: { name: 'ANALYTICS_EXPORT', category: PERMISSION_CATEGORIES.ANALYTICS, description: 'Export analytics' },

  // Content Management
  CONTENT_VIEW: { name: 'CONTENT_VIEW', category: PERMISSION_CATEGORIES.CONTENT, description: 'View content' },
  CONTENT_CREATE: { name: 'CONTENT_CREATE', category: PERMISSION_CATEGORIES.CONTENT, description: 'Create content' },
  CONTENT_UPDATE: { name: 'CONTENT_UPDATE', category: PERMISSION_CATEGORIES.CONTENT, description: 'Update content' },
  CONTENT_DELETE: { name: 'CONTENT_DELETE', category: PERMISSION_CATEGORIES.CONTENT, description: 'Delete content' },
  CONTENT_MANAGE: { name: 'CONTENT_MANAGE', category: PERMISSION_CATEGORIES.CONTENT, description: 'Full content management' },

  // Support
  SUPPORT_VIEW: { name: 'SUPPORT_VIEW', category: PERMISSION_CATEGORIES.SUPPORT, description: 'View support tickets' },
  SUPPORT_CREATE: { name: 'SUPPORT_CREATE', category: PERMISSION_CATEGORIES.SUPPORT, description: 'Create support tickets' },
  SUPPORT_UPDATE: { name: 'SUPPORT_UPDATE', category: PERMISSION_CATEGORIES.SUPPORT, description: 'Update support tickets' },
  SUPPORT_DELETE: { name: 'SUPPORT_DELETE', category: PERMISSION_CATEGORIES.SUPPORT, description: 'Delete support tickets' },
  SUPPORT_MANAGE: { name: 'SUPPORT_MANAGE', category: PERMISSION_CATEGORIES.SUPPORT, description: 'Full support management' },

  // Storage
  STORAGE_VIEW: { name: 'STORAGE_VIEW', category: PERMISSION_CATEGORIES.STORAGE, description: 'View storage' },
  STORAGE_UPLOAD: { name: 'STORAGE_UPLOAD', category: PERMISSION_CATEGORIES.STORAGE, description: 'Upload to storage' },
  STORAGE_DELETE: { name: 'STORAGE_DELETE', category: PERMISSION_CATEGORIES.STORAGE, description: 'Delete from storage' },
  STORAGE_MANAGE: { name: 'STORAGE_MANAGE', category: PERMISSION_CATEGORIES.STORAGE, description: 'Full storage management' },

  // Database
  DATABASE_VIEW: { name: 'DATABASE_VIEW', category: PERMISSION_CATEGORIES.DATABASE, description: 'View database' },
  DATABASE_BACKUP: { name: 'DATABASE_BACKUP', category: PERMISSION_CATEGORIES.DATABASE, description: 'Backup database' },
  DATABASE_RESTORE: { name: 'DATABASE_RESTORE', category: PERMISSION_CATEGORIES.DATABASE, description: 'Restore database' },
  DATABASE_MANAGE: { name: 'DATABASE_MANAGE', category: PERMISSION_CATEGORIES.DATABASE, description: 'Full database management' },

  // Portal
  PORTAL_VIEW: { name: 'PORTAL_VIEW', category: PERMISSION_CATEGORIES.PORTAL, description: 'View portal' },
  PORTAL_MANAGE: { name: 'PORTAL_MANAGE', category: PERMISSION_CATEGORIES.PORTAL, description: 'Full portal management' },

  // Roles Management
  ROLES_VIEW: { name: 'ROLES_VIEW', category: PERMISSION_CATEGORIES.ROLES, description: 'View roles' },
  ROLES_CREATE: { name: 'ROLES_CREATE', category: PERMISSION_CATEGORIES.ROLES, description: 'Create roles' },
  ROLES_UPDATE: { name: 'ROLES_UPDATE', category: PERMISSION_CATEGORIES.ROLES, description: 'Update roles' },
  ROLES_DELETE: { name: 'ROLES_DELETE', category: PERMISSION_CATEGORIES.ROLES, description: 'Delete roles' },
  ROLES_MANAGE: { name: 'ROLES_MANAGE', category: PERMISSION_CATEGORIES.ROLES, description: 'Full roles management' },

  // Policies Management
  POLICIES_VIEW: { name: 'POLICIES_VIEW', category: PERMISSION_CATEGORIES.POLICIES, description: 'View policies' },
  POLICIES_CREATE: { name: 'POLICIES_CREATE', category: PERMISSION_CATEGORIES.POLICIES, description: 'Create policies' },
  POLICIES_UPDATE: { name: 'POLICIES_UPDATE', category: PERMISSION_CATEGORIES.POLICIES, description: 'Update policies' },
  POLICIES_DELETE: { name: 'POLICIES_DELETE', category: PERMISSION_CATEGORIES.POLICIES, description: 'Delete policies' },
  POLICIES_MANAGE: { name: 'POLICIES_MANAGE', category: PERMISSION_CATEGORIES.POLICIES, description: 'Full policies management' },
} as const

export type Permission = keyof typeof PERMISSIONS

// Get permission by name
export function getPermissionByName(name: string): typeof PERMISSIONS[keyof typeof PERMISSIONS] | undefined {
  return PERMISSIONS[name as Permission]
}

// Get all permissions by category
export function getPermissionsByCategory(category: PermissionCategory): Permission[] {
  return Object.entries(PERMISSIONS)
    .filter(([, p]) => p.category === category)
    .map(([name]) => name as Permission)
}

// Create permission key
export function createPermissionKey(category: string, action: string): string {
  return `${category}_${action}`
}
