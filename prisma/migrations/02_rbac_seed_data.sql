-- ============================================
-- STEP 2: SEED DATA (Run this after tables)
-- ============================================

-- ============================================
-- INSERT DEFAULT ROLES
-- ============================================
INSERT INTO "roles" ("id", "name", "displayName", "portal", "level", "description", "createdAt", "updatedAt") VALUES
  (gen_random_uuid(), 'SUPER_ADMIN', 'Super Administrator', 'ADMINISTRATION', 100, 'Full platform access', NOW(), NOW()),
  (gen_random_uuid(), 'SYSTEM_ADMIN', 'System Administrator', 'ADMINISTRATION', 90, 'Technical operations', NOW(), NOW()),
  (gen_random_uuid(), 'ACADEMIC_DIRECTOR', 'Academic Director', 'ACADEMIC', 80, 'Academic governance', NOW(), NOW()),
  (gen_random_uuid(), 'HEAD_OF_DOMAIN', 'Head of Domain', 'ACADEMIC', 70, 'Domain management', NOW(), NOW()),
  (gen_random_uuid(), 'CATEGORY_LEAD', 'Category Lead', 'ACADEMIC', 60, 'Category management', NOW(), NOW()),
  (gen_random_uuid(), 'INSTRUCTOR', 'Instructor', 'INSTRUCTOR', 50, 'Course instruction', NOW(), NOW()),
  (gen_random_uuid(), 'STUDENT', 'Student', 'STUDENT', 10, 'Learning access', NOW(), NOW())
ON CONFLICT ("name") DO NOTHING;

-- ============================================
-- INSERT DEFAULT PERMISSIONS
-- ============================================
INSERT INTO "permissions" ("id", "name", "category", "description", "createdAt", "updatedAt") VALUES
-- Users
(gen_random_uuid(), 'USERS_VIEW', 'USERS', 'View users', NOW(), NOW()),
(gen_random_uuid(), 'USERS_CREATE', 'USERS', 'Create users', NOW(), NOW()),
(gen_random_uuid(), 'USERS_UPDATE', 'USERS', 'Update users', NOW(), NOW()),
(gen_random_uuid(), 'USERS_DELETE', 'USERS', 'Delete users', NOW(), NOW()),
(gen_random_uuid(), 'USERS_MANAGE', 'USERS', 'Full user management', NOW(), NOW()),
-- Domains
(gen_random_uuid(), 'DOMAINS_VIEW', 'DOMAINS', 'View domains', NOW(), NOW()),
(gen_random_uuid(), 'DOMAINS_CREATE', 'DOMAINS', 'Create domains', NOW(), NOW()),
(gen_random_uuid(), 'DOMAINS_UPDATE', 'DOMAINS', 'Update domains', NOW(), NOW()),
(gen_random_uuid(), 'DOMAINS_DELETE', 'DOMAINS', 'Delete domains', NOW(), NOW()),
(gen_random_uuid(), 'DOMAINS_MANAGE', 'DOMAINS', 'Full domain management', NOW(), NOW()),
(gen_random_uuid(), 'DOMAINS_APPROVE', 'DOMAINS', 'Approve domains', NOW(), NOW()),
-- Categories
(gen_random_uuid(), 'CATEGORIES_VIEW', 'CATEGORIES', 'View categories', NOW(), NOW()),
(gen_random_uuid(), 'CATEGORIES_CREATE', 'CATEGORIES', 'Create categories', NOW(), NOW()),
(gen_random_uuid(), 'CATEGORIES_UPDATE', 'CATEGORIES', 'Update categories', NOW(), NOW()),
(gen_random_uuid(), 'CATEGORIES_DELETE', 'CATEGORIES', 'Delete categories', NOW(), NOW()),
(gen_random_uuid(), 'CATEGORIES_MANAGE', 'CATEGORIES', 'Full category management', NOW(), NOW()),
(gen_random_uuid(), 'CATEGORIES_APPROVE', 'CATEGORIES', 'Approve categories', NOW(), NOW()),
-- Courses
(gen_random_uuid(), 'COURSES_VIEW', 'COURSES', 'View courses', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_CREATE', 'COURSES', 'Create courses', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_UPDATE', 'COURSES', 'Update courses', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_DELETE', 'COURSES', 'Delete courses', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_MANAGE', 'COURSES', 'Full course management', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_PUBLISH', 'COURSES', 'Publish courses', NOW(), NOW()),
(gen_random_uuid(), 'COURSES_APPROVE', 'COURSES', 'Approve courses', NOW(), NOW()),
-- Projects
(gen_random_uuid(), 'PROJECTS_VIEW', 'PROJECTS', 'View projects', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_CREATE', 'PROJECTS', 'Create projects', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_UPDATE', 'PROJECTS', 'Update projects', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_DELETE', 'PROJECTS', 'Delete projects', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_MANAGE', 'PROJECTS', 'Full project management', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_REVIEW', 'PROJECTS', 'Review projects', NOW(), NOW()),
(gen_random_uuid(), 'PROJECTS_GRADE', 'PROJECTS', 'Grade projects', NOW(), NOW()),
(gen_random_uuid(), 'CAPSTONES_VIEW', 'PROJECTS', 'View capstones', NOW(), NOW()),
(gen_random_uuid(), 'CAPSTONES_REVIEW', 'PROJECTS', 'Review capstones', NOW(), NOW()),
(gen_random_uuid(), 'CAPSTONES_APPROVE', 'PROJECTS', 'Approve capstones', NOW(), NOW()),
-- Certificates
(gen_random_uuid(), 'CERTIFICATES_VIEW', 'CERTIFICATES', 'View certificates', NOW(), NOW()),
(gen_random_uuid(), 'CERTIFICATES_MANAGE', 'CERTIFICATES', 'Full certificate management', NOW(), NOW()),
-- System
(gen_random_uuid(), 'SYSTEM_VIEW', 'SYSTEM', 'View system info', NOW(), NOW()),
(gen_random_uuid(), 'SYSTEM_MONITOR', 'SYSTEM', 'Monitor system', NOW(), NOW()),
(gen_random_uuid(), 'SYSTEM_CONFIGURE', 'SYSTEM', 'Configure system', NOW(), NOW()),
(gen_random_uuid(), 'SYSTEM_MANAGE', 'SYSTEM', 'Full system management', NOW(), NOW()),
-- Storage
(gen_random_uuid(), 'STORAGE_VIEW', 'STORAGE', 'View storage', NOW(), NOW()),
(gen_random_uuid(), 'STORAGE_UPLOAD', 'STORAGE', 'Upload to storage', NOW(), NOW()),
(gen_random_uuid(), 'STORAGE_DELETE', 'STORAGE', 'Delete from storage', NOW(), NOW()),
(gen_random_uuid(), 'STORAGE_MANAGE', 'STORAGE', 'Full storage management', NOW(), NOW()),
-- Database
(gen_random_uuid(), 'DATABASE_VIEW', 'DATABASE', 'View database', NOW(), NOW()),
(gen_random_uuid(), 'DATABASE_BACKUP', 'DATABASE', 'Backup database', NOW(), NOW()),
(gen_random_uuid(), 'DATABASE_RESTORE', 'DATABASE', 'Restore database', NOW(), NOW()),
(gen_random_uuid(), 'DATABASE_MANAGE', 'DATABASE', 'Full database management', NOW(), NOW()),
-- Support
(gen_random_uuid(), 'SUPPORT_VIEW', 'SUPPORT', 'View support tickets', NOW(), NOW()),
(gen_random_uuid(), 'SUPPORT_CREATE', 'SUPPORT', 'Create support tickets', NOW(), NOW()),
(gen_random_uuid(), 'SUPPORT_UPDATE', 'SUPPORT', 'Update support tickets', NOW(), NOW()),
(gen_random_uuid(), 'SUPPORT_MANAGE', 'SUPPORT', 'Full support management', NOW(), NOW()),
-- Portal
(gen_random_uuid(), 'PORTAL_VIEW', 'PORTAL', 'View portal', NOW(), NOW()),
(gen_random_uuid(), 'PORTAL_MANAGE', 'PORTAL', 'Full portal management', NOW(), NOW()),
-- Analytics
(gen_random_uuid(), 'ANALYTICS_VIEW', 'ANALYTICS', 'View analytics', NOW(), NOW()),
(gen_random_uuid(), 'ANALYTICS_EXPORT', 'ANALYTICS', 'Export analytics', NOW(), NOW()),
-- Content
(gen_random_uuid(), 'CONTENT_VIEW', 'CONTENT', 'View content', NOW(), NOW()),
(gen_random_uuid(), 'CONTENT_CREATE', 'CONTENT', 'Create content', NOW(), NOW()),
(gen_random_uuid(), 'CONTENT_UPDATE', 'CONTENT', 'Update content', NOW(), NOW()),
(gen_random_uuid(), 'CONTENT_DELETE', 'CONTENT', 'Delete content', NOW(), NOW()),
(gen_random_uuid(), 'CONTENT_MANAGE', 'CONTENT', 'Full content management', NOW(), NOW()),
-- Enrollments
(gen_random_uuid(), 'ENROLLMENTS_VIEW', 'ENROLLMENTS', 'View enrollments', NOW(), NOW()),
(gen_random_uuid(), 'ENROLLMENTS_CREATE', 'ENROLLMENTS', 'Create enrollments', NOW(), NOW()),
(gen_random_uuid(), 'ENROLLMENTS_UPDATE', 'ENROLLMENTS', 'Update enrollments', NOW(), NOW()),
(gen_random_uuid(), 'ENROLLMENTS_MANAGE', 'ENROLLMENTS', 'Full enrollment management', NOW(), NOW())
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
