/**
 * InnovaSci Open Academy - Policy-Based Access Control (PBAC)
 * 
 * PBAC enforces that users can only access resources within their assigned scope.
 * 
 * RBAC says "you have permission to manage COURSES"
 * PBAC says "you can only manage COURSES where course.categoryId = your.assignedCategoryId"
 * 
 * Together: RBAC + PBAC = Complete Access Control
 */

import { Role, hasPermission, Permission, PermissionCategory, PermissionAction } from './roles';

// Scope types for PBAC
export interface UserScope {
  domainId?: string | null;
  categoryId?: string | null;
  courseIds?: string[];
}

export interface PBACContext {
  userId: string;
  role: Role;
  scope: UserScope;
}

// PBAC Policy interface
export interface PBACPolicy {
  resource: PermissionCategory;
  action: PermissionAction;
  scopeChecker: (context: PBACContext, resourceId?: string) => Promise<boolean> | boolean;
}

// Create a permission string
export function createPermission(category: PermissionCategory, action: PermissionAction): Permission {
  return `${category}:${action}` as Permission;
}

// Check if RBAC allows the action
export function canAccessViaRBAC(role: Role, permission: Permission): boolean {
  return hasPermission(role, permission);
}

// PBAC scope checkers for different resource types
export const scopeCheckers = {
  // Domain scope - user can only access assigned domain
  async checkDomainAccess(context: PBACContext, domainId?: string): Promise<boolean> {
    // Super Admin and Academic Director can access all domains
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR) {
      return true;
    }
    
    // Head of Domain can only access assigned domain
    if (context.role === Role.HEAD_OF_DOMAIN) {
      if (!domainId) return false;
      return context.scope.domainId === domainId;
    }
    
    // Other roles cannot access domains
    return false;
  },
  
  // Category scope - user can only access categories within assigned scope
  async checkCategoryAccess(context: PBACContext, categoryId?: string): Promise<boolean> {
    // Super Admin and Academic Director can access all categories
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR) {
      return true;
    }
    
    // Head of Domain can access categories in their domain
    if (context.role === Role.HEAD_OF_DOMAIN) {
      if (!context.scope.domainId) return false;
      // For Head of Domain, they can manage any category within their domain
      // The actual category-to-domain check is done via the API
      return true;
    }
    
    // Category Lead can only access assigned category
    if (context.role === Role.CATEGORY_LEAD) {
      if (!categoryId) return false;
      return context.scope.categoryId === categoryId;
    }
    
    return false;
  },
  
  // Course scope - user can only access assigned courses
  async checkCourseAccess(context: PBACContext, courseId?: string): Promise<boolean> {
    // Super Admin, Academic Director, Head of Domain, Category Lead can access all courses in scope
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR || 
        context.role === Role.HEAD_OF_DOMAIN || context.role === Role.CATEGORY_LEAD) {
      return true;
    }
    
    // Instructor can only access assigned courses
    if (context.role === Role.INSTRUCTOR) {
      if (!courseId) return false;
      return context.scope.courseIds?.includes(courseId) ?? false;
    }
    
    // Students - course access is handled via enrollment
    if (context.role === Role.STUDENT) {
      // Student course access is handled via enrollment check
      return true;
    }
    
    return false;
  },
  
  // Student scope - users can only access their own data or assigned students
  async checkStudentAccess(context: PBACContext, studentId?: string): Promise<boolean> {
    // Super Admin can access all students
    if (context.role === Role.SUPER_ADMIN) {
      return true;
    }
    
    // Academic Director can access all students
    if (context.role === Role.ACADEMIC_DIRECTOR) {
      return true;
    }
    
    // Head of Domain can access students in their domain
    if (context.role === Role.HEAD_OF_DOMAIN) {
      return true; // API handles domain scoping
    }
    
    // Category Lead can access students in their category
    if (context.role === Role.CATEGORY_LEAD) {
      return true; // API handles category scoping
    }
    
    // Instructor can access assigned students
    if (context.role === Role.INSTRUCTOR) {
      return true; // API handles course-based filtering
    }
    
    // Students can only access their own data
    if (context.role === Role.STUDENT) {
      return context.userId === studentId;
    }
    
    return false;
  },
  
  // Module/Lesson scope - same as course scope
  async checkModuleAccess(context: PBACContext, moduleId?: string): Promise<boolean> {
    // Module access is controlled by course access
    return true; // API handles course-based filtering
  },
  
  // Project scope - based on assignment or ownership
  async checkProjectAccess(context: PBACContext, projectId?: string): Promise<boolean> {
    // Super Admin can access all projects
    if (context.role === Role.SUPER_ADMIN) {
      return true;
    }
    
    // Academic Director can access all projects
    if (context.role === Role.ACADEMIC_DIRECTOR) {
      return true;
    }
    
    // Head of Domain can access projects in their domain
    if (context.role === Role.HEAD_OF_DOMAIN) {
      return true; // API handles domain scoping
    }
    
    // Category Lead can access projects in their category
    if (context.role === Role.CATEGORY_LEAD) {
      return true; // API handles category scoping
    }
    
    // Instructor can access projects in assigned courses
    if (context.role === Role.INSTRUCTOR) {
      return true; // API handles course-based filtering
    }
    
    // Students can access their own projects
    if (context.role === Role.STUDENT) {
      return true; // API handles ownership check
    }
    
    return false;
  },
};

// PBAC filter generators for Prisma queries
export const pbacFilters = {
  // Generate domain filter based on role and scope
  domainFilter(context: PBACContext) {
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR || 
        context.role === Role.SYSTEM_ADMIN) {
      return {}; // No filter - can access all
    }
    
    if (context.role === Role.HEAD_OF_DOMAIN) {
      return { id: context.scope.domainId };
    }
    
    // Other roles cannot access domains via API
    return { id: 'none' }; // Return impossible condition
  },
  
  // Generate category filter based on role and scope
  categoryFilter(context: PBACContext) {
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR) {
      return {}; // No filter
    }
    
    if (context.role === Role.HEAD_OF_DOMAIN) {
      return { domainId: context.scope.domainId };
    }
    
    if (context.role === Role.CATEGORY_LEAD) {
      return { id: context.scope.categoryId };
    }
    
    return { id: 'none' };
  },
  
  // Generate course filter based on role and scope
  courseFilter(context: PBACContext) {
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR || 
        context.role === Role.HEAD_OF_DOMAIN || context.role === Role.CATEGORY_LEAD) {
      return {}; // No filter
    }
    
    if (context.role === Role.INSTRUCTOR) {
      if (context.scope.courseIds && context.scope.courseIds.length > 0) {
        return { id: { in: context.scope.courseIds } };
      }
      return { id: 'none' };
    }
    
    return {}; // Students access via enrollment, not direct filter
  },
  
  // Generate student filter based on role and scope
  studentFilter(context: PBACContext) {
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR) {
      return {}; // No filter
    }
    
    if (context.role === Role.HEAD_OF_DOMAIN || context.role === Role.CATEGORY_LEAD) {
      return {}; // API handles domain/category scoping
    }
    
    if (context.role === Role.INSTRUCTOR) {
      if (context.scope.courseIds && context.scope.courseIds.length > 0) {
        return { enrollments: { some: { courseId: { in: context.scope.courseIds } } } };
      }
      return { id: 'none' };
    }
    
    if (context.role === Role.STUDENT) {
      return { id: context.userId };
    }
    
    return {};
  },
  
  // Generate project filter based on role and scope
  projectFilter(context: PBACContext) {
    if (context.role === Role.SUPER_ADMIN || context.role === Role.ACADEMIC_DIRECTOR) {
      return {}; // No filter
    }
    
    if (context.role === Role.HEAD_OF_DOMAIN) {
      return {}; // API handles domain scoping
    }
    
    if (context.role === Role.CATEGORY_LEAD) {
      return {}; // API handles category scoping
    }
    
    if (context.role === Role.INSTRUCTOR) {
      if (context.scope.courseIds && context.scope.courseIds.length > 0) {
        return { courseId: { in: context.scope.courseIds } };
      }
      return { id: 'none' };
    }
    
    if (context.role === Role.STUDENT) {
      return { userId: context.userId };
    }
    
    return {};
  },
};

// Combined RBAC + PBAC access check
export async function checkAccess(
  role: Role,
  permission: Permission,
  scopeChecker: (context: PBACContext, resourceId?: string) => Promise<boolean> | boolean,
  context: PBACContext,
  resourceId?: string
): Promise<boolean> {
  // First check RBAC
  if (!canAccessViaRBAC(role, permission)) {
    return false;
  }
  
  // Then check PBAC
  return scopeChecker(context, resourceId);
}

// HTTP 403 response helper
export function accessDeniedResponse(message?: string) {
  return {
    error: message || 'Access denied. You do not have permission to perform this action.',
    code: 'ACCESS_DENIED',
    status: 403,
  };
}
