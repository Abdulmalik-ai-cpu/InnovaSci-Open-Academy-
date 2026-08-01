-- ============================================
-- STEP 2: SEED DATA (Run this after tables)
-- ============================================

-- ============================================
-- INSERT DEFAULT ROLES
-- ============================================
INSERT INTO "roles" ("name", "displayName", "portal", "level", "description") VALUES
  ('SUPER_ADMIN', 'Super Administrator', 'ADMINISTRATION', 100, 'Full platform access'),
  ('SYSTEM_ADMIN', 'System Administrator', 'ADMINISTRATION', 90, 'Technical operations'),
  ('ACADEMIC_DIRECTOR', 'Academic Director', 'ACADEMIC', 80, 'Academic governance'),
  ('HEAD_OF_DOMAIN', 'Head of Domain', 'ACADEMIC', 70, 'Domain management'),
  ('CATEGORY_LEAD', 'Category Lead', 'ACADEMIC', 60, 'Category management'),
  ('INSTRUCTOR', 'Instructor', 'INSTRUCTOR', 50, 'Course instruction'),
  ('STUDENT', 'Student', 'STUDENT', 10, 'Learning access')
ON CONFLICT ("name") DO NOTHING;

-- ============================================
-- INSERT DEFAULT PERMISSIONS
-- ============================================
INSERT INTO "permissions" ("name", "category", "description") VALUES
-- Users
('USERS_VIEW', 'USERS', 'View users'),
('USERS_CREATE', 'USERS', 'Create users'),
('USERS_UPDATE', 'USERS', 'Update users'),
('USERS_DELETE', 'USERS', 'Delete users'),
('USERS_MANAGE', 'USERS', 'Full user management'),
-- Domains
('DOMAINS_VIEW', 'DOMAINS', 'View domains'),
('DOMAINS_CREATE', 'DOMAINS', 'Create domains'),
('DOMAINS_UPDATE', 'DOMAINS', 'Update domains'),
('DOMAINS_DELETE', 'DOMAINS', 'Delete domains'),
('DOMAINS_MANAGE', 'DOMAINS', 'Full domain management'),
('DOMAINS_APPROVE', 'DOMAINS', 'Approve domains'),
-- Categories
('CATEGORIES_VIEW', 'CATEGORIES', 'View categories'),
('CATEGORIES_CREATE', 'CATEGORIES', 'Create categories'),
('CATEGORIES_UPDATE', 'CATEGORIES', 'Update categories'),
('CATEGORIES_DELETE', 'CATEGORIES', 'Delete categories'),
('CATEGORIES_MANAGE', 'CATEGORIES', 'Full category management'),
('CATEGORIES_APPROVE', 'CATEGORIES', 'Approve categories'),
-- Courses
('COURSES_VIEW', 'COURSES', 'View courses'),
('COURSES_CREATE', 'COURSES', 'Create courses'),
('COURSES_UPDATE', 'COURSES', 'Update courses'),
('COURSES_DELETE', 'COURSES', 'Delete courses'),
('COURSES_MANAGE', 'COURSES', 'Full course management'),
('COURSES_PUBLISH', 'COURSES', 'Publish courses'),
('COURSES_APPROVE', 'COURSES', 'Approve courses'),
-- Projects
('PROJECTS_VIEW', 'PROJECTS', 'View projects'),
('PROJECTS_CREATE', 'PROJECTS', 'Create projects'),
('PROJECTS_UPDATE', 'PROJECTS', 'Update projects'),
('PROJECTS_DELETE', 'PROJECTS', 'Delete projects'),
('PROJECTS_MANAGE', 'PROJECTS', 'Full project management'),
('PROJECTS_REVIEW', 'PROJECTS', 'Review projects'),
('PROJECTS_GRADE', 'PROJECTS', 'Grade projects'),
('CAPSTONES_VIEW', 'PROJECTS', 'View capstones'),
('CAPSTONES_REVIEW', 'PROJECTS', 'Review capstones'),
('CAPSTONES_APPROVE', 'PROJECTS', 'Approve capstones'),
-- Certificates
('CERTIFICATES_VIEW', 'CERTIFICATES', 'View certificates'),
('CERTIFICATES_MANAGE', 'CERTIFICATES', 'Full certificate management'),
-- System
('SYSTEM_VIEW', 'SYSTEM', 'View system info'),
('SYSTEM_MONITOR', 'SYSTEM', 'Monitor system'),
('SYSTEM_CONFIGURE', 'SYSTEM', 'Configure system'),
('SYSTEM_MANAGE', 'SYSTEM', 'Full system management'),
-- Storage
('STORAGE_VIEW', 'STORAGE', 'View storage'),
('STORAGE_UPLOAD', 'STORAGE', 'Upload to storage'),
('STORAGE_DELETE', 'STORAGE', 'Delete from storage'),
('STORAGE_MANAGE', 'STORAGE', 'Full storage management'),
-- Database
('DATABASE_VIEW', 'DATABASE', 'View database'),
('DATABASE_BACKUP', 'DATABASE', 'Backup database'),
('DATABASE_RESTORE', 'DATABASE', 'Restore database'),
('DATABASE_MANAGE', 'DATABASE', 'Full database management'),
-- Support
('SUPPORT_VIEW', 'SUPPORT', 'View support tickets'),
('SUPPORT_CREATE', 'SUPPORT', 'Create support tickets'),
('SUPPORT_UPDATE', 'SUPPORT', 'Update support tickets'),
('SUPPORT_MANAGE', 'SUPPORT', 'Full support management'),
-- Portal
('PORTAL_VIEW', 'PORTAL', 'View portal'),
('PORTAL_MANAGE', 'PORTAL', 'Full portal management'),
-- Analytics
('ANALYTICS_VIEW', 'ANALYTICS', 'View analytics'),
('ANALYTICS_EXPORT', 'ANALYTICS', 'Export analytics'),
-- Content
('CONTENT_VIEW', 'CONTENT', 'View content'),
('CONTENT_CREATE', 'CONTENT', 'Create content'),
('CONTENT_UPDATE', 'CONTENT', 'Update content'),
('CONTENT_DELETE', 'CONTENT', 'Delete content'),
('CONTENT_MANAGE', 'CONTENT', 'Full content management'),
-- Enrollments
('ENROLLMENTS_VIEW', 'ENROLLMENTS', 'View enrollments'),
('ENROLLMENTS_CREATE', 'ENROLLMENTS', 'Create enrollments'),
('ENROLLMENTS_UPDATE', 'ENROLLMENTS', 'Update enrollments'),
('ENROLLMENTS_MANAGE', 'ENROLLMENTS', 'Full enrollment management')
ON CONFLICT ("name") DO NOTHING;

-- ============================================
-- ASSIGN PERMISSIONS TO ROLES
-- ============================================

-- Super Admin gets ALL permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'SUPER_ADMIN'
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- System Admin permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'SYSTEM_ADMIN'
AND p."category" IN ('SYSTEM', 'STORAGE', 'DATABASE', 'SUPPORT', 'PORTAL', 'ANALYTICS')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Academic Director permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'ACADEMIC_DIRECTOR'
AND p."category" IN ('DOMAINS', 'CATEGORIES', 'COURSES', 'PROJECTS', 'CONTENT', 'ENROLLMENTS', 'ANALYTICS', 'CERTIFICATES')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Head of Domain permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'HEAD_OF_DOMAIN'
AND p."name" IN (
  'CATEGORIES_VIEW', 'CATEGORIES_UPDATE',
  'COURSES_VIEW', 'COURSES_UPDATE',
  'PROJECTS_VIEW', 'PROJECTS_REVIEW', 'PROJECTS_GRADE',
  'CAPSTONES_VIEW', 'CAPSTONES_REVIEW', 'CAPSTONES_APPROVE',
  'CONTENT_VIEW', 'CONTENT_UPDATE',
  'ENROLLMENTS_VIEW', 'ANALYTICS_VIEW'
)
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Category Lead permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'CATEGORY_LEAD'
AND p."name" IN (
  'CATEGORIES_VIEW',
  'COURSES_VIEW', 'COURSES_UPDATE',
  'PROJECTS_VIEW', 'PROJECTS_REVIEW', 'PROJECTS_GRADE',
  'CAPSTONES_VIEW', 'CAPSTONES_REVIEW',
  'CONTENT_VIEW', 'CONTENT_UPDATE',
  'ENROLLMENTS_VIEW', 'ANALYTICS_VIEW'
)
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Instructor permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'INSTRUCTOR'
AND p."name" IN (
  'COURSES_VIEW', 'COURSES_UPDATE',
  'PROJECTS_VIEW', 'PROJECTS_GRADE',
  'CONTENT_VIEW', 'CONTENT_CREATE', 'CONTENT_UPDATE',
  'ENROLLMENTS_VIEW'
)
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Student permissions
INSERT INTO "role_permissions" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r, "permissions" p
WHERE r."name" = 'STUDENT'
AND p."name" IN ('COURSES_VIEW', 'ENROLLMENTS_VIEW', 'PROJECTS_VIEW')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;
