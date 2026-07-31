/**
 * InnovaSci Open Academy - Role-Based Access Control (RBAC)
 * 
 * This module defines the official organizational hierarchy:
 * 
 * CEO / Founder
 *     │
 * Super Administrator
 *     │
 * System Administrator
 *     │
 * Academic Director
 *     │
 * Head of Domain
 *     │
 * Category Lead
 *     │
 * Instructor
 *     │
 * Student
 */

// Official Role Hierarchy
export enum Role {
  // Top Level
  SUPER_ADMIN = 'SUPER_ADMIN',
  SYSTEM_ADMIN = 'SYSTEM_ADMIN',
  
  // Academic Governance
  ACADEMIC_DIRECTOR = 'ACADEMIC_DIRECTOR',
  HEAD_OF_DOMAIN = 'HEAD_OF_DOMAIN',
  CATEGORY_LEAD = 'CATEGORY_LEAD',
  INSTRUCTOR = 'INSTRUCTOR',
  
  // End User
  STUDENT = 'STUDENT',
}

// Role hierarchy levels (higher number = more authority)
export const ROLE_HIERARCHY: Record<Role, number> = {
  [Role.SUPER_ADMIN]: 100,
  [Role.SYSTEM_ADMIN]: 90,
  [Role.ACADEMIC_DIRECTOR]: 80,
  [Role.HEAD_OF_DOMAIN]: 70,
  [Role.CATEGORY_LEAD]: 60,
  [Role.INSTRUCTOR]: 50,
  [Role.STUDENT]: 10,
};

// Role display names
export const ROLE_DISPLAY_NAMES: Record<Role, string> = {
  [Role.SUPER_ADMIN]: 'Super Administrator',
  [Role.SYSTEM_ADMIN]: 'System Administrator',
  [Role.ACADEMIC_DIRECTOR]: 'Academic Director',
  [Role.HEAD_OF_DOMAIN]: 'Head of Domain',
  [Role.CATEGORY_LEAD]: 'Category Lead',
  [Role.INSTRUCTOR]: 'Instructor',
  [Role.STUDENT]: 'Student',
};

// Role descriptions
export const ROLE_DESCRIPTIONS: Record<Role, string> = {
  [Role.SUPER_ADMIN]: 'Full platform administration with unrestricted access',
  [Role.SYSTEM_ADMIN]: 'Technical operations and infrastructure management',
  [Role.ACADEMIC_DIRECTOR]: 'Highest academic authority, governs all academic activities',
  [Role.HEAD_OF_DOMAIN]: 'Manages assigned domain and all categories within',
  [Role.CATEGORY_LEAD]: 'Manages assigned category and all courses within',
  [Role.INSTRUCTOR]: 'Manages assigned courses and enrolled students',
  [Role.STUDENT]: 'Learning platform access through enrollment and purchases',
};

// Permission categories
export enum PermissionCategory {
  // User Management
  USERS = 'USERS',
  ROLES = 'ROLES',
  
  // Platform Management
  PLATFORM = 'PLATFORM',
  SETTINGS = 'SETTINGS',
  AUTHENTICATION = 'AUTHENTICATION',
  DATABASE = 'DATABASE',
  STORAGE = 'STORAGE',
  MONITORING = 'MONITORING',
  
  // Academic Management
  DOMAINS = 'DOMAINS',
  CATEGORIES = 'CATEGORIES',
  COURSES = 'COURSES',
  MODULES = 'MODULES',
  LESSONS = 'LESSONS',
  MATERIALS = 'MATERIALS',
  VIDEOS = 'VIDEOS',
  CERTIFICATES = 'CERTIFICATES',
  
  // Projects & Capstones
  MINI_PROJECTS = 'MINI_PROJECTS',
  CAPSTONE_PROJECTS = 'CAPSTONE_PROJECTS',
  PROJECTS = 'PROJECTS',
  
  // Students
  STUDENTS = 'STUDENTS',
  ENROLLMENTS = 'ENROLLMENTS',
  
  // Business
  SCHOLARSHIPS = 'SCHOLARSHIPS',
  PRICING = 'PRICING',
  PAYMENTS = 'PAYMENTS',
  
  // Support
  SUPPORT = 'SUPPORT',
  TICKETS = 'TICKETS',
  
  // Analytics
  ANALYTICS = 'ANALYTICS',
  AUDIT_LOGS = 'AUDIT_LOGS',
  
  // Content
  NEWSLETTER = 'NEWSLETTER',
  MCCS = 'MCCS',
}

// Permission actions
export enum PermissionAction {
  CREATE = 'CREATE',
  READ = 'READ',
  UPDATE = 'UPDATE',
  DELETE = 'DELETE',
  MANAGE = 'MANAGE',
  APPROVE = 'APPROVE',
  VIEW = 'VIEW',
}

// Full permissions with category and action
export type Permission = `${PermissionCategory}:${PermissionAction}`;

// Role permission mappings
export const ROLE_PERMISSIONS: Record<Role, Permission[]> = {
  [Role.SUPER_ADMIN]: [
    // All permissions
    ...Object.values(PermissionCategory).flatMap(cat => [
      `${cat}:CREATE` as Permission,
      `${cat}:READ` as Permission,
      `${cat}:UPDATE` as Permission,
      `${cat}:DELETE` as Permission,
      `${cat}:MANAGE` as Permission,
      `${cat}:APPROVE` as Permission,
      `${cat}:VIEW` as Permission,
    ]),
  ],
  
  [Role.SYSTEM_ADMIN]: [
    // Technical operations only
    'PLATFORM:MANAGE',
    'SETTINGS:MANAGE',
    'AUTHENTICATION:MANAGE',
    'DATABASE:MANAGE',
    'STORAGE:MANAGE',
    'MONITORING:MANAGE',
    'STORAGE:READ',
    'STORAGE:UPDATE',
    'DATABASE:READ',
    'PLATFORM:READ',
    'SETTINGS:READ',
    'AUDIT_LOGS:VIEW',
    'AUDIT_LOGS:READ',
    'PAYMENTS:READ',
    'PAYMENTS:VIEW',
    'TICKETS:READ',
    'TICKETS:UPDATE',
    'SUPPORT:MANAGE',
  ],
  
  [Role.ACADEMIC_DIRECTOR]: [
    // All academic governance
    'DOMAINS:MANAGE',
    'DOMAINS:CREATE',
    'DOMAINS:READ',
    'DOMAINS:UPDATE',
    'DOMAINS:APPROVE',
    'CATEGORIES:MANAGE',
    'CATEGORIES:CREATE',
    'CATEGORIES:READ',
    'CATEGORIES:UPDATE',
    'CATEGORIES:APPROVE',
    'COURSES:MANAGE',
    'COURSES:CREATE',
    'COURSES:READ',
    'COURSES:UPDATE',
    'COURSES:APPROVE',
    'MODULES:MANAGE',
    'MODULES:READ',
    'MODULES:UPDATE',
    'LESSONS:MANAGE',
    'LESSONS:READ',
    'LESSONS:UPDATE',
    'MATERIALS:MANAGE',
    'MATERIALS:READ',
    'MATERIALS:UPDATE',
    'VIDEOS:MANAGE',
    'VIDEOS:READ',
    'VIDEOS:UPDATE',
    'CERTIFICATES:MANAGE',
    'CERTIFICATES:READ',
    'CERTIFICATES:APPROVE',
    'MINI_PROJECTS:READ',
    'MINI_PROJECTS:UPDATE',
    'CAPSTONE_PROJECTS:MANAGE',
    'CAPSTONE_PROJECTS:READ',
    'CAPSTONE_PROJECTS:APPROVE',
    'PROJECTS:READ',
    'PROJECTS:UPDATE',
    'STUDENTS:READ',
    'STUDENTS:UPDATE',
    'ENROLLMENTS:READ',
    'ENROLLMENTS:UPDATE',
    'MCCS:READ',
    'MCCS:UPDATE',
    'ANALYTICS:VIEW',
    'ANALYTICS:READ',
    'SCHOLARSHIPS:READ',
    'PAYMENTS:READ',
    'PAYMENTS:VIEW',
  ],
  
  [Role.HEAD_OF_DOMAIN]: [
    // Domain-scoped academic management (PBAC: assigned domain)
    'DOMAINS:READ',
    'DOMAINS:UPDATE',
    'CATEGORIES:MANAGE',
    'CATEGORIES:CREATE',
    'CATEGORIES:READ',
    'CATEGORIES:UPDATE',
    'CATEGORIES:APPROVE',
    'COURSES:MANAGE',
    'COURSES:CREATE',
    'COURSES:READ',
    'COURSES:UPDATE',
    'MODULES:MANAGE',
    'MODULES:READ',
    'MODULES:UPDATE',
    'LESSONS:MANAGE',
    'LESSONS:READ',
    'LESSONS:UPDATE',
    'MATERIALS:MANAGE',
    'MATERIALS:READ',
    'MATERIALS:UPDATE',
    'VIDEOS:MANAGE',
    'VIDEOS:READ',
    'VIDEOS:UPDATE',
    'MINI_PROJECTS:READ',
    'MINI_PROJECTS:UPDATE',
    'CAPSTONE_PROJECTS:READ',
    'CAPSTONE_PROJECTS:UPDATE',
    'CAPSTONE_PROJECTS:APPROVE',
    'PROJECTS:READ',
    'PROJECTS:UPDATE',
    'STUDENTS:READ',
    'STUDENTS:UPDATE',
    'ENROLLMENTS:READ',
    'ENROLLMENTS:UPDATE',
    'ANALYTICS:VIEW',
    'ANALYTICS:READ',
  ],
  
  [Role.CATEGORY_LEAD]: [
    // Category-scoped academic management (PBAC: assigned category)
    'CATEGORIES:READ',
    'CATEGORIES:UPDATE',
    'COURSES:MANAGE',
    'COURSES:CREATE',
    'COURSES:READ',
    'COURSES:UPDATE',
    'MODULES:MANAGE',
    'MODULES:READ',
    'MODULES:UPDATE',
    'LESSONS:MANAGE',
    'LESSONS:READ',
    'LESSONS:UPDATE',
    'MATERIALS:MANAGE',
    'MATERIALS:READ',
    'MATERIALS:UPDATE',
    'VIDEOS:MANAGE',
    'VIDEOS:READ',
    'VIDEOS:UPDATE',
    'MINI_PROJECTS:READ',
    'MINI_PROJECTS:UPDATE',
    'MINI_PROJECTS:APPROVE',
    'CAPSTONE_PROJECTS:READ',
    'CAPSTONE_PROJECTS:UPDATE',
    'PROJECTS:READ',
    'PROJECTS:UPDATE',
    'STUDENTS:READ',
    'STUDENTS:UPDATE',
    'ENROLLMENTS:READ',
    'ENROLLMENTS:UPDATE',
    'ANALYTICS:VIEW',
    'ANALYTICS:READ',
  ],
  
  [Role.INSTRUCTOR]: [
    // Course-scoped teaching management (PBAC: assigned courses)
    'COURSES:READ',
    'COURSES:UPDATE',
    'MODULES:MANAGE',
    'MODULES:READ',
    'MODULES:UPDATE',
    'LESSONS:MANAGE',
    'LESSONS:READ',
    'LESSONS:UPDATE',
    'LESSONS:CREATE',
    'LESSONS:DELETE',
    'MATERIALS:MANAGE',
    'MATERIALS:READ',
    'MATERIALS:UPDATE',
    'MATERIALS:CREATE',
    'MATERIALS:DELETE',
    'VIDEOS:MANAGE',
    'VIDEOS:READ',
    'VIDEOS:UPDATE',
    'VIDEOS:CREATE',
    'VIDEOS:DELETE',
    'MINI_PROJECTS:READ',
    'MINI_PROJECTS:UPDATE',
    'MINI_PROJECTS:APPROVE',
    'PROJECTS:READ',
    'PROJECTS:UPDATE',
    'PROJECTS:CREATE',
    'STUDENTS:READ',
    'STUDENTS:UPDATE',
    'ENROLLMENTS:READ',
    'ANALYTICS:VIEW',
    'ANALYTICS:READ',
  ],
  
  [Role.STUDENT]: [
    // Limited access through enrollment/purchase (PBAC: own records)
    'COURSES:READ',
    'MODULES:READ',
    'LESSONS:READ',
    'MATERIALS:READ',
    'VIDEOS:READ',
    'ENROLLMENTS:READ',
    'ENROLLMENTS:UPDATE',
    'MINI_PROJECTS:READ',
    'MINI_PROJECTS:CREATE',
    'PROJECTS:READ',
    'PROJECTS:CREATE',
  ],
};

// Helper functions
export function hasPermission(role: Role, permission: Permission): boolean {
  return ROLE_PERMISSIONS[role]?.includes(permission) ?? false;
}

export function hasAnyPermission(role: Role, permissions: Permission[]): boolean {
  return permissions.some(permission => hasPermission(role, permission));
}

export function hasAllPermissions(role: Role, permissions: Permission[]): boolean {
  return permissions.every(permission => hasPermission(role, permission));
}

export function isHigherRole(role1: Role, role2: Role): boolean {
  return ROLE_HIERARCHY[role1] > ROLE_HIERARCHY[role2];
}

export function canManageRole(managerRole: Role, targetRole: Role): boolean {
  // Only higher roles can manage lower roles
  return isHigherRole(managerRole, targetRole);
}

export function getAccessibleCategories(role: Role): PermissionCategory[] {
  const permissions = ROLE_PERMISSIONS[role] || [];
  const categories = new Set<PermissionCategory>();
  
  for (const perm of permissions) {
    const [category] = perm.split(':') as [PermissionCategory, PermissionAction];
    categories.add(category);
  }
  
  return Array.from(categories);
}
