-- ============================================
-- STEP 3: SEED USERS (Run this last)
-- IMPORTANT: This assumes your users table exists
-- ============================================

-- Get role IDs for assignments
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

  -- ============================================
  -- CREATE SEED USERS (using simple password hash)
  -- All users password: password123
  -- ============================================

  -- Super Administrator
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'super@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'SUPER_ADMIN',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- System Administrator
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'systemadmin@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'SYSTEM_ADMIN',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- Academic Director
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'directoracademic@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'ACADEMIC_DIRECTOR',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- Head of Domain
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'head@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'HEAD_OF_DOMAIN',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- Category Lead
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'lead@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'CATEGORY_LEAD',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- Instructor
  INSERT INTO "users" ("id", "email", "passwordHash", "role", "status")
  VALUES (
    gen_random_uuid(),
    'instructor@innovasci.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.I4E/3Fyq.j3Wy',
    'INSTRUCTOR',
    'ACTIVE'
  )
  ON CONFLICT ("email") DO UPDATE SET 
    "passwordHash" = EXCLUDED."passwordHash", 
    "role" = EXCLUDED."role";

  -- ============================================
  -- ASSIGN ROLES TO USERS
  -- ============================================

  -- Super Admin role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", super_admin_id, NOW()
  FROM "users" u WHERE u."email" = 'super@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- System Admin role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", system_admin_id, NOW()
  FROM "users" u WHERE u."email" = 'systemadmin@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Academic Director role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", academic_director_id, NOW()
  FROM "users" u WHERE u."email" = 'directoracademic@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Head of Domain role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", head_of_domain_id, NOW()
  FROM "users" u WHERE u."email" = 'head@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Category Lead role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", category_lead_id, NOW()
  FROM "users" u WHERE u."email" = 'lead@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- Instructor role
  INSERT INTO "user_roles" ("userId", "roleId", "createdAt")
  SELECT u."id", instructor_id, NOW()
  FROM "users" u WHERE u."email" = 'instructor@innovasci.com'
  ON CONFLICT ("userId", "roleId") DO NOTHING;

  -- ============================================
  -- ASSIGN PORTALS TO USERS
  -- ============================================

  -- Super Admin -> Administration portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ADMINISTRATION'
  FROM "users" u WHERE u."email" = 'super@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  -- System Admin -> Administration portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ADMINISTRATION'
  FROM "users" u WHERE u."email" = 'systemadmin@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  -- Academic Director -> Academic portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'directoracademic@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  -- Head of Domain -> Academic portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'head@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  -- Category Lead -> Academic portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'ACADEMIC'
  FROM "users" u WHERE u."email" = 'lead@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

  -- Instructor -> Instructor portal
  INSERT INTO "portal_assignments" ("userId", "portal")
  SELECT u."id", 'INSTRUCTOR'
  FROM "users" u WHERE u."email" = 'instructor@innovasci.com'
  ON CONFLICT ("userId") DO UPDATE SET "portal" = EXCLUDED."portal";

END $$;

-- ============================================
-- VERIFICATION (run these to check)
-- ============================================
-- SELECT * FROM "roles";
-- SELECT COUNT(*) as permission_count FROM "permissions";
-- SELECT u."email", r."name" as "role", pa."portal"
-- FROM "users" u
-- JOIN "user_roles" ur ON u."id" = ur."userId"
-- JOIN "roles" r ON ur."roleId" = r."id"
-- JOIN "portal_assignments" pa ON u."id" = pa."userId";
