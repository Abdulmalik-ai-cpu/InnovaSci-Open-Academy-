/**
 * InnovaSci Open Academy - Governance Navigation Configuration
 * 
 * This file defines the navigation structure for each governance role.
 * Each role has its own dashboard with specific menu items.
 */

import { Role, PermissionCategory } from './rbac/roles';

// Navigation item structure
export interface NavItem {
  label: string;
  href: string;
  icon?: string;
  permission?: string;
  children?: NavItem[];
  badge?: string;
}

export interface NavSection {
  title: string;
  items: NavItem[];
}

// Dashboard routes
export const DASHBOARD_ROUTES = {
  SUPER_ADMIN: '/governance/super-admin',
  SYSTEM_ADMIN: '/governance/system-admin',
  ACADEMIC_DIRECTOR: '/governance/academic-director',
  HEAD_OF_DOMAIN: '/governance/head-of-domain',
  CATEGORY_LEAD: '/governance/category-lead',
  INSTRUCTOR: '/governance/instructor',
  STUDENT: '/dashboard',
};

// Super Administrator Navigation
export const SUPER_ADMIN_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/super-admin', icon: 'home' },
      { label: 'Analytics', href: '/governance/super-admin/analytics', icon: 'chart' },
    ],
  },
  {
    title: 'User Management',
    items: [
      { label: 'All Users', href: '/governance/super-admin/users', icon: 'users' },
      { label: 'Staff Directory', href: '/governance/super-admin/staff', icon: 'briefcase' },
      { label: 'Roles & Permissions', href: '/governance/super-admin/roles', icon: 'shield' },
      { label: 'Audit Logs', href: '/governance/super-admin/audit-logs', icon: 'clipboard' },
    ],
  },
  {
    title: 'Academic Structure',
    items: [
      { label: 'Domains', href: '/governance/super-admin/domains', icon: 'globe' },
      { label: 'Categories', href: '/governance/super-admin/categories', icon: 'folder' },
      { label: 'Courses', href: '/governance/super-admin/courses', icon: 'book' },
      { label: 'MCCS Courses', href: '/governance/super-admin/mccs', icon: 'graduation' },
    ],
  },
  {
    title: 'Academic Operations',
    items: [
      { label: 'Certificates', href: '/governance/super-admin/certificates', icon: 'award' },
      { label: 'Learning Paths', href: '/governance/super-admin/learning-paths', icon: 'route' },
      { label: 'Projects', href: '/governance/super-admin/projects', icon: 'folder' },
      { label: 'Capstones', href: '/governance/super-admin/capstones', icon: 'capstone' },
      { label: 'Scholarships', href: '/governance/super-admin/scholarships', icon: 'scholarship' },
    ],
  },
  {
    title: 'Business Operations',
    items: [
      { label: 'Payments', href: '/governance/super-admin/payments', icon: 'credit-card' },
      { label: 'Pricing', href: '/governance/super-admin/pricing', icon: 'tag' },
      { label: 'Memberships', href: '/governance/super-admin/memberships', icon: 'user-plus' },
    ],
  },
  {
    title: 'Support & Content',
    items: [
      { label: 'Support Tickets', href: '/governance/super-admin/support', icon: 'headphones' },
      { label: 'Learning Materials', href: '/governance/super-admin/materials', icon: 'file' },
      { label: 'Videos', href: '/governance/super-admin/videos', icon: 'video' },
      { label: 'Newsletter', href: '/governance/super-admin/newsletter', icon: 'mail' },
    ],
  },
  {
    title: 'Infrastructure',
    items: [
      { label: 'Storage', href: '/governance/super-admin/storage', icon: 'database' },
      { label: 'Database', href: '/governance/super-admin/database', icon: 'server' },
      { label: 'Exchange Rates', href: '/governance/super-admin/exchange-rates', icon: 'refresh' },
      { label: 'Portal Management', href: '/governance/super-admin/portal', icon: 'layout' },
    ],
  },
  {
    title: 'System',
    items: [
      { label: 'Settings', href: '/governance/super-admin/settings', icon: 'settings' },
      { label: 'Notifications', href: '/governance/super-admin/notifications', icon: 'bell' },
    ],
  },
];

// System Administrator Navigation
export const SYSTEM_ADMIN_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/system-admin', icon: 'home' },
      { label: 'System Status', href: '/governance/system-admin/status', icon: 'activity' },
    ],
  },
  {
    title: 'Infrastructure',
    items: [
      { label: 'Storage', href: '/governance/system-admin/storage', icon: 'hard-drive' },
      { label: 'Database', href: '/governance/system-admin/database', icon: 'database' },
      { label: 'API Monitoring', href: '/governance/system-admin/api-monitoring', icon: 'code' },
    ],
  },
  {
    title: 'Performance',
    items: [
      { label: 'Performance Monitor', href: '/governance/system-admin/performance', icon: 'activity' },
      { label: 'Logs', href: '/governance/system-admin/logs', icon: 'file-text' },
      { label: 'Backups', href: '/governance/system-admin/backups', icon: 'download' },
    ],
  },
  {
    title: 'Security',
    items: [
      { label: 'Security Monitor', href: '/governance/system-admin/security', icon: 'shield' },
      { label: 'Audit Logs', href: '/governance/system-admin/audit-logs', icon: 'clipboard' },
      { label: 'Access Control', href: '/governance/system-admin/access', icon: 'lock' },
    ],
  },
  {
    title: 'Support',
    items: [
      { label: 'Support Tickets', href: '/governance/system-admin/support', icon: 'headphones' },
    ],
  },
  {
    title: 'Configuration',
    items: [
      { label: 'Settings', href: '/governance/system-admin/settings', icon: 'settings' },
      { label: 'Environment', href: '/governance/system-admin/environment', icon: 'sliders' },
    ],
  },
];

// Academic Director Navigation
export const ACADEMIC_DIRECTOR_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/academic-director', icon: 'home' },
      { label: 'Academic Analytics', href: '/governance/academic-director/analytics', icon: 'chart' },
    ],
  },
  {
    title: 'Academic Structure',
    items: [
      { label: 'Domains', href: '/governance/academic-director/domains', icon: 'globe' },
      { label: 'Categories', href: '/governance/academic-director/categories', icon: 'folder' },
      { label: 'Courses', href: '/governance/academic-director/courses', icon: 'book' },
      { label: 'Learning Paths', href: '/governance/academic-director/learning-paths', icon: 'route' },
    ],
  },
  {
    title: 'Content Management',
    items: [
      { label: 'Modules', href: '/governance/academic-director/modules', icon: 'layers' },
      { label: 'Lessons', href: '/governance/academic-director/lessons', icon: 'file' },
      { label: 'Learning Materials', href: '/governance/academic-director/materials', icon: 'folder' },
      { label: 'Videos', href: '/governance/academic-director/videos', icon: 'video' },
      { label: 'MCCS Courses', href: '/governance/academic-director/mccs', icon: 'graduation' },
    ],
  },
  {
    title: 'Academic Operations',
    items: [
      { label: 'Certificates', href: '/governance/academic-director/certificates', icon: 'award' },
      { label: 'Projects', href: '/governance/academic-director/projects', icon: 'folder' },
      { label: 'Capstone Management', href: '/governance/academic-director/capstones', icon: 'capstone' },
      { label: 'Scholarships', href: '/governance/academic-director/scholarships', icon: 'scholarship' },
    ],
  },
  {
    title: 'Academic Staff',
    items: [
      { label: 'Head of Domains', href: '/governance/academic-director/head-of-domains', icon: 'users' },
      { label: 'Category Leads', href: '/governance/academic-director/category-leads', icon: 'users' },
      { label: 'Instructors', href: '/governance/academic-director/instructors', icon: 'user' },
      { label: 'Students', href: '/governance/academic-director/students', icon: 'users' },
    ],
  },
  {
    title: 'Settings',
    items: [
      { label: 'Settings', href: '/governance/academic-director/settings', icon: 'settings' },
    ],
  },
];

// Head of Domain Navigation
export const HEAD_OF_DOMAIN_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/head-of-domain', icon: 'home' },
      { label: 'Domain Analytics', href: '/governance/head-of-domain/analytics', icon: 'chart' },
    ],
  },
  {
    title: 'Domain Structure',
    items: [
      { label: 'My Domain', href: '/governance/head-of-domain/my-domain', icon: 'globe' },
      { label: 'Categories', href: '/governance/head-of-domain/categories', icon: 'folder' },
      { label: 'Courses', href: '/governance/head-of-domain/courses', icon: 'book' },
    ],
  },
  {
    title: 'Content',
    items: [
      { label: 'Modules', href: '/governance/head-of-domain/modules', icon: 'layers' },
      { label: 'Lessons', href: '/governance/head-of-domain/lessons', icon: 'file' },
      { label: 'Learning Materials', href: '/governance/head-of-domain/materials', icon: 'folder' },
      { label: 'Videos', href: '/governance/head-of-domain/videos', icon: 'video' },
    ],
  },
  {
    title: 'Academic Operations',
    items: [
      { label: 'Capstone Projects', href: '/governance/head-of-domain/capstones', icon: 'capstone' },
      { label: 'Certificates', href: '/governance/head-of-domain/certificates', icon: 'award' },
    ],
  },
  {
    title: 'Domain Staff',
    items: [
      { label: 'Category Leads', href: '/governance/head-of-domain/category-leads', icon: 'users' },
      { label: 'Instructors', href: '/governance/head-of-domain/instructors', icon: 'user' },
      { label: 'Students', href: '/governance/head-of-domain/students', icon: 'users' },
    ],
  },
  {
    title: 'Settings',
    items: [
      { label: 'Domain Settings', href: '/governance/head-of-domain/settings', icon: 'settings' },
    ],
  },
];

// Category Lead Navigation
export const CATEGORY_LEAD_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/category-lead', icon: 'home' },
      { label: 'Category Analytics', href: '/governance/category-lead/analytics', icon: 'chart' },
    ],
  },
  {
    title: 'My Category',
    items: [
      { label: 'Category Overview', href: '/governance/category-lead/my-category', icon: 'folder' },
      { label: 'Courses', href: '/governance/category-lead/courses', icon: 'book' },
    ],
  },
  {
    title: 'Content',
    items: [
      { label: 'Modules', href: '/governance/category-lead/modules', icon: 'layers' },
      { label: 'Lessons', href: '/governance/category-lead/lessons', icon: 'file' },
      { label: 'Learning Materials', href: '/governance/category-lead/materials', icon: 'folder' },
      { label: 'Videos', href: '/governance/category-lead/videos', icon: 'video' },
    ],
  },
  {
    title: 'Academic Operations',
    items: [
      { label: 'Category Capstone', href: '/governance/category-lead/category-capstone', icon: 'capstone' },
      { label: 'Mini Projects', href: '/governance/category-lead/mini-projects', icon: 'folder' },
      { label: 'Projects', href: '/governance/category-lead/projects', icon: 'folder' },
    ],
  },
  {
    title: 'Category Team',
    items: [
      { label: 'Instructors', href: '/governance/category-lead/instructors', icon: 'user' },
      { label: 'Students', href: '/governance/category-lead/students', icon: 'users' },
    ],
  },
  {
    title: 'Settings',
    items: [
      { label: 'Category Settings', href: '/governance/category-lead/settings', icon: 'settings' },
    ],
  },
];

// Instructor Navigation
export const INSTRUCTOR_NAV: NavSection[] = [
  {
    title: 'Overview',
    items: [
      { label: 'Dashboard', href: '/governance/instructor', icon: 'home' },
      { label: 'Course Analytics', href: '/governance/instructor/analytics', icon: 'chart' },
    ],
  },
  {
    title: 'My Courses',
    items: [
      { label: 'Assigned Courses', href: '/governance/instructor/courses', icon: 'book' },
      { label: 'Curriculum', href: '/governance/instructor/curriculum', icon: 'list' },
    ],
  },
  {
    title: 'Content',
    items: [
      { label: 'Modules', href: '/governance/instructor/modules', icon: 'layers' },
      { label: 'Lessons', href: '/governance/instructor/lessons', icon: 'file' },
      { label: 'Learning Materials', href: '/governance/instructor/materials', icon: 'folder' },
      { label: 'Videos', href: '/governance/instructor/videos', icon: 'video' },
    ],
  },
  {
    title: 'Assessments',
    items: [
      { label: 'Mini Projects', href: '/governance/instructor/mini-projects', icon: 'folder' },
      { label: 'Student Submissions', href: '/governance/instructor/submissions', icon: 'upload' },
      { label: 'Grades', href: '/governance/instructor/grades', icon: 'check-circle' },
    ],
  },
  {
    title: 'Students',
    items: [
      { label: 'My Students', href: '/governance/instructor/students', icon: 'users' },
      { label: 'Discussions', href: '/governance/instructor/discussions', icon: 'message-circle' },
    ],
  },
  {
    title: 'Settings',
    items: [
      { label: 'Profile Settings', href: '/governance/instructor/settings', icon: 'settings' },
    ],
  },
];

// Helper function to get navigation by role
export function getNavigationByRole(role: Role): NavSection[] {
  switch (role) {
    case Role.SUPER_ADMIN:
      return SUPER_ADMIN_NAV;
    case Role.SYSTEM_ADMIN:
      return SYSTEM_ADMIN_NAV;
    case Role.ACADEMIC_DIRECTOR:
      return ACADEMIC_DIRECTOR_NAV;
    case Role.HEAD_OF_DOMAIN:
      return HEAD_OF_DOMAIN_NAV;
    case Role.CATEGORY_LEAD:
      return CATEGORY_LEAD_NAV;
    case Role.INSTRUCTOR:
      return INSTRUCTOR_NAV;
    default:
      return [];
  }
}

// Helper function to get dashboard route by role
export function getDashboardRouteByRole(role: Role): string {
  switch (role) {
    case Role.SUPER_ADMIN:
      return DASHBOARD_ROUTES.SUPER_ADMIN;
    case Role.SYSTEM_ADMIN:
      return DASHBOARD_ROUTES.SYSTEM_ADMIN;
    case Role.ACADEMIC_DIRECTOR:
      return DASHBOARD_ROUTES.ACADEMIC_DIRECTOR;
    case Role.HEAD_OF_DOMAIN:
      return DASHBOARD_ROUTES.HEAD_OF_DOMAIN;
    case Role.CATEGORY_LEAD:
      return DASHBOARD_ROUTES.CATEGORY_LEAD;
    case Role.INSTRUCTOR:
      return DASHBOARD_ROUTES.INSTRUCTOR;
    case Role.STUDENT:
    default:
      return DASHBOARD_ROUTES.STUDENT;
  }
}
