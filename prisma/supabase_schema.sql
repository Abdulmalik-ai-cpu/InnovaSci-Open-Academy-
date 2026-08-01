-- ============================================
-- InnovaSci Open Academy - Production Schema
-- Generated from Prisma schema
-- ============================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- PHASE 1: ENUM TYPES
-- ============================================

DO $$ BEGIN
    CREATE TYPE "PurchaseScope" AS ENUM ('ACADEMY', 'DOMAIN', 'CATEGORY');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "PricingMode" AS ENUM ('MANUAL', 'AUTO_CONVERSION', 'HYBRID');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "ScholarshipType" AS ENUM ('FORCEWORK', 'MERIT', 'NEED_BASED', 'RESEARCH_INNOVATION', 'SPECIAL_NEED', 'COMMUNITY_IMPACT', 'FOUNDER', 'SPONSORED', 'ZAKAT_WAQF', 'TUITION_WAIVER', 'PARTIAL', 'FULL', 'FINANCIAL_AID');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "ScholarshipStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'CLOSED', 'ARCHIVED', 'DISABLED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "ApplicationStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'UNDER_REVIEW', 'INTERVIEW', 'APPROVED', 'REJECTED', 'AWARDED', 'EXPIRED', 'WITHDRAWN');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "SponsorType" AS ENUM ('COMPANY', 'NGO', 'FOUNDATION', 'GOVERNMENT', 'INDIVIDUAL', 'ISLAMIC_ORG');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "SponsorStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "AwardStatus" AS ENUM ('PENDING', 'ACCEPTED', 'DECLINED', 'REVOKED', 'EXPIRED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE "ReviewStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;


-- ============================================
-- PHASE 2: TABLES (Dependency Order)
-- ============================================

-- User -> users
CREATE TABLE IF NOT EXISTS "users" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "email" TEXT NOT NULL UNIQUE,
    "passwordHash" TEXT,
    "role" TEXT NOT NULL DEFAULT "STUDENT",
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "emailVerified" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Domain -> domains
CREATE TABLE IF NOT EXISTS "domains" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL UNIQUE,
    "shortName" TEXT,
    "slug" TEXT NOT NULL UNIQUE,
    "shortDescription" TEXT,
    "fullDescription" TEXT,
    "thumbnailUrl" TEXT,
    "bannerUrl" TEXT,
    "icon" TEXT,
    "color" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT "DRAFT",
    "visibility" TEXT NOT NULL DEFAULT "PUBLIC",
    "isFeatured" BOOLEAN NOT NULL DEFAULT FALSE,
    "seoTitle" TEXT,
    "seoDescription" TEXT,
    "seoKeywords" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CertificateTemplate -> certificate_templates
CREATE TABLE IF NOT EXISTS "certificate_templates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL DEFAULT "COURSE",
    "backgroundUrl" TEXT NOT NULL,
    "width" INTEGER NOT NULL DEFAULT 1200,
    "height" INTEGER NOT NULL DEFAULT 900,
    "studentNameX" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "studentNameY" DOUBLE PRECISION NOT NULL DEFAULT 0.35,
    "studentNameSize" INTEGER NOT NULL DEFAULT 48,
    "studentNameFont" TEXT NOT NULL DEFAULT "Georgia",
    "courseNameX" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "courseNameY" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "courseNameSize" INTEGER NOT NULL DEFAULT 32,
    "courseNameFont" TEXT NOT NULL DEFAULT "Georgia",
    "issueDateX" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "issueDateY" DOUBLE PRECISION NOT NULL DEFAULT 0.65,
    "issueDateSize" INTEGER NOT NULL DEFAULT 24,
    "issueDateFont" TEXT NOT NULL DEFAULT "Georgia",
    "certificateIdX" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "certificateIdY" DOUBLE PRECISION NOT NULL DEFAULT 0.75,
    "certificateIdSize" INTEGER NOT NULL DEFAULT 18,
    "certificateIdFont" TEXT NOT NULL DEFAULT "Courier",
    "domainNameX" DOUBLE PRECISION,
    "domainNameY" DOUBLE PRECISION,
    "domainNameSize" INTEGER,
    "domainNameFont" TEXT,
    "categoryNameX" DOUBLE PRECISION,
    "categoryNameY" DOUBLE PRECISION,
    "categoryNameSize" INTEGER,
    "categoryNameFont" TEXT,
    "certificateTypeX" DOUBLE PRECISION,
    "certificateTypeY" DOUBLE PRECISION,
    "certificateTypeSize" INTEGER,
    "certificateTypeFont" TEXT,
    "ceoSignatureX" DOUBLE PRECISION,
    "ceoSignatureY" DOUBLE PRECISION,
    "ceoSignatureWidth" INTEGER,
    "ceoSignatureHeight" INTEGER,
    "academicDirectorSignatureX" DOUBLE PRECISION,
    "academicDirectorSignatureY" DOUBLE PRECISION,
    "academicDirectorSignatureWidth" INTEGER,
    "academicDirectorSignatureHeight" INTEGER,
    "officialSealX" DOUBLE PRECISION,
    "officialSealY" DOUBLE PRECISION,
    "officialSealWidth" INTEGER,
    "officialSealHeight" INTEGER,
    "textColor" TEXT NOT NULL DEFAULT "#1a1a2e",
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Plan -> plans
CREATE TABLE IF NOT EXISTS "plans" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "planType" TEXT NOT NULL DEFAULT "subscription",
    "billingCycle" TEXT NOT NULL DEFAULT "monthly",
    "purchaseScope" "PurchaseScope" NOT NULL,
    "price" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "pricing" JSONB,
    "stripePriceId" TEXT UNIQUE,
    "paystackPlanId" TEXT UNIQUE,
    "features" JSONB DEFAULT "[]",
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isFeatured" BOOLEAN NOT NULL DEFAULT FALSE,
    "discountPercentage" INTEGER DEFAULT 0,
    "promoCode" TEXT,
    "maxCourses" INTEGER,
    "maxCertificates" INTEGER,
    "trialDays" INTEGER DEFAULT 0,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "pricingMode" "PricingMode" NOT NULL,
    "baseCurrency" TEXT NOT NULL DEFAULT "NGN",
    "ngnPrice" DECIMAL(10,2) DEFAULT 0,
    "usdPrice" DECIMAL(10,2) DEFAULT 0,
    "generatedNgnPrice" DECIMAL(10,2),
    "generatedUsdPrice" DECIMAL(10,2),
    "exchangeRate" DECIMAL(10,2) DEFAULT 1,
    "exchangeRateSource" TEXT,
    "exchangeRateTimestamp" TIMESTAMP(3),
    "icon" TEXT,
    "bannerUrl" TEXT,
    "themeColor" TEXT,
    "status" TEXT NOT NULL DEFAULT "PUBLISHED",
    "visibility" TEXT NOT NULL DEFAULT "PUBLIC",
    "isPopular" BOOLEAN NOT NULL DEFAULT FALSE,
    "isRecommended" BOOLEAN NOT NULL DEFAULT FALSE,
    "seoTitle" TEXT,
    "seoDescription" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CurrencySetting -> currency_settings
CREATE TABLE IF NOT EXISTS "currency_settings" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "currency" TEXT NOT NULL UNIQUE,
    "name" TEXT NOT NULL,
    "symbol" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "exchangeRate" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "isEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "isDefault" BOOLEAN NOT NULL DEFAULT FALSE,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "gatewayProvider" TEXT,
    "gatewayEnabled" BOOLEAN NOT NULL DEFAULT FALSE,
    "gatewayConfig" JSONB,
    "decimalPlaces" INTEGER NOT NULL DEFAULT 2,
    "thousandsSeparator" TEXT NOT NULL DEFAULT ",",
    "decimalSeparator" TEXT NOT NULL DEFAULT ".",
    "symbolPosition" TEXT NOT NULL DEFAULT "before",
    "exchangeRateProvider" TEXT,
    "lastRateUpdate" TIMESTAMP(3),
    "autoUpdateRates" BOOLEAN NOT NULL DEFAULT FALSE,
    "updateIntervalHours" INTEGER NOT NULL DEFAULT 24,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- PaymentGateway -> payment_gateways
CREATE TABLE IF NOT EXISTS "payment_gateways" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL UNIQUE,
    "provider" TEXT NOT NULL,
    "slug" TEXT NOT NULL UNIQUE,
    "isEnabled" BOOLEAN NOT NULL DEFAULT FALSE,
    "isDefault" BOOLEAN NOT NULL DEFAULT FALSE,
    "environment" TEXT NOT NULL DEFAULT "sandbox",
    "logoUrl" TEXT,
    "iconName" TEXT,
    "color" TEXT,
    "publicKey" TEXT,
    "secretKey" TEXT,
    "webhookSecret" TEXT,
    "transactionFeePercent" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "transactionFeeFixed" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "priority" INTEGER NOT NULL DEFAULT 100,
    "lastHealthCheck" TIMESTAMP(3),
    "healthStatus" TEXT NOT NULL DEFAULT "unknown",
    "healthMessage" TEXT,
    "notes" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- ExchangeRate -> exchange_rates
CREATE TABLE IF NOT EXISTS "exchange_rates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "fromCurrency" TEXT NOT NULL,
    "toCurrency" TEXT NOT NULL,
    "rate" DECIMAL(10,2) NOT NULL,
    "isAutomatic" BOOLEAN NOT NULL DEFAULT FALSE,
    "provider" TEXT,
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validUntil" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- PaymentSettings -> payment_settings
CREATE TABLE IF NOT EXISTS "payment_settings" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "defaultGatewayId" TEXT,
    "defaultCurrency" TEXT NOT NULL DEFAULT "USD",
    "exchangeRateMode" TEXT NOT NULL DEFAULT "automatic",
    "autoUpdateRates" BOOLEAN NOT NULL DEFAULT TRUE,
    "updateIntervalHours" INTEGER NOT NULL DEFAULT 24,
    "paymentTimeout" INTEGER NOT NULL DEFAULT 30,
    "retryAttempts" INTEGER NOT NULL DEFAULT 3,
    "refundEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "refundWindowDays" INTEGER NOT NULL DEFAULT 7,
    "webhookEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "webhookRetries" INTEGER NOT NULL DEFAULT 3,
    "invoicePrefix" TEXT NOT NULL DEFAULT "INV",
    "invoiceAutoNumber" BOOLEAN NOT NULL DEFAULT TRUE,
    "receiptEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "receiptEmailEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "taxEnabled" BOOLEAN NOT NULL DEFAULT FALSE,
    "taxRate" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "taxName" TEXT NOT NULL DEFAULT "Tax",
    "platformFeePercent" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "platformFeeFixed" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Coupon -> coupons
CREATE TABLE IF NOT EXISTS "coupons" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "code" TEXT NOT NULL UNIQUE,
    "discountType" TEXT NOT NULL,
    "discountValue" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "maxUses" INTEGER,
    "currentUses" INTEGER NOT NULL DEFAULT 0,
    "maxUsesPerUser" INTEGER NOT NULL DEFAULT 1,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "applicableScope" TEXT NOT NULL DEFAULT "all",
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isPublic" BOOLEAN NOT NULL DEFAULT TRUE,
    "minPurchaseAmount" DECIMAL(10,2),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- LearningPath -> learning_paths
CREATE TABLE IF NOT EXISTS "learning_paths" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL UNIQUE,
    "subtitle" TEXT,
    "description" TEXT,
    "thumbnailUrl" TEXT,
    "difficultyLevel" TEXT NOT NULL DEFAULT "beginner",
    "estimatedHours" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isPublished" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- NewsletterSubscriber -> newsletter_subscribers
CREATE TABLE IF NOT EXISTS "newsletter_subscribers" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "email" TEXT NOT NULL UNIQUE,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "subscribedAt" TIMESTAMP(3) NOT NULL,
    "unsubscribedAt" TIMESTAMP(3)
);

-- NewsletterCampaign -> newsletter_campaigns
CREATE TABLE IF NOT EXISTS "newsletter_campaigns" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT "draft",
    "recipientType" TEXT NOT NULL DEFAULT "all",
    "recipientCourseId" TEXT,
    "scheduledAt" TIMESTAMP(3),
    "sentAt" TIMESTAMP(3),
    "totalRecipients" INTEGER NOT NULL DEFAULT 0,
    "successfulSends" INTEGER NOT NULL DEFAULT 0,
    "failedSends" INTEGER NOT NULL DEFAULT 0,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- StoredFile -> stored_files
CREATE TABLE IF NOT EXISTS "stored_files" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "originalName" TEXT NOT NULL,
    "storedName" TEXT NOT NULL UNIQUE,
    "fileUrl" TEXT NOT NULL UNIQUE,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileType" TEXT NOT NULL,
    "storageType" TEXT NOT NULL DEFAULT "local",
    "folder" TEXT,
    "courseId" TEXT,
    "uploadedBy" TEXT,
    "isOrphaned" BOOLEAN NOT NULL DEFAULT FALSE,
    "lastAccessedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- SystemSetting -> system_settings
CREATE TABLE IF NOT EXISTS "system_settings" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "key" TEXT NOT NULL UNIQUE,
    "value" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT "string",
    "category" TEXT NOT NULL DEFAULT "general",
    "description" TEXT,
    "isPublic" BOOLEAN NOT NULL DEFAULT FALSE,
    "isEncrypted" BOOLEAN NOT NULL DEFAULT FALSE,
    "validation" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- DifficultyLevelCapstone -> difficulty_level_caps
CREATE TABLE IF NOT EXISTS "difficulty_level_caps" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "difficultyLevel" TEXT NOT NULL,
    "includedCourses" JSONB,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "isPublished" BOOLEAN NOT NULL DEFAULT FALSE,
    "thumbnailUrl" TEXT,
    "certificateTemplateId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- ProfessionalCapstone -> professional_caps
CREATE TABLE IF NOT EXISTS "professional_caps" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "categoryId" TEXT,
    "includedCourses" JSONB,
    "requirements" TEXT,
    "deliverables" JSONB,
    "evaluationCriteria" JSONB,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "isPublished" BOOLEAN NOT NULL DEFAULT FALSE,
    "thumbnailUrl" TEXT,
    "certificateTemplateId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- ProjectRubric -> project_rubrics
CREATE TABLE IF NOT EXISTS "project_rubrics" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL DEFAULT "MINI_PROJECT",
    "courseId" TEXT,
    "difficultyLevel" TEXT,
    "criteria" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isDefault" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Sponsor -> sponsors
CREATE TABLE IF NOT EXISTS "sponsors" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "shortName" TEXT,
    "slug" TEXT NOT NULL UNIQUE,
    "type" "SponsorType" NOT NULL,
    "logo" TEXT,
    "website" TEXT,
    "description" TEXT,
    "contactName" TEXT,
    "contactEmail" TEXT,
    "contactPhone" TEXT,
    "address" TEXT,
    "status" "SponsorStatus" NOT NULL,
    "budget" DECIMAL(10,2) DEFAULT 0,
    "spent" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "seoTitle" TEXT,
    "seoDescription" TEXT,
    "config" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- ScholarshipAnalytics -> scholarship_analytics
CREATE TABLE IF NOT EXISTS "scholarship_analytics" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "views" INTEGER NOT NULL DEFAULT 0,
    "applications" INTEGER NOT NULL DEFAULT 0,
    "approved" INTEGER NOT NULL DEFAULT 0,
    "rejected" INTEGER NOT NULL DEFAULT 0,
    "pending" INTEGER NOT NULL DEFAULT 0,
    "demographics" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- ScholarshipScoringRubric -> scholarship_scoring_rubrics
CREATE TABLE IF NOT EXISTS "scholarship_scoring_rubrics" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "criteria" JSONB NOT NULL,
    "totalScore" INTEGER NOT NULL DEFAULT 100,
    "passingScore" INTEGER NOT NULL DEFAULT 60,
    "isDefault" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Role -> roles
CREATE TABLE IF NOT EXISTS "roles" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL UNIQUE,
    "displayName" TEXT NOT NULL,
    "description" TEXT,
    "level" INTEGER NOT NULL DEFAULT 0,
    "portal" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Permission -> permissions
CREATE TABLE IF NOT EXISTS "permissions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL UNIQUE,
    "category" TEXT NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Policy -> policies
CREATE TABLE IF NOT EXISTS "policies" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "type" TEXT NOT NULL,
    "rules" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Profile -> profiles
CREATE TABLE IF NOT EXISTS "profiles" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL UNIQUE,
    "fullName" TEXT,
    "username" TEXT UNIQUE,
    "phone" TEXT,
    "country" TEXT,
    "countryCode" TEXT,
    "state" TEXT,
    "stateCode" TEXT,
    "city" TEXT,
    "postalCode" TEXT,
    "streetAddress" TEXT,
    "gender" TEXT,
    "bio" TEXT,
    "avatarUrl" TEXT,
    "status" TEXT NOT NULL DEFAULT "active",
    "preferences" JSONB DEFAULT "{}",
    "currency" TEXT,
    "currencySymbol" TEXT,
    "language" TEXT,
    "timezone" TEXT,
    "preferredGateway" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- PortfolioEntry -> portfolio_entries
CREATE TABLE IF NOT EXISTS "portfolio_entries" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "liveUrl" TEXT,
    "githubUrl" TEXT,
    "demoVideoUrl" TEXT,
    "screenshots" JSONB,
    "demoVideo" TEXT,
    "rationale" TEXT,
    "visibility" TEXT NOT NULL DEFAULT "PRIVATE",
    "publicSlug" TEXT UNIQUE,
    "linkedCourseId" TEXT,
    "linkedMiniProjectId" TEXT,
    "linkedCapstoneId" TEXT,
    "isPublished" BOOLEAN NOT NULL DEFAULT FALSE,
    "viewCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "portfolio_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- SupportTicket -> support_tickets
CREATE TABLE IF NOT EXISTS "support_tickets" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT,
    "email" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "subject" TEXT,
    "message" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT "open",
    "priority" TEXT NOT NULL DEFAULT "medium",
    "assignedTo" TEXT,
    "labels" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "resolvedAt" TIMESTAMP(3),
    CONSTRAINT "support_tickets_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id")
);

-- Instructor -> instructors
CREATE TABLE IF NOT EXISTS "instructors" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT,
    "name" TEXT NOT NULL,
    "title" TEXT,
    "bio" TEXT,
    "avatarUrl" TEXT,
    "socialLinks" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "instructors_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id")
);

-- CertificateProgress -> certificate_progress
CREATE TABLE IF NOT EXISTS "certificate_progress" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "categoryCertificateId" TEXT,
    "domainCertificateId" TEXT,
    "coursesCompleted" INTEGER NOT NULL DEFAULT 0,
    "totalCourses" INTEGER NOT NULL DEFAULT 0,
    "lessonsCompleted" INTEGER NOT NULL DEFAULT 0,
    "totalLessons" INTEGER NOT NULL DEFAULT 0,
    "exercisesCompleted" INTEGER NOT NULL DEFAULT 0,
    "totalExercises" INTEGER NOT NULL DEFAULT 0,
    "miniProjectsCompleted" INTEGER NOT NULL DEFAULT 0,
    "totalMiniProjects" INTEGER NOT NULL DEFAULT 0,
    "capstonesCompleted" INTEGER NOT NULL DEFAULT 0,
    "totalCapstones" INTEGER NOT NULL DEFAULT 0,
    "overallProgress" INTEGER NOT NULL DEFAULT 0,
    "lastActivityAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "certificate_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- Notification -> notifications
CREATE TABLE IF NOT EXISTS "notifications" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT "info",
    "read" BOOLEAN NOT NULL DEFAULT FALSE,
    "data" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- AccessLicense -> access_licenses
CREATE TABLE IF NOT EXISTS "access_licenses" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "licenseType" TEXT NOT NULL,
    "targetId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT "active",
    "grantedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "revokedAt" TIMESTAMP(3),
    "revokedReason" TEXT,
    "sourceType" TEXT NOT NULL,
    "purchaseId" TEXT,
    "grantedByAdminId" TEXT,
    "coursesEnrolled" INTEGER NOT NULL DEFAULT 0,
    "lastEnrolledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "access_licenses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- CertificateEligibility -> certificate_eligibility
CREATE TABLE IF NOT EXISTS "certificate_eligibility" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "certificateType" TEXT NOT NULL,
    "certificateId" TEXT NOT NULL,
    "isEligible" BOOLEAN NOT NULL DEFAULT FALSE,
    "eligibilityCheckedAt" TIMESTAMP(3) NOT NULL,
    "lastCheckedAt" TIMESTAMP(3) NOT NULL,
    "requirements" JSONB NOT NULL,
    "eligibleAt" TIMESTAMP(3),
    "notifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "certificate_eligibility_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- ForumThread -> forum_threads
CREATE TABLE IF NOT EXISTS "forum_threads" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT "general",
    "authorId" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isPinned" BOOLEAN NOT NULL DEFAULT FALSE,
    "isResolved" BOOLEAN NOT NULL DEFAULT FALSE,
    "viewCount" INTEGER NOT NULL DEFAULT 0,
    "replyCount" INTEGER NOT NULL DEFAULT 0,
    "lastReplyAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "forum_threads_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "users" ("id") NOT NULL
);

-- PortalAssignment -> portal_assignments
CREATE TABLE IF NOT EXISTS "portal_assignments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL UNIQUE,
    "portal" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "portal_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- Invoice -> invoices
CREATE TABLE IF NOT EXISTS "invoices" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "invoiceNumber" TEXT NOT NULL UNIQUE,
    "userId" TEXT NOT NULL,
    "userEmail" TEXT NOT NULL,
    "items" JSONB NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "discountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "taxAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "status" TEXT NOT NULL DEFAULT "draft",
    "dueDate" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "paymentId" TEXT,
    "couponId" TEXT,
    "couponCode" TEXT,
    "billingAddress" JSONB,
    "notes" TEXT,
    "terms" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "invoices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- Payment -> payments
CREATE TABLE IF NOT EXISTS "payments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT "one_time",
    "status" TEXT NOT NULL DEFAULT "PENDING",
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT "NGN",
    "amountInKobo" INTEGER,
    "amountInCents" INTEGER,
    "paystackReference" TEXT,
    "paystackRef" TEXT,
    "paystackId" TEXT,
    "channel" TEXT,
    "paystackChannel" TEXT,
    "authorizationCode" TEXT,
    "paystackFees" DECIMAL(10,2),
    "gatewayResponse" JSONB,
    "categoryPurchaseId" TEXT,
    "domainPurchaseId" TEXT,
    "academyPurchaseId" TEXT,
    "metadata" JSONB,
    "initiatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),
    "refundedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "payments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL
);

-- DomainCertificate -> domain_certificates
CREATE TABLE IF NOT EXISTS "domain_certificates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "domainId" TEXT NOT NULL,
    "certificateName" TEXT NOT NULL,
    "description" TEXT,
    "requirements" JSONB,
    "templateData" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "domain_certificates_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") NOT NULL
);

-- Category -> categories
CREATE TABLE IF NOT EXISTS "categories" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "thumbnailUrl" TEXT,
    "bannerUrl" TEXT,
    "color" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "visibility" TEXT NOT NULL DEFAULT "PUBLIC",
    "seoTitle" TEXT,
    "seoDescription" TEXT,
    "seoKeywords" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "domainId" TEXT,
    CONSTRAINT "categories_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id")
);

-- DomainAssignment -> domain_assignments
CREATE TABLE IF NOT EXISTS "domain_assignments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT "HEAD_OF_DOMAIN",
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "domain_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "domain_assignments_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") NOT NULL
);

-- AcademyPurchase -> academy_purchases
CREATE TABLE IF NOT EXISTS "academy_purchases" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "planId" TEXT,
    "amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "paymentId" TEXT,
    "status" TEXT NOT NULL DEFAULT "active",
    "purchasedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "refundedAt" TIMESTAMP(3),
    "refundReason" TEXT,
    "couponId" TEXT,
    "couponCode" TEXT,
    "discountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "invoiceId" TEXT,
    "paystackRef" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "academy_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "academy_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id")
);

-- DomainPurchase -> domain_purchases
CREATE TABLE IF NOT EXISTS "domain_purchases" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "planId" TEXT,
    "domainId" TEXT NOT NULL,
    "domainName" TEXT NOT NULL,
    "amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "paymentId" TEXT,
    "status" TEXT NOT NULL DEFAULT "active",
    "purchasedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "refundedAt" TIMESTAMP(3),
    "refundReason" TEXT,
    "couponId" TEXT,
    "couponCode" TEXT,
    "discountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "invoiceId" TEXT,
    "paystackRef" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "domain_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "domain_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id"),
    CONSTRAINT "domain_purchases_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") NOT NULL
);

-- Subscription -> subscriptions
CREATE TABLE IF NOT EXISTS "subscriptions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "planId" TEXT,
    "planName" TEXT NOT NULL DEFAULT "FREE",
    "status" TEXT NOT NULL DEFAULT "active",
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "recurringPrice" DECIMAL(10,2),
    "isPro" BOOLEAN NOT NULL DEFAULT FALSE,
    "autoRenew" BOOLEAN NOT NULL DEFAULT TRUE,
    "paystackSubscriptionCode" TEXT,
    "stripeSubscriptionId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "subscriptions_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id")
);

-- GatewayConfiguration -> gateway_configurations
CREATE TABLE IF NOT EXISTS "gateway_configurations" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "gatewayId" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "countryName" TEXT NOT NULL,
    "currency" TEXT NOT NULL,
    "isEnabled" BOOLEAN NOT NULL DEFAULT TRUE,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "config" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "gateway_configurations_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "payment_gateways" ("id") NOT NULL
);

-- PaymentTransaction -> payment_transactions
CREATE TABLE IF NOT EXISTS "payment_transactions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "gatewayId" TEXT NOT NULL,
    "reference" TEXT NOT NULL UNIQUE,
    "gatewayRef" TEXT,
    "userId" TEXT,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL,
    "amountInBase" DECIMAL(10,2),
    "exchangeRate" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "status" TEXT NOT NULL DEFAULT "pending",
    "purchaseType" TEXT NOT NULL,
    "purchaseId" TEXT,
    "metadata" JSONB,
    "gatewayResponse" JSONB,
    "paymentMethod" TEXT,
    "customerEmail" TEXT,
    "customerName" TEXT,
    "processingFee" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "platformFee" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "initiatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "errorMessage" TEXT,
    "errorCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "payment_transactions_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "payment_gateways" ("id") NOT NULL
);

-- PaymentGatewayLog -> payment_gateway_logs
CREATE TABLE IF NOT EXISTS "payment_gateway_logs" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "gatewayId" TEXT NOT NULL,
    "transactionId" TEXT,
    "logType" TEXT NOT NULL,
    "level" TEXT NOT NULL DEFAULT "info",
    "method" TEXT,
    "endpoint" TEXT,
    "requestBody" JSONB,
    "responseBody" JSONB,
    "responseStatus" INTEGER,
    "responseTime" INTEGER,
    "errorMessage" TEXT,
    "errorStack" TEXT,
    "ipAddress" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "payment_gateway_logs_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "payment_gateways" ("id") NOT NULL
);

-- DiscountCampaign -> discount_campaigns
CREATE TABLE IF NOT EXISTS "discount_campaigns" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "discountType" TEXT NOT NULL,
    "discountValue" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "targetType" TEXT NOT NULL,
    "planId" TEXT,
    "domainId" TEXT,
    "categoryId" TEXT,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3),
    "couponId" TEXT,
    "couponCode" TEXT,
    "requiresCoupon" BOOLEAN NOT NULL DEFAULT FALSE,
    "displayBanner" BOOLEAN NOT NULL DEFAULT TRUE,
    "bannerText" TEXT,
    "bannerColor" TEXT,
    "maxRedemptions" INTEGER,
    "currentRedemptions" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "discount_campaigns_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id"),
    CONSTRAINT "discount_campaigns_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id")
);

-- LearningPathProgress -> learning_path_progress
CREATE TABLE IF NOT EXISTS "learning_path_progress" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "learningPathId" TEXT NOT NULL,
    "enrolledAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "progressPercent" INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT "learning_path_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "learning_path_progress_learningPathId_fkey" FOREIGN KEY ("learningPathId") REFERENCES "learning_paths" ("id") NOT NULL
);

-- CapstoneEnrollment -> capstone_enrollments
CREATE TABLE IF NOT EXISTS "capstone_enrollments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "difficultyCapstoneId" TEXT,
    "professionalCapstoneId" TEXT,
    "progressPercent" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT "not_started",
    "submittedAt" TIMESTAMP(3),
    "grade" INTEGER,
    "feedback" TEXT,
    "certificateId" TEXT,
    "enrolledAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "capstone_enrollments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "capstone_enrollments_difficultyCapstoneId_fkey" FOREIGN KEY ("difficultyCapstoneId") REFERENCES "difficulty_level_caps" ("id"),
    CONSTRAINT "capstone_enrollments_professionalCapstoneId_fkey" FOREIGN KEY ("professionalCapstoneId") REFERENCES "professional_caps" ("id")
);

-- SponsorStudent -> sponsor_students
CREATE TABLE IF NOT EXISTS "sponsor_students" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "sponsorId" TEXT NOT NULL,
    "studentEmail" TEXT NOT NULL,
    "studentName" TEXT,
    "studentId" TEXT,
    "scholarshipId" TEXT,
    "applicationId" TEXT,
    "awardId" TEXT,
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "amount" DECIMAL(10,2),
    "currency" TEXT NOT NULL DEFAULT "USD",
    "progressReport" TEXT,
    "lastReportDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "sponsor_students_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id") NOT NULL
);

-- Scholarship -> scholarships
CREATE TABLE IF NOT EXISTS "scholarships" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "shortName" TEXT,
    "slug" TEXT NOT NULL UNIQUE,
    "type" "ScholarshipType" NOT NULL,
    "description" TEXT,
    "objectives" TEXT,
    "eligibility" TEXT,
    "benefits" TEXT,
    "coverage" TEXT,
    "awardAmount" DECIMAL(10,2) DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "availableSlots" INTEGER DEFAULT 0,
    "openingDate" TIMESTAMP(3),
    "closingDate" TIMESTAMP(3),
    "applicationDeadline" TIMESTAMP(3),
    "selectionMethod" TEXT,
    "status" "ScholarshipStatus" NOT NULL,
    "visibility" TEXT NOT NULL DEFAULT "PUBLIC",
    "isFeatured" BOOLEAN NOT NULL DEFAULT FALSE,
    "bannerUrl" TEXT,
    "thumbnailUrl" TEXT,
    "color" TEXT,
    "icon" TEXT,
    "seoTitle" TEXT,
    "seoDescription" TEXT,
    "seoKeywords" TEXT,
    "config" JSONB,
    "benefitsConfig" JSONB,
    "autoEnroll" BOOLEAN NOT NULL DEFAULT FALSE,
    "createAccount" BOOLEAN NOT NULL DEFAULT TRUE,
    "assignMembership" BOOLEAN NOT NULL DEFAULT FALSE,
    "assignDomain" BOOLEAN NOT NULL DEFAULT FALSE,
    "assignCategory" BOOLEAN NOT NULL DEFAULT FALSE,
    "assignCourse" BOOLEAN NOT NULL DEFAULT FALSE,
    "waiverFees" BOOLEAN NOT NULL DEFAULT FALSE,
    "requireInterview" BOOLEAN NOT NULL DEFAULT FALSE,
    "scoringRubricId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "publishedAt" TIMESTAMP(3),
    "closedAt" TIMESTAMP(3),
    "sponsorId" TEXT,
    "viewCount" INTEGER NOT NULL DEFAULT 0,
    "applicationCount" INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT "scholarships_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id")
);

-- SponsorReport -> sponsor_reports
CREATE TABLE IF NOT EXISTS "sponsor_reports" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "sponsorId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "data" JSONB,
    "fileUrl" TEXT,
    "period" TEXT,
    "periodStart" TIMESTAMP(3),
    "periodEnd" TIMESTAMP(3),
    "sentAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "sponsor_reports_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id") NOT NULL
);

-- UserRole -> user_roles
CREATE TABLE IF NOT EXISTS "user_roles" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles" ("id") NOT NULL
);

-- RolePermission -> role_permissions
CREATE TABLE IF NOT EXISTS "role_permissions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "roleId" TEXT NOT NULL,
    "permissionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles" ("id") NOT NULL,
    CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions" ("id") NOT NULL
);

-- PolicyRule -> policy_rules
CREATE TABLE IF NOT EXISTS "policy_rules" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "policyId" TEXT NOT NULL,
    "ruleType" TEXT NOT NULL,
    "field" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "policy_rules_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies" ("id") NOT NULL
);

-- UserPolicy -> user_policies
CREATE TABLE IF NOT EXISTS "user_policies" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "policyId" TEXT NOT NULL,
    "scopeId" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "user_policies_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "user_policies_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies" ("id") NOT NULL
);

-- TicketComment -> ticket_comments
CREATE TABLE IF NOT EXISTS "ticket_comments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "ticketId" TEXT NOT NULL,
    "userId" TEXT,
    "message" TEXT NOT NULL,
    "isInternal" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "ticket_comments_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "support_tickets" ("id") NOT NULL,
    CONSTRAINT "ticket_comments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id")
);

-- ForumReply -> forum_replies
CREATE TABLE IF NOT EXISTS "forum_replies" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "content" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "threadId" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "isAccepted" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "forum_replies_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "forum_replies_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "forum_threads" ("id") NOT NULL
);

-- DomainIssuedCert -> domain_issued_certs
CREATE TABLE IF NOT EXISTS "domain_issued_certs" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "domainCertificateId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "certificateCode" TEXT NOT NULL UNIQUE,
    "qrCode" TEXT,
    "pdfUrl" TEXT,
    "verificationUrl" TEXT NOT NULL,
    "templateSnapshot" JSONB,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "revokeReason" TEXT,
    "ceoSignature" TEXT,
    "academicDirectorSignature" TEXT,
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    CONSTRAINT "domain_issued_certs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "domain_issued_certs_domainCertificateId_fkey" FOREIGN KEY ("domainCertificateId") REFERENCES "domain_certificates" ("id") NOT NULL
);

-- CategoryPurchase -> category_purchases
CREATE TABLE IF NOT EXISTS "category_purchases" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "planId" TEXT,
    "categoryId" TEXT NOT NULL,
    "categoryName" TEXT NOT NULL,
    "domainId" TEXT,
    "domainName" TEXT,
    "amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT "USD",
    "paymentId" TEXT,
    "status" TEXT NOT NULL DEFAULT "active",
    "purchasedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "refundedAt" TIMESTAMP(3),
    "refundReason" TEXT,
    "couponId" TEXT,
    "couponCode" TEXT,
    "discountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "invoiceId" TEXT,
    "paystackRef" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "category_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "category_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id"),
    CONSTRAINT "category_purchases_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") NOT NULL
);

-- Course -> courses
CREATE TABLE IF NOT EXISTS "courses" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL UNIQUE,
    "categoryId" TEXT,
    "subcategory" TEXT,
    "shortDescription" TEXT,
    "fullDescription" TEXT,
    "learningOutcomes" TEXT,
    "prerequisites" TEXT,
    "targetAudience" TEXT,
    "difficultyLevel" TEXT,
    "language" TEXT NOT NULL DEFAULT "English",
    "durationHours" INTEGER,
    "thumbnailUrl" TEXT,
    "promoVideoUrl" TEXT,
    "introVideoUrl" TEXT,
    "price" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "pricing" JSONB,
    "isFree" BOOLEAN NOT NULL DEFAULT TRUE,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "status" TEXT NOT NULL DEFAULT "draft",
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "certificateTemplateId" TEXT,
    "certificateTemplateUrl" TEXT,
    "instructorId" TEXT,
    "whatYouWillLearn" JSONB,
    "requirements" JSONB,
    CONSTRAINT "courses_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id"),
    CONSTRAINT "courses_instructorId_fkey" FOREIGN KEY ("instructorId") REFERENCES "instructors" ("id"),
    CONSTRAINT "courses_certificateTemplateId_fkey" FOREIGN KEY ("certificateTemplateId") REFERENCES "certificate_templates" ("id")
);

-- CategoryAssignment -> category_assignments
CREATE TABLE IF NOT EXISTS "category_assignments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT "CATEGORY_LEAD",
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "category_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "category_assignments_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") NOT NULL
);

-- CategoryCertificate -> category_certificates
CREATE TABLE IF NOT EXISTS "category_certificates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "categoryId" TEXT NOT NULL,
    "certificateName" TEXT NOT NULL,
    "description" TEXT,
    "requirements" JSONB,
    "templateData" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "category_certificates_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") NOT NULL
);

-- ScholarshipApplication -> scholarship_applications
CREATE TABLE IF NOT EXISTS "scholarship_applications" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "applicationNumber" TEXT NOT NULL UNIQUE,
    "trackingNumber" TEXT NOT NULL UNIQUE,
    "scholarshipId" TEXT NOT NULL,
    "status" "ApplicationStatus" NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "nationality" TEXT,
    "state" TEXT,
    "country" TEXT,
    "gender" TEXT,
    "dateOfBirth" TIMESTAMP(3),
    "highestDegree" TEXT,
    "institution" TEXT,
    "fieldOfStudy" TEXT,
    "graduationYear" INTEGER,
    "gpa" DECIMAL(10,2),
    "employmentStatus" TEXT,
    "currentEmployer" TEXT,
    "yearsExperience" INTEGER,
    "linkedIn" TEXT,
    "github" TEXT,
    "googleScholar" TEXT,
    "orcid" TEXT,
    "website" TEXT,
    "emergencyName" TEXT,
    "emergencyPhone" TEXT,
    "emergencyRelation" TEXT,
    "statementOfPurpose" TEXT,
    "motivationLetter" TEXT,
    "financialNeedStatement" TEXT,
    "researchInterests" JSONB,
    "customResponses" JSONB,
    "documents" JSONB,
    "cvUrl" TEXT,
    "transcriptUrl" TEXT,
    "recommendationLetters" JSONB,
    "nationalIdType" TEXT,
    "nationalIdUrl" TEXT,
    "interviewDate" TIMESTAMP(3),
    "interviewNotes" TEXT,
    "interviewScore" INTEGER,
    "totalScore" DECIMAL(10,2) DEFAULT 0,
    "recommendation" TEXT,
    "reviewerNotes" TEXT,
    "decisionDate" TIMESTAMP(3),
    "decisionBy" TEXT,
    "decisionNotes" TEXT,
    "awardId" TEXT,
    "userId" TEXT,
    "accountCreated" BOOLEAN NOT NULL DEFAULT FALSE,
    "isDraft" BOOLEAN NOT NULL DEFAULT TRUE,
    "lastSavedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "submittedAt" TIMESTAMP(3),
    CONSTRAINT "scholarship_applications_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL
);

-- ScholarshipDifficulty -> scholarship_difficulties
CREATE TABLE IF NOT EXISTS "scholarship_difficulties" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "difficultyLevel" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_difficulties_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL
);

-- ScholarshipCertificate -> scholarship_certificates
CREATE TABLE IF NOT EXISTS "scholarship_certificates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "certificateId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_certificates_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL,
    CONSTRAINT "scholarship_certificates_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificate_templates" ("id") NOT NULL
);

-- ScholarshipCustomQuestion -> scholarship_custom_questions
CREATE TABLE IF NOT EXISTS "scholarship_custom_questions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "questionType" TEXT NOT NULL DEFAULT "TEXT",
    "options" JSONB,
    "isRequired" BOOLEAN NOT NULL DEFAULT TRUE,
    "order" INTEGER NOT NULL DEFAULT 0,
    "validation" JSONB,
    "helpText" TEXT,
    "placeholder" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_custom_questions_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL
);

-- ScholarshipPlan -> scholarship_plans
CREATE TABLE IF NOT EXISTS "scholarship_plans" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "duration" INTEGER DEFAULT 365,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_plans_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL,
    CONSTRAINT "scholarship_plans_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") NOT NULL
);

-- ScholarshipDomain -> scholarship_domains
CREATE TABLE IF NOT EXISTS "scholarship_domains" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_domains_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL,
    CONSTRAINT "scholarship_domains_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") NOT NULL
);

-- ScholarshipCategory -> scholarship_categories
CREATE TABLE IF NOT EXISTS "scholarship_categories" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_categories_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL,
    CONSTRAINT "scholarship_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") NOT NULL
);

-- ScholarshipReviewer -> scholarship_reviewers
CREATE TABLE IF NOT EXISTS "scholarship_reviewers" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "scholarshipId" TEXT NOT NULL,
    "reviewerId" TEXT,
    "reviewerEmail" TEXT NOT NULL,
    "reviewerName" TEXT,
    "canApprove" BOOLEAN NOT NULL DEFAULT FALSE,
    "canReject" BOOLEAN NOT NULL DEFAULT FALSE,
    "canScheduleInterview" BOOLEAN NOT NULL DEFAULT FALSE,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "assignedCount" INTEGER NOT NULL DEFAULT 0,
    "reviewedCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "scholarship_reviewers_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") NOT NULL
);

-- LearningPathCourse -> learning_path_courses
CREATE TABLE IF NOT EXISTS "learning_path_courses" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "learningPathId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "isRequired" BOOLEAN NOT NULL DEFAULT TRUE,
    "stepTitle" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "learning_path_courses_learningPathId_fkey" FOREIGN KEY ("learningPathId") REFERENCES "learning_paths" ("id") NOT NULL,
    CONSTRAINT "learning_path_courses_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseObjective -> course_objectives
CREATE TABLE IF NOT EXISTS "course_objectives" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "objective" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_objectives_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseAssignment -> course_assignments
CREATE TABLE IF NOT EXISTS "course_assignments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT "INSTRUCTOR",
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "course_assignments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseLearningOutcome -> course_learning_outcomes
CREATE TABLE IF NOT EXISTS "course_learning_outcomes" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "outcome" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_learning_outcomes_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- Module -> modules
CREATE TABLE IF NOT EXISTS "modules" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "modules_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseSEO -> course_seo
CREATE TABLE IF NOT EXISTS "course_seo" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL UNIQUE,
    "metaTitle" TEXT,
    "metaDescription" TEXT,
    "ogImage" TEXT,
    "canonicalUrl" TEXT,
    "noIndex" BOOLEAN NOT NULL DEFAULT FALSE,
    "noFollow" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_seo_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseSoftware -> course_software
CREATE TABLE IF NOT EXISTS "course_software" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "version" TEXT,
    "url" TEXT,
    "description" TEXT,
    "isRequired" BOOLEAN NOT NULL DEFAULT TRUE,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_software_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseResource -> course_resources
CREATE TABLE IF NOT EXISTS "course_resources" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "fileType" TEXT,
    "fileSize" INTEGER,
    "isDownloadable" BOOLEAN NOT NULL DEFAULT TRUE,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_resources_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- MiniProject -> mini_projects
CREATE TABLE IF NOT EXISTS "mini_projects" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "scenario" TEXT,
    "workflow" TEXT,
    "deliverables" JSONB,
    "evaluationRubric" JSONB,
    "starterFilesUrl" TEXT,
    "solutionFilesUrl" TEXT,
    "maxScore" INTEGER NOT NULL DEFAULT 100,
    "passingScore" INTEGER NOT NULL DEFAULT 70,
    "isRequired" BOOLEAN NOT NULL DEFAULT FALSE,
    "dueDaysAfterStart" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "mini_projects_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- Certificate -> certificates
CREATE TABLE IF NOT EXISTS "certificates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "certificateUrl" TEXT,
    "pdfUrl" TEXT,
    "verificationUrl" TEXT,
    "verificationCode" TEXT NOT NULL UNIQUE,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    CONSTRAINT "certificates_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "certificates_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseDataset -> course_datasets
CREATE TABLE IF NOT EXISTS "course_datasets" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "sourceUrl" TEXT,
    "fileUrl" TEXT,
    "fileType" TEXT,
    "fileSize" INTEGER,
    "isDownloadable" BOOLEAN NOT NULL DEFAULT FALSE,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_datasets_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- Enrollment -> enrollments
CREATE TABLE IF NOT EXISTS "enrollments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "progressPercent" INTEGER NOT NULL DEFAULT 0,
    "completed" BOOLEAN NOT NULL DEFAULT FALSE,
    "enrolledAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    CONSTRAINT "enrollments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "enrollments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- Prerequisite -> prerequisites
CREATE TABLE IF NOT EXISTS "prerequisites" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL DEFAULT "course",
    "externalUrl" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "prerequisites_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CareerOutcome -> career_outcomes
CREATE TABLE IF NOT EXISTS "career_outcomes" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "career_outcomes_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CourseVersion -> course_versions
CREATE TABLE IF NOT EXISTS "course_versions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "changes" TEXT,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "course_versions_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- IssuedCertificate -> issued_certificates
CREATE TABLE IF NOT EXISTS "issued_certificates" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "certificateId" TEXT NOT NULL UNIQUE,
    "studentId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "certificateCode" TEXT NOT NULL UNIQUE,
    "pdfUrl" TEXT,
    "verificationUrl" TEXT NOT NULL,
    "templateSnapshot" JSONB,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "revokeReason" TEXT,
    CONSTRAINT "issued_certificates_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "issued_certificates_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- Wishlist -> wishlists
CREATE TABLE IF NOT EXISTS "wishlists" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "addedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "wishlists_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "wishlists_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL
);

-- CategoryIssuedCert -> category_issued_certs
CREATE TABLE IF NOT EXISTS "category_issued_certs" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "categoryCertificateId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "certificateCode" TEXT NOT NULL UNIQUE,
    "qrCode" TEXT,
    "pdfUrl" TEXT,
    "verificationUrl" TEXT NOT NULL,
    "templateSnapshot" JSONB,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "revokeReason" TEXT,
    "ceoSignature" TEXT,
    "academicDirectorSignature" TEXT,
    "officialSeal" TEXT,
    "status" TEXT NOT NULL DEFAULT "ACTIVE",
    CONSTRAINT "category_issued_certs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "category_issued_certs_categoryCertificateId_fkey" FOREIGN KEY ("categoryCertificateId") REFERENCES "category_certificates" ("id") NOT NULL
);

-- ApplicationReview -> application_reviews
CREATE TABLE IF NOT EXISTS "application_reviews" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "applicationId" TEXT NOT NULL,
    "reviewerId" TEXT,
    "reviewerEmail" TEXT,
    "scores" JSONB,
    "totalScore" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "evaluation" TEXT,
    "strengths" TEXT,
    "weaknesses" TEXT,
    "recommendation" TEXT,
    "confidenceLevel" TEXT,
    "status" "ReviewStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    CONSTRAINT "application_reviews_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "scholarship_applications" ("id") NOT NULL
);

-- ApplicationNotification -> application_notifications
CREATE TABLE IF NOT EXISTS "application_notifications" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "applicationId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "channel" TEXT NOT NULL DEFAULT "EMAIL",
    "sentAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "application_notifications_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "scholarship_applications" ("id") NOT NULL
);

-- ApplicationStatusHistory -> application_status_history
CREATE TABLE IF NOT EXISTS "application_status_history" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "applicationId" TEXT NOT NULL,
    "previousStatus" TEXT,
    "newStatus" TEXT NOT NULL,
    "changedBy" TEXT,
    "changedByName" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "application_status_history_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "scholarship_applications" ("id") NOT NULL
);

-- ScholarshipAward -> scholarship_awards
CREATE TABLE IF NOT EXISTS "scholarship_awards" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "awardNumber" TEXT NOT NULL UNIQUE,
    "applicationId" TEXT UNIQUE,
    "scholarshipId" TEXT NOT NULL,
    "recipientName" TEXT NOT NULL,
    "recipientEmail" TEXT NOT NULL,
    "userId" TEXT,
    "amount" DECIMAL(10,2),
    "currency" TEXT NOT NULL DEFAULT "USD",
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "benefits" JSONB,
    "status" "AwardStatus" NOT NULL,
    "acceptanceDeadline" TIMESTAMP(3),
    "acceptedAt" TIMESTAMP(3),
    "declinedAt" TIMESTAMP(3),
    "awardLetterUrl" TEXT,
    "certificateUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "issuedAt" TIMESTAMP(3),
    CONSTRAINT "scholarship_awards_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "scholarship_applications" ("id")
);

-- Lesson -> lessons
CREATE TABLE IF NOT EXISTS "lessons" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "courseId" TEXT NOT NULL,
    "moduleId" TEXT,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "lessonType" TEXT NOT NULL DEFAULT "video",
    "duration" INTEGER,
    "videoUrl" TEXT,
    "isPreview" BOOLEAN NOT NULL DEFAULT FALSE,
    "isFree" BOOLEAN NOT NULL DEFAULT FALSE,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isExercise" BOOLEAN NOT NULL DEFAULT FALSE,
    "exerciseDescription" TEXT,
    "exerciseFilesUrl" TEXT,
    "solutionVideoUrl" TEXT,
    CONSTRAINT "lessons_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL,
    CONSTRAINT "lessons_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES "modules" ("id")
);

-- ProjectSubmission -> project_submissions
CREATE TABLE IF NOT EXISTS "project_submissions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT,
    "miniProjectId" TEXT,
    "capstoneId" TEXT,
    "capstoneType" TEXT,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "submissionUrl" TEXT,
    "fileUrls" JSONB,
    "screenshots" JSONB,
    "status" TEXT NOT NULL DEFAULT "DRAFT",
    "isLocked" BOOLEAN NOT NULL DEFAULT FALSE,
    "isDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
    "projectType" TEXT NOT NULL DEFAULT "MINI_PROJECT",
    "grade" INTEGER,
    "gradeType" TEXT,
    "rubricId" TEXT,
    "rubricScore" DECIMAL(10,2) DEFAULT 0,
    "maxScore" DECIMAL(10,2) DEFAULT 100,
    "feedback" TEXT,
    "submittedAt" TIMESTAMP(3),
    "gradedAt" TIMESTAMP(3),
    "isFromMCCS" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_submissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "project_submissions_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id"),
    CONSTRAINT "project_submissions_miniProjectId_fkey" FOREIGN KEY ("miniProjectId") REFERENCES "mini_projects" ("id")
);

-- ScholarshipEnrollment -> scholarship_enrollments
CREATE TABLE IF NOT EXISTS "scholarship_enrollments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "awardId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "membershipId" TEXT,
    "domainId" TEXT,
    "categoryId" TEXT,
    "courseId" TEXT,
    "planId" TEXT,
    "certificateId" TEXT,
    "status" TEXT NOT NULL DEFAULT "PENDING",
    "durationDays" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "activatedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    CONSTRAINT "scholarship_enrollments_awardId_fkey" FOREIGN KEY ("awardId") REFERENCES "scholarship_awards" ("id") NOT NULL
);

-- UserLectureProgress -> user_lecture_progress
CREATE TABLE IF NOT EXISTS "user_lecture_progress" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "lessonId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT FALSE,
    "completedAt" TIMESTAMP(3),
    "watchTime" INTEGER NOT NULL DEFAULT 0,
    "lastPosition" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "user_lecture_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "user_lecture_progress_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") NOT NULL
);

-- PracticalExercise -> practical_exercises
CREATE TABLE IF NOT EXISTS "practical_exercises" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "lessonId" TEXT NOT NULL UNIQUE,
    "instructions" TEXT,
    "starterCode" TEXT,
    "solutionCode" TEXT,
    "hints" JSONB,
    "rubric" JSONB,
    "maxScore" INTEGER NOT NULL DEFAULT 100,
    "passingScore" INTEGER NOT NULL DEFAULT 70,
    "timeLimit" INTEGER,
    "isRequired" BOOLEAN NOT NULL DEFAULT FALSE,
    "allowRetry" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "practical_exercises_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") NOT NULL
);

-- Video -> videos
CREATE TABLE IF NOT EXISTS "videos" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "lessonId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "videoUrl" TEXT NOT NULL,
    "duration" INTEGER,
    "provider" TEXT,
    "storageType" TEXT,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "videos_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") NOT NULL
);

-- Material -> materials
CREATE TABLE IF NOT EXISTS "materials" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "lessonId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" TEXT,
    "fileUrl" TEXT NOT NULL,
    "visibility" TEXT NOT NULL DEFAULT "public",
    "downloadAllowed" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "materials_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") NOT NULL
);

-- LearningProgress -> learning_progress
CREATE TABLE IF NOT EXISTS "learning_progress" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "lessonId" TEXT NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT FALSE,
    "watchTime" INTEGER NOT NULL DEFAULT 0,
    "completedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "learning_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "learning_progress_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") NOT NULL,
    CONSTRAINT "learning_progress_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") NOT NULL
);

-- SubmissionVersion -> submission_versions
CREATE TABLE IF NOT EXISTS "submission_versions" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "submissionId" TEXT NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "submissionUrl" TEXT,
    "demoUrl" TEXT,
    "reportUrl" TEXT,
    "videoUrl" TEXT,
    "fileUrls" JSONB,
    "screenshots" JSONB,
    "additionalLinks" JSONB,
    "notes" TEXT,
    "isLatest" BOOLEAN NOT NULL DEFAULT FALSE,
    "submittedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "submission_versions_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "project_submissions" ("id") NOT NULL
);

-- ProjectReview -> project_reviews
CREATE TABLE IF NOT EXISTS "project_reviews" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "submissionId" TEXT NOT NULL,
    "versionId" TEXT,
    "reviewerId" TEXT NOT NULL,
    "decision" TEXT NOT NULL,
    "overallFeedback" TEXT,
    "reviewedAt" TIMESTAMP(3) NOT NULL,
    "isLatest" BOOLEAN NOT NULL DEFAULT TRUE,
    "timeSpentMinutes" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_reviews_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "project_submissions" ("id") NOT NULL,
    CONSTRAINT "project_reviews_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "users" ("id") NOT NULL
);

-- ProjectStatusHistory -> project_status_history
CREATE TABLE IF NOT EXISTS "project_status_history" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "submissionId" TEXT NOT NULL,
    "previousStatus" TEXT,
    "newStatus" TEXT NOT NULL,
    "changedBy" TEXT NOT NULL,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_status_history_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "project_submissions" ("id") NOT NULL
);

-- ReviewerAssignment -> reviewer_assignments
CREATE TABLE IF NOT EXISTS "reviewer_assignments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "submissionId" TEXT NOT NULL,
    "reviewerId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL,
    "assignedBy" TEXT,
    "dueDate" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT "PENDING",
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "reviewer_assignments_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "project_submissions" ("id") NOT NULL,
    CONSTRAINT "reviewer_assignments_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "users" ("id") NOT NULL
);

-- ProjectFeedback -> project_feedback
CREATE TABLE IF NOT EXISTS "project_feedback" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "reviewId" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "title" TEXT,
    "content" TEXT NOT NULL,
    "recommendation" TEXT,
    "referenceType" TEXT,
    "referenceId" TEXT,
    "referenceDetail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_feedback_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES "project_reviews" ("id") NOT NULL
);

-- ProjectScore -> project_scores
CREATE TABLE IF NOT EXISTS "project_scores" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "reviewId" TEXT NOT NULL,
    "rubricId" TEXT NOT NULL,
    "criteriaName" TEXT NOT NULL,
    "pointsAwarded" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "maxPoints" DECIMAL(10,2) NOT NULL,
    "feedback" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_scores_rubricId_fkey" FOREIGN KEY ("rubricId") REFERENCES "project_rubrics" ("id") NOT NULL,
    CONSTRAINT "project_scores_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES "project_reviews" ("id") NOT NULL
);

-- ProjectComment -> project_comments
CREATE TABLE IF NOT EXISTS "project_comments" (
    "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
    "submissionId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "isInternal" BOOLEAN NOT NULL DEFAULT FALSE,
    "referenceType" TEXT,
    "referenceId" TEXT,
    "parentId" TEXT,
    "isResolved" BOOLEAN NOT NULL DEFAULT FALSE,
    "resolvedBy" TEXT,
    "resolvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "project_comments_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "project_submissions" ("id") NOT NULL,
    CONSTRAINT "project_comments_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "users" ("id") NOT NULL,
    CONSTRAINT "project_comments_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "project_comments" ("id")
);


-- ============================================
-- PHASE 3: INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS "domains_slug_idx" ON "domains" ("slug");
CREATE INDEX IF NOT EXISTS "domains_status_idx" ON "domains" ("status");
CREATE INDEX IF NOT EXISTS "domains_visibility_idx" ON "domains" ("visibility");
CREATE INDEX IF NOT EXISTS "domains_isFeatured_idx" ON "domains" ("isFeatured");
CREATE INDEX IF NOT EXISTS "coupons_code_idx" ON "coupons" ("code");
CREATE INDEX IF NOT EXISTS "coupons_isActive_idx" ON "coupons" ("isActive");
CREATE INDEX IF NOT EXISTS "difficulty_level_caps_difficultyLevel_idx" ON "difficulty_level_caps" ("difficultyLevel");
CREATE INDEX IF NOT EXISTS "difficulty_level_caps_isPublished_idx" ON "difficulty_level_caps" ("isPublished");
CREATE INDEX IF NOT EXISTS "professional_caps_categoryId_idx" ON "professional_caps" ("categoryId");
CREATE INDEX IF NOT EXISTS "professional_caps_isPublished_idx" ON "professional_caps" ("isPublished");
CREATE INDEX IF NOT EXISTS "sponsors_slug_idx" ON "sponsors" ("slug");
CREATE INDEX IF NOT EXISTS "sponsors_status_idx" ON "sponsors" ("status");
CREATE INDEX IF NOT EXISTS "sponsors_type_idx" ON "sponsors" ("type");
CREATE INDEX IF NOT EXISTS "scholarship_analytics_date_idx" ON "scholarship_analytics" ("date");
CREATE INDEX IF NOT EXISTS "profiles_userId_idx" ON "profiles" ("userId");
CREATE INDEX IF NOT EXISTS "portfolio_entries_userId_idx" ON "portfolio_entries" ("userId");
CREATE INDEX IF NOT EXISTS "portfolio_entries_visibility_idx" ON "portfolio_entries" ("visibility");
CREATE INDEX IF NOT EXISTS "portfolio_entries_publicSlug_idx" ON "portfolio_entries" ("publicSlug");
CREATE INDEX IF NOT EXISTS "portfolio_entries_userId_idx" ON "portfolio_entries" ("userId");
CREATE INDEX IF NOT EXISTS "support_tickets_status_idx" ON "support_tickets" ("status");
CREATE INDEX IF NOT EXISTS "support_tickets_priority_idx" ON "support_tickets" ("priority");
CREATE INDEX IF NOT EXISTS "support_tickets_createdAt_idx" ON "support_tickets" ("createdAt");
CREATE INDEX IF NOT EXISTS "support_tickets_userId_idx" ON "support_tickets" ("userId");
CREATE INDEX IF NOT EXISTS "support_tickets_assignedTo_idx" ON "support_tickets" ("assignedTo");
CREATE INDEX IF NOT EXISTS "support_tickets_userId_idx" ON "support_tickets" ("userId");
CREATE INDEX IF NOT EXISTS "instructors_userId_idx" ON "instructors" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_progress_userId_idx" ON "certificate_progress" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_progress_categoryCertificateId_idx" ON "certificate_progress" ("categoryCertificateId");
CREATE INDEX IF NOT EXISTS "certificate_progress_domainCertificateId_idx" ON "certificate_progress" ("domainCertificateId");
CREATE INDEX IF NOT EXISTS "certificate_progress_userId_idx" ON "certificate_progress" ("userId");
CREATE INDEX IF NOT EXISTS "notifications_userId_idx" ON "notifications" ("userId");
CREATE INDEX IF NOT EXISTS "access_licenses_userId_idx" ON "access_licenses" ("userId");
CREATE INDEX IF NOT EXISTS "access_licenses_licenseType_targetId_idx" ON "access_licenses" ("licenseType", "targetId");
CREATE INDEX IF NOT EXISTS "access_licenses_status_idx" ON "access_licenses" ("status");
CREATE INDEX IF NOT EXISTS "access_licenses_userId_idx" ON "access_licenses" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_userId_idx" ON "certificate_eligibility" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_certificateType_certificateId_idx" ON "certificate_eligibility" ("certificateType", "certificateId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_isEligible_idx" ON "certificate_eligibility" ("isEligible");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_userId_idx" ON "certificate_eligibility" ("userId");
CREATE INDEX IF NOT EXISTS "forum_threads_category_idx" ON "forum_threads" ("category");
CREATE INDEX IF NOT EXISTS "forum_threads_authorId_idx" ON "forum_threads" ("authorId");
CREATE INDEX IF NOT EXISTS "forum_threads_createdAt_idx" ON "forum_threads" ("createdAt");
CREATE INDEX IF NOT EXISTS "forum_threads_isPinned_idx" ON "forum_threads" ("isPinned");
CREATE INDEX IF NOT EXISTS "forum_threads_authorId_idx" ON "forum_threads" ("authorId");
CREATE INDEX IF NOT EXISTS "portal_assignments_userId_idx" ON "portal_assignments" ("userId");
CREATE INDEX IF NOT EXISTS "invoices_userId_idx" ON "invoices" ("userId");
CREATE INDEX IF NOT EXISTS "invoices_status_idx" ON "invoices" ("status");
CREATE INDEX IF NOT EXISTS "invoices_invoiceNumber_idx" ON "invoices" ("invoiceNumber");
CREATE INDEX IF NOT EXISTS "invoices_userId_idx" ON "invoices" ("userId");
CREATE INDEX IF NOT EXISTS "payments_userId_idx" ON "payments" ("userId");
CREATE INDEX IF NOT EXISTS "payments_paystackRef_idx" ON "payments" ("paystackRef");
CREATE INDEX IF NOT EXISTS "payments_status_idx" ON "payments" ("status");
CREATE INDEX IF NOT EXISTS "payments_type_idx" ON "payments" ("type");
CREATE INDEX IF NOT EXISTS "payments_userId_idx" ON "payments" ("userId");
CREATE INDEX IF NOT EXISTS "domain_certificates_domainId_idx" ON "domain_certificates" ("domainId");
CREATE INDEX IF NOT EXISTS "domain_certificates_domainId_idx" ON "domain_certificates" ("domainId");
CREATE INDEX IF NOT EXISTS "categories_domainId_idx" ON "categories" ("domainId");
CREATE INDEX IF NOT EXISTS "categories_slug_idx" ON "categories" ("slug");
CREATE INDEX IF NOT EXISTS "categories_isActive_idx" ON "categories" ("isActive");
CREATE INDEX IF NOT EXISTS "categories_domainId_idx" ON "categories" ("domainId");
CREATE INDEX IF NOT EXISTS "domain_assignments_userId_idx" ON "domain_assignments" ("userId");
CREATE INDEX IF NOT EXISTS "domain_assignments_domainId_idx" ON "domain_assignments" ("domainId");
CREATE INDEX IF NOT EXISTS "academy_purchases_userId_idx" ON "academy_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "academy_purchases_status_idx" ON "academy_purchases" ("status");
CREATE INDEX IF NOT EXISTS "academy_purchases_userId_idx" ON "academy_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "academy_purchases_planId_idx" ON "academy_purchases" ("planId");
CREATE INDEX IF NOT EXISTS "domain_purchases_userId_idx" ON "domain_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "domain_purchases_domainId_idx" ON "domain_purchases" ("domainId");
CREATE INDEX IF NOT EXISTS "domain_purchases_status_idx" ON "domain_purchases" ("status");
CREATE INDEX IF NOT EXISTS "domain_purchases_userId_idx" ON "domain_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "domain_purchases_planId_idx" ON "domain_purchases" ("planId");
CREATE INDEX IF NOT EXISTS "domain_purchases_domainId_idx" ON "domain_purchases" ("domainId");
CREATE INDEX IF NOT EXISTS "subscriptions_userId_idx" ON "subscriptions" ("userId");
CREATE INDEX IF NOT EXISTS "subscriptions_planId_idx" ON "subscriptions" ("planId");
CREATE INDEX IF NOT EXISTS "gateway_configurations_gatewayId_idx" ON "gateway_configurations" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_transactions_userId_idx" ON "payment_transactions" ("userId");
CREATE INDEX IF NOT EXISTS "payment_transactions_gatewayId_idx" ON "payment_transactions" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_transactions_status_idx" ON "payment_transactions" ("status");
CREATE INDEX IF NOT EXISTS "payment_transactions_createdAt_idx" ON "payment_transactions" ("createdAt");
CREATE INDEX IF NOT EXISTS "payment_transactions_gatewayId_idx" ON "payment_transactions" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_gatewayId_idx" ON "payment_gateway_logs" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_transactionId_idx" ON "payment_gateway_logs" ("transactionId");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_logType_idx" ON "payment_gateway_logs" ("logType");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_createdAt_idx" ON "payment_gateway_logs" ("createdAt");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_gatewayId_idx" ON "payment_gateway_logs" ("gatewayId");
CREATE INDEX IF NOT EXISTS "discount_campaigns_isActive_idx" ON "discount_campaigns" ("isActive");
CREATE INDEX IF NOT EXISTS "discount_campaigns_startsAt_endsAt_idx" ON "discount_campaigns" ("startsAt", "endsAt");
CREATE INDEX IF NOT EXISTS "discount_campaigns_planId_idx" ON "discount_campaigns" ("planId");
CREATE INDEX IF NOT EXISTS "discount_campaigns_couponId_idx" ON "discount_campaigns" ("couponId");
CREATE INDEX IF NOT EXISTS "learning_path_progress_userId_idx" ON "learning_path_progress" ("userId");
CREATE INDEX IF NOT EXISTS "learning_path_progress_learningPathId_idx" ON "learning_path_progress" ("learningPathId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_userId_idx" ON "capstone_enrollments" ("userId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_difficultyCapstoneId_idx" ON "capstone_enrollments" ("difficultyCapstoneId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_professionalCapstoneId_idx" ON "capstone_enrollments" ("professionalCapstoneId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_userId_idx" ON "capstone_enrollments" ("userId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_difficultyCapstoneId_idx" ON "capstone_enrollments" ("difficultyCapstoneId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_professionalCapstoneId_idx" ON "capstone_enrollments" ("professionalCapstoneId");
CREATE INDEX IF NOT EXISTS "sponsor_students_sponsorId_idx" ON "sponsor_students" ("sponsorId");
CREATE INDEX IF NOT EXISTS "sponsor_students_studentEmail_idx" ON "sponsor_students" ("studentEmail");
CREATE INDEX IF NOT EXISTS "sponsor_students_status_idx" ON "sponsor_students" ("status");
CREATE INDEX IF NOT EXISTS "sponsor_students_sponsorId_idx" ON "sponsor_students" ("sponsorId");
CREATE INDEX IF NOT EXISTS "scholarships_slug_idx" ON "scholarships" ("slug");
CREATE INDEX IF NOT EXISTS "scholarships_status_idx" ON "scholarships" ("status");
CREATE INDEX IF NOT EXISTS "scholarships_visibility_idx" ON "scholarships" ("visibility");
CREATE INDEX IF NOT EXISTS "scholarships_type_idx" ON "scholarships" ("type");
CREATE INDEX IF NOT EXISTS "scholarships_isFeatured_idx" ON "scholarships" ("isFeatured");
CREATE INDEX IF NOT EXISTS "scholarships_sponsorId_idx" ON "scholarships" ("sponsorId");
CREATE INDEX IF NOT EXISTS "scholarships_closingDate_idx" ON "scholarships" ("closingDate");
CREATE INDEX IF NOT EXISTS "scholarships_sponsorId_idx" ON "scholarships" ("sponsorId");
CREATE INDEX IF NOT EXISTS "sponsor_reports_sponsorId_idx" ON "sponsor_reports" ("sponsorId");
CREATE INDEX IF NOT EXISTS "sponsor_reports_sentAt_idx" ON "sponsor_reports" ("sentAt");
CREATE INDEX IF NOT EXISTS "sponsor_reports_sponsorId_idx" ON "sponsor_reports" ("sponsorId");
CREATE INDEX IF NOT EXISTS "user_roles_userId_idx" ON "user_roles" ("userId");
CREATE INDEX IF NOT EXISTS "user_roles_roleId_idx" ON "user_roles" ("roleId");
CREATE INDEX IF NOT EXISTS "role_permissions_roleId_idx" ON "role_permissions" ("roleId");
CREATE INDEX IF NOT EXISTS "role_permissions_permissionId_idx" ON "role_permissions" ("permissionId");
CREATE INDEX IF NOT EXISTS "policy_rules_policyId_idx" ON "policy_rules" ("policyId");
CREATE INDEX IF NOT EXISTS "user_policies_userId_idx" ON "user_policies" ("userId");
CREATE INDEX IF NOT EXISTS "user_policies_policyId_idx" ON "user_policies" ("policyId");
CREATE INDEX IF NOT EXISTS "ticket_comments_ticketId_idx" ON "ticket_comments" ("ticketId");
CREATE INDEX IF NOT EXISTS "ticket_comments_ticketId_idx" ON "ticket_comments" ("ticketId");
CREATE INDEX IF NOT EXISTS "ticket_comments_userId_idx" ON "ticket_comments" ("userId");
CREATE INDEX IF NOT EXISTS "forum_replies_threadId_idx" ON "forum_replies" ("threadId");
CREATE INDEX IF NOT EXISTS "forum_replies_authorId_idx" ON "forum_replies" ("authorId");
CREATE INDEX IF NOT EXISTS "forum_replies_createdAt_idx" ON "forum_replies" ("createdAt");
CREATE INDEX IF NOT EXISTS "forum_replies_authorId_idx" ON "forum_replies" ("authorId");
CREATE INDEX IF NOT EXISTS "forum_replies_threadId_idx" ON "forum_replies" ("threadId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_userId_idx" ON "domain_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_domainCertificateId_idx" ON "domain_issued_certs" ("domainCertificateId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_status_idx" ON "domain_issued_certs" ("status");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_userId_idx" ON "domain_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_domainCertificateId_idx" ON "domain_issued_certs" ("domainCertificateId");
CREATE INDEX IF NOT EXISTS "category_purchases_userId_idx" ON "category_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "category_purchases_categoryId_idx" ON "category_purchases" ("categoryId");
CREATE INDEX IF NOT EXISTS "category_purchases_status_idx" ON "category_purchases" ("status");
CREATE INDEX IF NOT EXISTS "category_purchases_userId_idx" ON "category_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "category_purchases_planId_idx" ON "category_purchases" ("planId");
CREATE INDEX IF NOT EXISTS "category_purchases_categoryId_idx" ON "category_purchases" ("categoryId");
CREATE INDEX IF NOT EXISTS "courses_categoryId_idx" ON "courses" ("categoryId");
CREATE INDEX IF NOT EXISTS "courses_instructorId_idx" ON "courses" ("instructorId");
CREATE INDEX IF NOT EXISTS "courses_certificateTemplateId_idx" ON "courses" ("certificateTemplateId");
CREATE INDEX IF NOT EXISTS "category_assignments_userId_idx" ON "category_assignments" ("userId");
CREATE INDEX IF NOT EXISTS "category_assignments_categoryId_idx" ON "category_assignments" ("categoryId");
CREATE INDEX IF NOT EXISTS "category_certificates_categoryId_idx" ON "category_certificates" ("categoryId");
CREATE INDEX IF NOT EXISTS "category_certificates_categoryId_idx" ON "category_certificates" ("categoryId");
CREATE INDEX IF NOT EXISTS "scholarship_applications_applicationNumber_idx" ON "scholarship_applications" ("applicationNumber");
CREATE INDEX IF NOT EXISTS "scholarship_applications_trackingNumber_idx" ON "scholarship_applications" ("trackingNumber");
CREATE INDEX IF NOT EXISTS "scholarship_applications_scholarshipId_idx" ON "scholarship_applications" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_applications_status_idx" ON "scholarship_applications" ("status");
CREATE INDEX IF NOT EXISTS "scholarship_applications_email_idx" ON "scholarship_applications" ("email");
CREATE INDEX IF NOT EXISTS "scholarship_applications_country_idx" ON "scholarship_applications" ("country");
CREATE INDEX IF NOT EXISTS "scholarship_applications_submittedAt_idx" ON "scholarship_applications" ("submittedAt");
CREATE INDEX IF NOT EXISTS "scholarship_applications_scholarshipId_idx" ON "scholarship_applications" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_difficulties_scholarshipId_idx" ON "scholarship_difficulties" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_difficulties_scholarshipId_idx" ON "scholarship_difficulties" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_scholarshipId_idx" ON "scholarship_certificates" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_certificateId_idx" ON "scholarship_certificates" ("certificateId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_scholarshipId_idx" ON "scholarship_certificates" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_certificateId_idx" ON "scholarship_certificates" ("certificateId");
CREATE INDEX IF NOT EXISTS "scholarship_custom_questions_scholarshipId_idx" ON "scholarship_custom_questions" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_custom_questions_scholarshipId_idx" ON "scholarship_custom_questions" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_scholarshipId_idx" ON "scholarship_plans" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_planId_idx" ON "scholarship_plans" ("planId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_scholarshipId_idx" ON "scholarship_plans" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_planId_idx" ON "scholarship_plans" ("planId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_scholarshipId_idx" ON "scholarship_domains" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_domainId_idx" ON "scholarship_domains" ("domainId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_scholarshipId_idx" ON "scholarship_domains" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_domainId_idx" ON "scholarship_domains" ("domainId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_scholarshipId_idx" ON "scholarship_categories" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_categoryId_idx" ON "scholarship_categories" ("categoryId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_scholarshipId_idx" ON "scholarship_categories" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_categoryId_idx" ON "scholarship_categories" ("categoryId");
CREATE INDEX IF NOT EXISTS "scholarship_reviewers_scholarshipId_idx" ON "scholarship_reviewers" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_reviewers_reviewerId_idx" ON "scholarship_reviewers" ("reviewerId");
CREATE INDEX IF NOT EXISTS "scholarship_reviewers_scholarshipId_idx" ON "scholarship_reviewers" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "learning_path_courses_learningPathId_idx" ON "learning_path_courses" ("learningPathId");
CREATE INDEX IF NOT EXISTS "learning_path_courses_courseId_idx" ON "learning_path_courses" ("courseId");
CREATE INDEX IF NOT EXISTS "course_objectives_courseId_idx" ON "course_objectives" ("courseId");
CREATE INDEX IF NOT EXISTS "course_objectives_courseId_idx" ON "course_objectives" ("courseId");
CREATE INDEX IF NOT EXISTS "course_assignments_userId_idx" ON "course_assignments" ("userId");
CREATE INDEX IF NOT EXISTS "course_assignments_courseId_idx" ON "course_assignments" ("courseId");
CREATE INDEX IF NOT EXISTS "course_learning_outcomes_courseId_idx" ON "course_learning_outcomes" ("courseId");
CREATE INDEX IF NOT EXISTS "course_learning_outcomes_courseId_idx" ON "course_learning_outcomes" ("courseId");
CREATE INDEX IF NOT EXISTS "modules_courseId_idx" ON "modules" ("courseId");
CREATE INDEX IF NOT EXISTS "course_seo_courseId_idx" ON "course_seo" ("courseId");
CREATE INDEX IF NOT EXISTS "course_software_courseId_idx" ON "course_software" ("courseId");
CREATE INDEX IF NOT EXISTS "course_software_courseId_idx" ON "course_software" ("courseId");
CREATE INDEX IF NOT EXISTS "course_resources_courseId_idx" ON "course_resources" ("courseId");
CREATE INDEX IF NOT EXISTS "course_resources_courseId_idx" ON "course_resources" ("courseId");
CREATE INDEX IF NOT EXISTS "mini_projects_courseId_idx" ON "mini_projects" ("courseId");
CREATE INDEX IF NOT EXISTS "mini_projects_courseId_idx" ON "mini_projects" ("courseId");
CREATE INDEX IF NOT EXISTS "certificates_userId_idx" ON "certificates" ("userId");
CREATE INDEX IF NOT EXISTS "certificates_courseId_idx" ON "certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "certificates_status_idx" ON "certificates" ("status");
CREATE INDEX IF NOT EXISTS "certificates_userId_idx" ON "certificates" ("userId");
CREATE INDEX IF NOT EXISTS "certificates_courseId_idx" ON "certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "course_datasets_courseId_idx" ON "course_datasets" ("courseId");
CREATE INDEX IF NOT EXISTS "course_datasets_courseId_idx" ON "course_datasets" ("courseId");
CREATE INDEX IF NOT EXISTS "enrollments_userId_idx" ON "enrollments" ("userId");
CREATE INDEX IF NOT EXISTS "enrollments_courseId_idx" ON "enrollments" ("courseId");
CREATE INDEX IF NOT EXISTS "prerequisites_courseId_idx" ON "prerequisites" ("courseId");
CREATE INDEX IF NOT EXISTS "prerequisites_courseId_idx" ON "prerequisites" ("courseId");
CREATE INDEX IF NOT EXISTS "career_outcomes_courseId_idx" ON "career_outcomes" ("courseId");
CREATE INDEX IF NOT EXISTS "career_outcomes_courseId_idx" ON "career_outcomes" ("courseId");
CREATE INDEX IF NOT EXISTS "course_versions_courseId_idx" ON "course_versions" ("courseId");
CREATE INDEX IF NOT EXISTS "course_versions_courseId_idx" ON "course_versions" ("courseId");
CREATE INDEX IF NOT EXISTS "issued_certificates_studentId_idx" ON "issued_certificates" ("studentId");
CREATE INDEX IF NOT EXISTS "issued_certificates_courseId_idx" ON "issued_certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "issued_certificates_issuedAt_idx" ON "issued_certificates" ("issuedAt");
CREATE INDEX IF NOT EXISTS "issued_certificates_studentId_idx" ON "issued_certificates" ("studentId");
CREATE INDEX IF NOT EXISTS "issued_certificates_courseId_idx" ON "issued_certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "wishlists_userId_idx" ON "wishlists" ("userId");
CREATE INDEX IF NOT EXISTS "wishlists_courseId_idx" ON "wishlists" ("courseId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_userId_idx" ON "category_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_categoryCertificateId_idx" ON "category_issued_certs" ("categoryCertificateId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_status_idx" ON "category_issued_certs" ("status");
CREATE INDEX IF NOT EXISTS "category_issued_certs_userId_idx" ON "category_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_categoryCertificateId_idx" ON "category_issued_certs" ("categoryCertificateId");
CREATE INDEX IF NOT EXISTS "application_reviews_applicationId_idx" ON "application_reviews" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_reviews_reviewerId_idx" ON "application_reviews" ("reviewerId");
CREATE INDEX IF NOT EXISTS "application_reviews_status_idx" ON "application_reviews" ("status");
CREATE INDEX IF NOT EXISTS "application_reviews_applicationId_idx" ON "application_reviews" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_notifications_applicationId_idx" ON "application_notifications" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_notifications_type_idx" ON "application_notifications" ("type");
CREATE INDEX IF NOT EXISTS "application_notifications_createdAt_idx" ON "application_notifications" ("createdAt");
CREATE INDEX IF NOT EXISTS "application_notifications_applicationId_idx" ON "application_notifications" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_status_history_applicationId_idx" ON "application_status_history" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_status_history_createdAt_idx" ON "application_status_history" ("createdAt");
CREATE INDEX IF NOT EXISTS "application_status_history_applicationId_idx" ON "application_status_history" ("applicationId");
CREATE INDEX IF NOT EXISTS "scholarship_awards_awardNumber_idx" ON "scholarship_awards" ("awardNumber");
CREATE INDEX IF NOT EXISTS "scholarship_awards_scholarshipId_idx" ON "scholarship_awards" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_awards_recipientEmail_idx" ON "scholarship_awards" ("recipientEmail");
CREATE INDEX IF NOT EXISTS "scholarship_awards_status_idx" ON "scholarship_awards" ("status");
CREATE INDEX IF NOT EXISTS "scholarship_awards_applicationId_idx" ON "scholarship_awards" ("applicationId");
CREATE INDEX IF NOT EXISTS "lessons_courseId_idx" ON "lessons" ("courseId");
CREATE INDEX IF NOT EXISTS "lessons_moduleId_idx" ON "lessons" ("moduleId");
CREATE INDEX IF NOT EXISTS "project_submissions_userId_idx" ON "project_submissions" ("userId");
CREATE INDEX IF NOT EXISTS "project_submissions_courseId_idx" ON "project_submissions" ("courseId");
CREATE INDEX IF NOT EXISTS "project_submissions_miniProjectId_idx" ON "project_submissions" ("miniProjectId");
CREATE INDEX IF NOT EXISTS "project_submissions_status_idx" ON "project_submissions" ("status");
CREATE INDEX IF NOT EXISTS "project_submissions_capstoneType_idx" ON "project_submissions" ("capstoneType");
CREATE INDEX IF NOT EXISTS "project_submissions_projectType_idx" ON "project_submissions" ("projectType");
CREATE INDEX IF NOT EXISTS "project_submissions_userId_idx" ON "project_submissions" ("userId");
CREATE INDEX IF NOT EXISTS "project_submissions_courseId_idx" ON "project_submissions" ("courseId");
CREATE INDEX IF NOT EXISTS "project_submissions_miniProjectId_idx" ON "project_submissions" ("miniProjectId");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_awardId_idx" ON "scholarship_enrollments" ("awardId");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_type_idx" ON "scholarship_enrollments" ("type");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_status_idx" ON "scholarship_enrollments" ("status");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_awardId_idx" ON "scholarship_enrollments" ("awardId");
CREATE INDEX IF NOT EXISTS "user_lecture_progress_userId_courseId_idx" ON "user_lecture_progress" ("userId", "courseId");
CREATE INDEX IF NOT EXISTS "user_lecture_progress_userId_idx" ON "user_lecture_progress" ("userId");
CREATE INDEX IF NOT EXISTS "user_lecture_progress_lessonId_idx" ON "user_lecture_progress" ("lessonId");
CREATE INDEX IF NOT EXISTS "practical_exercises_lessonId_idx" ON "practical_exercises" ("lessonId");
CREATE INDEX IF NOT EXISTS "videos_lessonId_idx" ON "videos" ("lessonId");
CREATE INDEX IF NOT EXISTS "materials_lessonId_idx" ON "materials" ("lessonId");
CREATE INDEX IF NOT EXISTS "learning_progress_userId_idx" ON "learning_progress" ("userId");
CREATE INDEX IF NOT EXISTS "learning_progress_courseId_idx" ON "learning_progress" ("courseId");
CREATE INDEX IF NOT EXISTS "learning_progress_lessonId_idx" ON "learning_progress" ("lessonId");
CREATE INDEX IF NOT EXISTS "submission_versions_submissionId_idx" ON "submission_versions" ("submissionId");
CREATE INDEX IF NOT EXISTS "submission_versions_submissionId_idx" ON "submission_versions" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_reviews_submissionId_idx" ON "project_reviews" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_reviews_reviewerId_idx" ON "project_reviews" ("reviewerId");
CREATE INDEX IF NOT EXISTS "project_reviews_submissionId_idx" ON "project_reviews" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_reviews_reviewerId_idx" ON "project_reviews" ("reviewerId");
CREATE INDEX IF NOT EXISTS "project_status_history_submissionId_idx" ON "project_status_history" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_status_history_submissionId_idx" ON "project_status_history" ("submissionId");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_reviewerId_idx" ON "reviewer_assignments" ("reviewerId");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_status_idx" ON "reviewer_assignments" ("status");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_submissionId_idx" ON "reviewer_assignments" ("submissionId");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_reviewerId_idx" ON "reviewer_assignments" ("reviewerId");
CREATE INDEX IF NOT EXISTS "project_feedback_reviewId_idx" ON "project_feedback" ("reviewId");
CREATE INDEX IF NOT EXISTS "project_feedback_category_idx" ON "project_feedback" ("category");
CREATE INDEX IF NOT EXISTS "project_feedback_reviewId_idx" ON "project_feedback" ("reviewId");
CREATE INDEX IF NOT EXISTS "project_scores_reviewId_idx" ON "project_scores" ("reviewId");
CREATE INDEX IF NOT EXISTS "project_scores_rubricId_idx" ON "project_scores" ("rubricId");
CREATE INDEX IF NOT EXISTS "project_scores_reviewId_idx" ON "project_scores" ("reviewId");
CREATE INDEX IF NOT EXISTS "project_comments_submissionId_idx" ON "project_comments" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_comments_authorId_idx" ON "project_comments" ("authorId");
CREATE INDEX IF NOT EXISTS "project_comments_parentId_idx" ON "project_comments" ("parentId");
CREATE INDEX IF NOT EXISTS "project_comments_submissionId_idx" ON "project_comments" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_comments_authorId_idx" ON "project_comments" ("authorId");
CREATE INDEX IF NOT EXISTS "project_comments_parentId_idx" ON "project_comments" ("parentId");

-- ============================================
-- PHASE 4: UNIQUE CONSTRAINTS
-- ============================================

CREATE UNIQUE INDEX IF NOT EXISTS "exchange_rates_fromCurrency_toCurrency_key" ON "exchange_rates" ("fromCurrency", "toCurrency");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_analytics_scholarshipId_date_key" ON "scholarship_analytics" ("scholarshipId", "date");
CREATE UNIQUE INDEX IF NOT EXISTS "certificate_progress_userId_categoryCertificateId_key" ON "certificate_progress" ("userId", "categoryCertificateId");
CREATE UNIQUE INDEX IF NOT EXISTS "certificate_progress_userId_domainCertificateId_key" ON "certificate_progress" ("userId", "domainCertificateId");
CREATE UNIQUE INDEX IF NOT EXISTS "access_licenses_userId_licenseType_targetId_key" ON "access_licenses" ("userId", "licenseType", "targetId");
CREATE UNIQUE INDEX IF NOT EXISTS "certificate_eligibility_userId_certificateType_certificateId_key" ON "certificate_eligibility" ("userId", "certificateType", "certificateId");
CREATE UNIQUE INDEX IF NOT EXISTS "domain_certificates_domainId_key" ON "domain_certificates" ("domainId");
CREATE UNIQUE INDEX IF NOT EXISTS "categories_domainId_slug_key" ON "categories" ("domainId", "slug");
CREATE UNIQUE INDEX IF NOT EXISTS "categories_domainId_name_key" ON "categories" ("domainId", "name");
CREATE UNIQUE INDEX IF NOT EXISTS "domain_assignments_userId_domainId_key" ON "domain_assignments" ("userId", "domainId");
CREATE UNIQUE INDEX IF NOT EXISTS "academy_purchases_userId_key" ON "academy_purchases" ("userId");
CREATE UNIQUE INDEX IF NOT EXISTS "domain_purchases_userId_domainId_key" ON "domain_purchases" ("userId", "domainId");
CREATE UNIQUE INDEX IF NOT EXISTS "gateway_configurations_gatewayId_country_currency_key" ON "gateway_configurations" ("gatewayId", "country", "currency");
CREATE UNIQUE INDEX IF NOT EXISTS "learning_path_progress_userId_learningPathId_key" ON "learning_path_progress" ("userId", "learningPathId");
CREATE UNIQUE INDEX IF NOT EXISTS "user_roles_userId_roleId_key" ON "user_roles" ("userId", "roleId");
CREATE UNIQUE INDEX IF NOT EXISTS "role_permissions_roleId_permissionId_key" ON "role_permissions" ("roleId", "permissionId");
CREATE UNIQUE INDEX IF NOT EXISTS "user_policies_userId_policyId_scopeId_key" ON "user_policies" ("userId", "policyId", "scopeId");
CREATE UNIQUE INDEX IF NOT EXISTS "domain_issued_certs_domainCertificateId_userId_key" ON "domain_issued_certs" ("domainCertificateId", "userId");
CREATE UNIQUE INDEX IF NOT EXISTS "category_purchases_userId_categoryId_key" ON "category_purchases" ("userId", "categoryId");
CREATE UNIQUE INDEX IF NOT EXISTS "category_assignments_userId_categoryId_key" ON "category_assignments" ("userId", "categoryId");
CREATE UNIQUE INDEX IF NOT EXISTS "category_certificates_categoryId_key" ON "category_certificates" ("categoryId");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_difficulties_scholarshipId_difficultyLevel_key" ON "scholarship_difficulties" ("scholarshipId", "difficultyLevel");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_certificates_scholarshipId_certificateId_key" ON "scholarship_certificates" ("scholarshipId", "certificateId");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_plans_scholarshipId_planId_key" ON "scholarship_plans" ("scholarshipId", "planId");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_domains_scholarshipId_domainId_key" ON "scholarship_domains" ("scholarshipId", "domainId");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_categories_scholarshipId_categoryId_key" ON "scholarship_categories" ("scholarshipId", "categoryId");
CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_reviewers_scholarshipId_reviewerEmail_key" ON "scholarship_reviewers" ("scholarshipId", "reviewerEmail");
CREATE UNIQUE INDEX IF NOT EXISTS "learning_path_courses_learningPathId_courseId_key" ON "learning_path_courses" ("learningPathId", "courseId");
CREATE UNIQUE INDEX IF NOT EXISTS "course_assignments_userId_courseId_key" ON "course_assignments" ("userId", "courseId");
CREATE UNIQUE INDEX IF NOT EXISTS "modules_courseId_orderIndex_key" ON "modules" ("courseId", "orderIndex");
CREATE UNIQUE INDEX IF NOT EXISTS "certificates_userId_courseId_key" ON "certificates" ("userId", "courseId");
CREATE UNIQUE INDEX IF NOT EXISTS "enrollments_userId_courseId_key" ON "enrollments" ("userId", "courseId");
CREATE UNIQUE INDEX IF NOT EXISTS "course_versions_courseId_version_key" ON "course_versions" ("courseId", "version");
CREATE UNIQUE INDEX IF NOT EXISTS "wishlists_userId_courseId_key" ON "wishlists" ("userId", "courseId");
CREATE UNIQUE INDEX IF NOT EXISTS "category_issued_certs_categoryCertificateId_userId_key" ON "category_issued_certs" ("categoryCertificateId", "userId");
CREATE UNIQUE INDEX IF NOT EXISTS "user_lecture_progress_userId_lessonId_key" ON "user_lecture_progress" ("userId", "lessonId");
CREATE UNIQUE INDEX IF NOT EXISTS "learning_progress_userId_lessonId_key" ON "learning_progress" ("userId", "lessonId");
CREATE UNIQUE INDEX IF NOT EXISTS "submission_versions_submissionId_versionNumber_key" ON "submission_versions" ("submissionId", "versionNumber");
CREATE UNIQUE INDEX IF NOT EXISTS "reviewer_assignments_submissionId_reviewerId_key" ON "reviewer_assignments" ("submissionId", "reviewerId");
CREATE UNIQUE INDEX IF NOT EXISTS "project_scores_reviewId_rubricId_criteriaName_key" ON "project_scores" ("reviewId", "rubricId", "criteriaName");

-- ============================================
-- PHASE 5: UPDATE TIMESTAMP FUNCTIONS AND TRIGGERS
-- ============================================


CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domains_updated_at
    BEFORE UPDATE ON domains
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_certificate_templates_updated_at
    BEFORE UPDATE ON certificate_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_plans_updated_at
    BEFORE UPDATE ON plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_currency_settings_updated_at
    BEFORE UPDATE ON currency_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_gateways_updated_at
    BEFORE UPDATE ON payment_gateways
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exchange_rates_updated_at
    BEFORE UPDATE ON exchange_rates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_settings_updated_at
    BEFORE UPDATE ON payment_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_coupons_updated_at
    BEFORE UPDATE ON coupons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_paths_updated_at
    BEFORE UPDATE ON learning_paths
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_newsletter_campaigns_updated_at
    BEFORE UPDATE ON newsletter_campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stored_files_updated_at
    BEFORE UPDATE ON stored_files
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_settings_updated_at
    BEFORE UPDATE ON system_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_difficulty_level_caps_updated_at
    BEFORE UPDATE ON difficulty_level_caps
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_professional_caps_updated_at
    BEFORE UPDATE ON professional_caps
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_rubrics_updated_at
    BEFORE UPDATE ON project_rubrics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sponsors_updated_at
    BEFORE UPDATE ON sponsors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_analytics_updated_at
    BEFORE UPDATE ON scholarship_analytics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_scoring_rubrics_updated_at
    BEFORE UPDATE ON scholarship_scoring_rubrics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_roles_updated_at
    BEFORE UPDATE ON roles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_permissions_updated_at
    BEFORE UPDATE ON permissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_policies_updated_at
    BEFORE UPDATE ON policies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portfolio_entries_updated_at
    BEFORE UPDATE ON portfolio_entries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_support_tickets_updated_at
    BEFORE UPDATE ON support_tickets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_instructors_updated_at
    BEFORE UPDATE ON instructors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_certificate_progress_updated_at
    BEFORE UPDATE ON certificate_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_access_licenses_updated_at
    BEFORE UPDATE ON access_licenses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_certificate_eligibility_updated_at
    BEFORE UPDATE ON certificate_eligibility
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_forum_threads_updated_at
    BEFORE UPDATE ON forum_threads
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portal_assignments_updated_at
    BEFORE UPDATE ON portal_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_invoices_updated_at
    BEFORE UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at
    BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domain_certificates_updated_at
    BEFORE UPDATE ON domain_certificates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domain_assignments_updated_at
    BEFORE UPDATE ON domain_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_academy_purchases_updated_at
    BEFORE UPDATE ON academy_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domain_purchases_updated_at
    BEFORE UPDATE ON domain_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_gateway_configurations_updated_at
    BEFORE UPDATE ON gateway_configurations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_transactions_updated_at
    BEFORE UPDATE ON payment_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_discount_campaigns_updated_at
    BEFORE UPDATE ON discount_campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_capstone_enrollments_updated_at
    BEFORE UPDATE ON capstone_enrollments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sponsor_students_updated_at
    BEFORE UPDATE ON sponsor_students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarships_updated_at
    BEFORE UPDATE ON scholarships
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_roles_updated_at
    BEFORE UPDATE ON user_roles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_policies_updated_at
    BEFORE UPDATE ON user_policies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_forum_replies_updated_at
    BEFORE UPDATE ON forum_replies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_category_purchases_updated_at
    BEFORE UPDATE ON category_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at
    BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_category_assignments_updated_at
    BEFORE UPDATE ON category_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_category_certificates_updated_at
    BEFORE UPDATE ON category_certificates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_applications_updated_at
    BEFORE UPDATE ON scholarship_applications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_custom_questions_updated_at
    BEFORE UPDATE ON scholarship_custom_questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_reviewers_updated_at
    BEFORE UPDATE ON scholarship_reviewers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_objectives_updated_at
    BEFORE UPDATE ON course_objectives
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_assignments_updated_at
    BEFORE UPDATE ON course_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_learning_outcomes_updated_at
    BEFORE UPDATE ON course_learning_outcomes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_modules_updated_at
    BEFORE UPDATE ON modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_seo_updated_at
    BEFORE UPDATE ON course_seo
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_software_updated_at
    BEFORE UPDATE ON course_software
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_resources_updated_at
    BEFORE UPDATE ON course_resources
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mini_projects_updated_at
    BEFORE UPDATE ON mini_projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_datasets_updated_at
    BEFORE UPDATE ON course_datasets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prerequisites_updated_at
    BEFORE UPDATE ON prerequisites
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_career_outcomes_updated_at
    BEFORE UPDATE ON career_outcomes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_application_reviews_updated_at
    BEFORE UPDATE ON application_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_awards_updated_at
    BEFORE UPDATE ON scholarship_awards
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lessons_updated_at
    BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_submissions_updated_at
    BEFORE UPDATE ON project_submissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_lecture_progress_updated_at
    BEFORE UPDATE ON user_lecture_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_practical_exercises_updated_at
    BEFORE UPDATE ON practical_exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_progress_updated_at
    BEFORE UPDATE ON learning_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_reviews_updated_at
    BEFORE UPDATE ON project_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviewer_assignments_updated_at
    BEFORE UPDATE ON reviewer_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_comments_updated_at
    BEFORE UPDATE ON project_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- ============================================
-- COMPLETION
-- ============================================
SELECT 'Schema created successfully!' as status;
