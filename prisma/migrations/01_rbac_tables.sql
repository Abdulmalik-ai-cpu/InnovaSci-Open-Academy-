-- ============================================
-- STEP 1: RBAC TABLES (Run this first)
-- ============================================

-- Roles table
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

-- Permissions table
CREATE TABLE IF NOT EXISTS "permissions" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" TEXT UNIQUE NOT NULL,
  "category" TEXT NOT NULL,
  "description" TEXT,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- Role permissions (many-to-many)
CREATE TABLE IF NOT EXISTS "role_permissions" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "roleId" TEXT NOT NULL,
  "permissionId" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("roleId", "permissionId")
);

-- User roles
CREATE TABLE IF NOT EXISTS "user_roles" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT NOT NULL,
  "roleId" TEXT NOT NULL,
  "isActive" BOOLEAN DEFAULT true,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "roleId")
);

-- Policies
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

-- Policy rules
CREATE TABLE IF NOT EXISTS "policy_rules" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "policyId" TEXT NOT NULL,
  "ruleType" TEXT NOT NULL,
  "field" TEXT NOT NULL,
  "operator" TEXT NOT NULL,
  "value" JSONB NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- User policies
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

-- Portal assignments
CREATE TABLE IF NOT EXISTS "portal_assignments" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" TEXT UNIQUE NOT NULL,
  "portal" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- Domain assignments
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

-- Category assignments
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

-- Course assignments
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
-- ADD FOREIGN KEYS (after all tables exist)
-- ============================================

-- role_permissions foreign keys
ALTER TABLE "role_permissions" ADD CONSTRAINT "rp_role_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE;
ALTER TABLE "role_permissions" ADD CONSTRAINT "rp_permission_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE;

-- user_roles foreign keys
ALTER TABLE "user_roles" ADD CONSTRAINT "ur_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "user_roles" ADD CONSTRAINT "ur_role_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE;

-- policy_rules foreign key
ALTER TABLE "policy_rules" ADD CONSTRAINT "pr_policy_fkey" FOREIGN KEY ("policyId") REFERENCES "policies"("id") ON DELETE CASCADE;

-- user_policies foreign keys
ALTER TABLE "user_policies" ADD CONSTRAINT "up_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "user_policies" ADD CONSTRAINT "up_policy_fkey" FOREIGN KEY ("policyId") REFERENCES "policies"("id") ON DELETE CASCADE;

-- portal_assignments foreign key
ALTER TABLE "portal_assignments" ADD CONSTRAINT "pa_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;

-- domain_assignments foreign keys
ALTER TABLE "domain_assignments" ADD CONSTRAINT "da_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "domain_assignments" ADD CONSTRAINT "da_domain_fkey" FOREIGN KEY ("domainId") REFERENCES "domains"("id") ON DELETE CASCADE;

-- category_assignments foreign keys
ALTER TABLE "category_assignments" ADD CONSTRAINT "ca_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "category_assignments" ADD CONSTRAINT "ca_category_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE;

-- course_assignments foreign keys
ALTER TABLE "course_assignments" ADD CONSTRAINT "ca2_user_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "course_assignments" ADD CONSTRAINT "ca2_course_fkey" FOREIGN KEY ("courseId") REFERENCES "courses"("id") ON DELETE CASCADE;
