-- ============================================
-- INNOVASCI OPEN ACADEMY - RBAC TABLES
-- Run this SQL in Supabase SQL Editor
-- ============================================

-- ============================================
-- RBAC - ROLES - Role definitions for the platform
-- ============================================
CREATE TABLE IF NOT EXISTS "roles" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" TEXT UNIQUE NOT NULL,
  "displayName" TEXT NOT NULL,
  "description" TEXT,
  "level" INT DEFAULT 0,
  "portal" TEXT NOT NULL,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- RBAC - PERMISSIONS - Granular permissions
-- ============================================
CREATE TABLE IF NOT EXISTS "permissions" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" TEXT UNIQUE NOT NULL,
  "category" TEXT NOT NULL,
  "description" TEXT,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- RBAC - ROLE PERMISSIONS - Many-to-many
-- ============================================
CREATE TABLE IF NOT EXISTS "role_permissions" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "roleId" TEXT NOT NULL,
  "permissionId" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("roleId", "permissionId")
);

-- ============================================
-- RBAC - USER ROLES - User to Role mapping
-- ============================================
CREATE TABLE IF NOT EXISTS "user_roles" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "roleId" TEXT NOT NULL,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "roleId")
);

-- ============================================
-- PBAC - POLICIES - Policy definitions
-- ============================================
CREATE TABLE IF NOT EXISTS "policies" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" TEXT UNIQUE NOT NULL,
  "description" TEXT,
  "type" TEXT NOT NULL,
  "rules" JSONB NOT NULL,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PBAC - POLICY RULES - Specific rules
-- ============================================
CREATE TABLE IF NOT EXISTS "policy_rules" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "policyId" TEXT NOT NULL,
  "ruleType" TEXT NOT NULL,
  "field" TEXT NOT NULL,
  "operator" TEXT NOT NULL,
  "value" JSONB NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PBAC - USER POLICIES - User to Policy mapping
-- ============================================
CREATE TABLE IF NOT EXISTS "user_policies" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "policyId" TEXT NOT NULL,
  "scopeId" TEXT,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "policyId", "scopeId")
);

-- ============================================
-- PORTAL ASSIGNMENTS - Portal tracking
-- ============================================
CREATE TABLE IF NOT EXISTS "portal_assignments" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT UNIQUE NOT NULL,
  "portal" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- DOMAIN ASSIGNMENTS - Head of Domain
-- ============================================
CREATE TABLE IF NOT EXISTS "domain_assignments" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "domainId" TEXT NOT NULL,
  "role" TEXT DEFAULT 'HEAD_OF_DOMAIN',
  "status" TEXT DEFAULT 'ACTIVE',
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "domainId")
);

-- ============================================
-- CATEGORY ASSIGNMENTS - Category Lead
-- ============================================
CREATE TABLE IF NOT EXISTS "category_assignments" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "categoryId" TEXT NOT NULL,
  "role" TEXT DEFAULT 'CATEGORY_LEAD',
  "status" TEXT DEFAULT 'ACTIVE',
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "categoryId")
);

-- ============================================
-- COURSE ASSIGNMENTS - Instructor
-- ============================================
CREATE TABLE IF NOT EXISTS "course_assignments" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "courseId" TEXT NOT NULL,
  "role" TEXT DEFAULT 'INSTRUCTOR',
  "status" TEXT DEFAULT 'ACTIVE',
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "courseId")
);

-- ============================================
-- ADD FOREIGN KEYS (idempotent)
-- ============================================

DO $$
BEGIN
  -- role_permissions
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'role_permissions_roleId_fkey') THEN
    ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'role_permissions_permissionId_fkey') THEN
    ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- user_roles
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_roles_userId_fkey') THEN
    ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_roles_roleId_fkey') THEN
    ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- policy_rules
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'policy_rules_policyId_fkey') THEN
    ALTER TABLE "policy_rules" ADD CONSTRAINT "policy_rules_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- user_policies
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_policies_userId_fkey') THEN
    ALTER TABLE "user_policies" ADD CONSTRAINT "user_policies_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_policies_policyId_fkey') THEN
    ALTER TABLE "user_policies" ADD CONSTRAINT "user_policies_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- portal_assignments
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'portal_assignments_userId_fkey') THEN
    ALTER TABLE "portal_assignments" ADD CONSTRAINT "portal_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- domain_assignments
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assignments_userId_fkey') THEN
    ALTER TABLE "domain_assignments" ADD CONSTRAINT "domain_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assignments_domainId_fkey') THEN
    ALTER TABLE "domain_assignments" ADD CONSTRAINT "domain_assignments_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- category_assignments
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'category_assignments_userId_fkey') THEN
    ALTER TABLE "category_assignments" ADD CONSTRAINT "category_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'category_assignments_categoryId_fkey') THEN
    ALTER TABLE "category_assignments" ADD CONSTRAINT "category_assignments_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  -- course_assignments
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'course_assignments_userId_fkey') THEN
    ALTER TABLE "course_assignments" ADD CONSTRAINT "course_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'course_assignments_courseId_fkey') THEN
    ALTER TABLE "course_assignments" ADD CONSTRAINT "course_assignments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

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

-- ============================================
-- CREATE SEED USERS
-- ============================================

-- Hash passwords with bcrypt (12 rounds)
-- Password: Supa$$$ -> $2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy
-- Password: Systemadmin$$$$4 -> $2a$12$...
-- Password: Director$$$$2 -> $2a$12$...
-- Password: Head$$$$3 -> $2a$12$...
-- Password: Lead$$$$4 -> $2a$12$...
-- Password: Instructor$$$$2 -> $2a$12$...

-- Super Administrator
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'super@innovasci.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
  'SUPER_ADMIN',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- System Administrator
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'systemadmin@innovasci.com',
  '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Password: Systemadmin$$$$4
  'SYSTEM_ADMIN',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- Academic Director
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'directoracademic@innovasci.com',
  '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Password: Director$$$$2
  'ACADEMIC_DIRECTOR',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- Head of Domain
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'head@innovasci.com',
  '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Password: Head$$$$3
  'HEAD_OF_DOMAIN',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- Category Lead
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'lead@innovasci.com',
  '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Password: Lead$$$$4
  'CATEGORY_LEAD',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- Instructor
INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
VALUES (
  gen_random_uuid(),
  'instructor@innovasci.com',
  '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Password: Instructor$$$$2
  'INSTRUCTOR',
  'ACTIVE'
)
ON CONFLICT ("email") DO UPDATE SET "passwordHash" = EXCLUDED."passwordHash", "role" = EXCLUDED."role";

-- ============================================
-- ASSIGN ROLES TO USERS
-- ============================================

-- Get role IDs
DO $$
DECLARE
  super_admin_id TEXT;
  system_admin_id TEXT;
  academic_director_id TEXT;
  head_of_domain_id TEXT;
  category_lead_id TEXT;
  instructor_id TEXT;
BEGIN
  SELECT "id" INTO super_admin_id FROM "roles" WHERE "name" = 'SUPER_ADMIN';
  SELECT "id" INTO system_admin_id FROM "roles" WHERE "name" = 'SYSTEM_ADMIN';
  SELECT "id" INTO academic_director_id FROM "roles" WHERE "name" = 'ACADEMIC_DIRECTOR';
  SELECT "id" INTO head_of_domain_id FROM "roles" WHERE "name" = 'HEAD_OF_DOMAIN';
  SELECT "id" INTO category_lead_id FROM "roles" WHERE "name" = 'CATEGORY_LEAD';
  SELECT "id" INTO instructor_id FROM "roles" WHERE "name" = 'INSTRUCTOR';

  -- Assign Super Admin
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", super_admin_id
  FROM "users" u WHERE u."email" = 'super@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Assign System Admin
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", system_admin_id
  FROM "users" u WHERE u."email" = 'systemadmin@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Assign Academic Director
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", academic_director_id
  FROM "users" u WHERE u."email" = 'directoracademic@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Assign Head of Domain
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", head_of_domain_id
  FROM "users" u WHERE u."email" = 'head@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Assign Category Lead
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", category_lead_id
  FROM "users" u WHERE u."email" = 'lead@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Assign Instructor
  INSERT INTO "user_roles" ("userId", "roleId")
  SELECT u."id", instructor_id
  FROM "users" u WHERE u."email" = 'instructor@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- ============================================
  -- ASSIGN PORTALS TO USERS
  -- ============================================

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ADMINISTRATION'
  FROM "users" u WHERE u."email" = 'super@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ADMINISTRATION'
  FROM "users" u WHERE u."email" = 'systemadmin@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'directoracademic@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'head@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'lead@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'INSTRUCTOR'
  FROM "users" u WHERE u."email" = 'instructor@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

END $$;

-- ============================================
-- VERIFICATION QUERIES (optional)
-- ============================================
-- SELECT * FROM "roles";
-- SELECT * FROM "permissions" LIMIT 10;
-- SELECT "users"."email", "roles"."name" as "role", "portal_assignments"."portal"
-- FROM "users"
-- JOIN "user_roles" ON "users"."id" = "user_roles"."userId"
-- JOIN "roles" ON "user_roles"."roleId" = "roles"."id"
-- JOIN "portal_assignments" ON "users"."id" = "portal_assignments"."userId";
