-- ============================================
-- InnovaSci Open Academy - Complete Schema
-- Production-ready PostgreSQL schema for Supabase
-- Generated with proper dependency ordering
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- PHASE 1: CORE BASE TABLES (no dependencies)
-- ============================================

-- User -> users (Base table - referenced by many)
CREATE TABLE IF NOT EXISTS "users" (
"id" TEXT PRIMARY KEY,
"email" TEXT NOT NULL UNIQUE,
"passwordHash" TEXT,
"role" TEXT NOT NULL DEFAULT 'STUDENT',
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"emailVerified" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Student -> student (Stub table for backward compatibility)
CREATE TABLE IF NOT EXISTS "student" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"fullName" TEXT NOT NULL,
"email" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Author -> author (Stub table for forum compatibility)
CREATE TABLE IF NOT EXISTS "author" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"name" TEXT NOT NULL,
"email" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Thread -> thread (Stub table for forum compatibility)
CREATE TABLE IF NOT EXISTS "thread" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Ticket -> ticket (Stub table for support tickets)
CREATE TABLE IF NOT EXISTS "ticket" (
"id" TEXT PRIMARY KEY,
"subject" TEXT NOT NULL,
"status" TEXT DEFAULT 'open',
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Reviewer -> reviewer (Stub table for project reviews)
CREATE TABLE IF NOT EXISTS "reviewer" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"name" TEXT NOT NULL,
"email" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Review -> review (Stub table for project reviews)
CREATE TABLE IF NOT EXISTS "review" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT,
"reviewerId" TEXT,
"decision" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Reference -> reference (Stub table for project feedback)
CREATE TABLE IF NOT EXISTS "reference" (
"id" TEXT PRIMARY KEY,
"type" TEXT,
"name" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Parent -> parent (Stub table for nested comments)
CREATE TABLE IF NOT EXISTS "parent" (
"id" TEXT PRIMARY KEY,
"commentId" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Submission -> submission (Stub table for project submissions)
CREATE TABLE IF NOT EXISTS "submission" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"title" TEXT NOT NULL,
"status" TEXT DEFAULT 'DRAFT',
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Version -> version (Stub table for submission versions)
CREATE TABLE IF NOT EXISTS "version" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT,
"versionNumber" INTEGER NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Application -> application (Stub table for scholarship applications)
CREATE TABLE IF NOT EXISTS "application" (
"id" TEXT PRIMARY KEY,
"applicationNumber" TEXT NOT NULL,
"scholarshipId" TEXT,
"firstName" TEXT,
"lastName" TEXT,
"email" TEXT,
"status" TEXT DEFAULT 'PENDING',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Award -> award (Stub table for scholarship awards)
CREATE TABLE IF NOT EXISTS "award" (
"id" TEXT PRIMARY KEY,
"awardNumber" TEXT NOT NULL,
"recipientName" TEXT,
"recipientEmail" TEXT,
"status" TEXT DEFAULT 'PENDING',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Capstone -> capstone (Stub table for capstone projects)
CREATE TABLE IF NOT EXISTS "capstone" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"difficultyLevel" TEXT,
"status" TEXT DEFAULT 'DRAFT',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Rubric -> rubric (Stub table for project rubrics)
CREATE TABLE IF NOT EXISTS "rubric" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"type" TEXT DEFAULT 'MINI_PROJECT',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- ScoringRubric -> scoringrubric (Stub table for scholarship scoring)
CREATE TABLE IF NOT EXISTS "scoringrubric" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"criteria" JSONB,
"totalScore" INTEGER DEFAULT 100,
"passingScore" INTEGER DEFAULT 60,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- LinkedCourse -> linkedcourse (Stub table for portfolio entries)
CREATE TABLE IF NOT EXISTS "linkedcourse" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT,
"title" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- LinkedMiniProject -> linkedminiproject (Stub table for portfolio entries)
CREATE TABLE IF NOT EXISTS "linkedminiproject" (
"id" TEXT PRIMARY KEY,
"miniProjectId" TEXT,
"title" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- LinkedCapstone -> linkedcapstone (Stub table for portfolio entries)
CREATE TABLE IF NOT EXISTS "linkedcapstone" (
"id" TEXT PRIMARY KEY,
"capstoneId" TEXT,
"title" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Purchase -> purchase (Stub table for payment transactions)
CREATE TABLE IF NOT EXISTS "purchase" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"type" TEXT,
"amount" DECIMAL(10,2),
"status" TEXT DEFAULT 'pending',
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Target -> target (Stub table for access licenses)
CREATE TABLE IF NOT EXISTS "target" (
"id" TEXT PRIMARY KEY,
"type" TEXT,
"name" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- GrantedByAdmin -> grantedbyadmin (Stub table for access licenses)
CREATE TABLE IF NOT EXISTS "grantedbyadmin" (
"id" TEXT PRIMARY KEY,
"adminId" TEXT,
"adminName" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Membership -> membership (Stub table for scholarship enrollments)
CREATE TABLE IF NOT EXISTS "membership" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"planId" TEXT,
"status" TEXT DEFAULT 'active',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Scope -> scope (Stub table for user policies)
CREATE TABLE IF NOT EXISTS "scope" (
"id" TEXT PRIMARY KEY,
"type" TEXT,
"name" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- RecipientCourse -> recipientcourse (Stub table for newsletter campaigns)
CREATE TABLE IF NOT EXISTS "recipientcourse" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT,
"courseName" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Transaction -> transaction (Stub table for payment gateway logs)
CREATE TABLE IF NOT EXISTS "transaction" (
"id" TEXT PRIMARY KEY,
"reference" TEXT,
"amount" DECIMAL(10,2),
"status" TEXT DEFAULT 'pending',
"createdAt" TIMESTAMP(3) NOT NULL
);

-- Gateway -> gateway (Stub table for payment configurations)
CREATE TABLE IF NOT EXISTS "gateway" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"provider" TEXT,
"isEnabled" BOOLEAN DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- DefaultGateway -> defaultgateway (Stub table for payment settings)
CREATE TABLE IF NOT EXISTS "defaultgateway" (
"id" TEXT PRIMARY KEY,
"gatewayId" TEXT,
"currency" TEXT DEFAULT 'USD',
"country" TEXT DEFAULT 'US',
"isActive" BOOLEAN DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Paystack -> paystack (Stub table for Paystack payments)
CREATE TABLE IF NOT EXISTS "paystack" (
"id" TEXT PRIMARY KEY,
"reference" TEXT,
"amount" DECIMAL(10,2),
"status" TEXT DEFAULT 'pending',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- PaystackPlan -> paystackplan (Stub table for Paystack subscription plans)
CREATE TABLE IF NOT EXISTS "paystackplan" (
"id" TEXT PRIMARY KEY,
"planId" TEXT,
"planCode" TEXT,
"currency" TEXT,
"amount" DECIMAL(10,2),
"interval" TEXT DEFAULT 'monthly',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- StripePrice -> stripeprice (Stub table for Stripe prices)
CREATE TABLE IF NOT EXISTS "stripeprice" (
"id" TEXT PRIMARY KEY,
"stripePriceId" TEXT UNIQUE,
"productId" TEXT,
"currency" TEXT DEFAULT 'usd',
"unitAmount" INTEGER,
"recurring" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- StripeSubscription -> stripesubscription (Stub table for Stripe subscriptions)
CREATE TABLE IF NOT EXISTS "stripesubscription" (
"id" TEXT PRIMARY KEY,
"stripeSubscriptionId" TEXT UNIQUE,
"customerId" TEXT,
"status" TEXT DEFAULT 'active',
"currentPeriodStart" TIMESTAMP(3),
"currentPeriodEnd" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- DifficultyCapstone -> difficultycapstone (Stub table for difficulty-based capstones)
CREATE TABLE IF NOT EXISTS "difficultycapstone" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"slug" TEXT UNIQUE,
"difficultyLevel" TEXT,
"isPublished" BOOLEAN DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- ============================================
-- PHASE 2: TABLES WITH BASE TABLE DEPENDENCIES
-- ============================================

-- Profile -> profiles (depends on users)
CREATE TABLE IF NOT EXISTS "profiles" (
"id" TEXT PRIMARY KEY,
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
"status" TEXT NOT NULL DEFAULT 'active',
"preferences" JSONB DEFAULT '{}',
"currency" TEXT,
"currencySymbol" TEXT,
"language" TEXT,
"timezone" TEXT,
"preferredGateway" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

-- Instructor -> instructors (depends on users)
CREATE TABLE IF NOT EXISTS "instructors" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"name" TEXT NOT NULL,
"title" TEXT,
"bio" TEXT,
"avatarUrl" TEXT,
"expertise" TEXT NOT NULL,
"socialLinks" JSONB,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "instructors_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE SET NULL
);

-- Domain -> domains (depends on nothing)
CREATE TABLE IF NOT EXISTS "domains" (
"id" TEXT PRIMARY KEY,
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
"status" TEXT NOT NULL DEFAULT 'DRAFT',
"visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
"isFeatured" BOOLEAN NOT NULL DEFAULT false,
"seoTitle" TEXT,
"seoDescription" TEXT,
"seoKeywords" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE INDEX IF NOT EXISTS "domains_slug_idx" ON "domains" ("slug");
CREATE INDEX IF NOT EXISTS "domains_status_idx" ON "domains" ("status");
CREATE INDEX IF NOT EXISTS "domains_visibility_idx" ON "domains" ("visibility");
CREATE INDEX IF NOT EXISTS "domains_isFeatured_idx" ON "domains" ("isFeatured");

-- Category -> categories (depends on domains)
CREATE TABLE IF NOT EXISTS "categories" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"slug" TEXT NOT NULL,
"description" TEXT,
"icon" TEXT,
"thumbnailUrl" TEXT,
"bannerUrl" TEXT,
"color" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
"seoTitle" TEXT,
"seoDescription" TEXT,
"seoKeywords" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"domainId" TEXT,
CONSTRAINT "categories_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS "categories_domainId_slug_key" ON "categories" ("domainId", "slug");
CREATE UNIQUE INDEX IF NOT EXISTS "categories_domainId_name_key" ON "categories" ("domainId", "name");
CREATE INDEX IF NOT EXISTS "categories_domainId_idx" ON "categories" ("domainId");
CREATE INDEX IF NOT EXISTS "categories_slug_idx" ON "categories" ("slug");
CREATE INDEX IF NOT EXISTS "categories_isActive_idx" ON "categories" ("isActive");

-- CertificateTemplate -> certificate_templates (depends on nothing)
CREATE TABLE IF NOT EXISTS "certificate_templates" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"type" TEXT NOT NULL DEFAULT 'COURSE',
"backgroundUrl" TEXT NOT NULL,
"width" INTEGER NOT NULL DEFAULT 1200,
"height" INTEGER NOT NULL DEFAULT 900,
"studentNameX" DOUBLE PRECISION NOT NULL,
"studentNameY" DOUBLE PRECISION NOT NULL,
"studentNameSize" INTEGER NOT NULL DEFAULT 48,
"studentNameFont" TEXT NOT NULL DEFAULT 'Georgia',
"courseNameX" DOUBLE PRECISION NOT NULL,
"courseNameY" DOUBLE PRECISION NOT NULL,
"courseNameSize" INTEGER NOT NULL DEFAULT 32,
"courseNameFont" TEXT NOT NULL DEFAULT 'Georgia',
"issueDateX" DOUBLE PRECISION NOT NULL,
"issueDateY" DOUBLE PRECISION NOT NULL,
"issueDateSize" INTEGER NOT NULL DEFAULT 24,
"issueDateFont" TEXT NOT NULL DEFAULT 'Georgia',
"certificateIdX" DOUBLE PRECISION NOT NULL,
"certificateIdY" DOUBLE PRECISION NOT NULL,
"certificateIdSize" INTEGER NOT NULL DEFAULT 18,
"certificateIdFont" TEXT NOT NULL DEFAULT 'Courier',
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
"textColor" TEXT NOT NULL DEFAULT '#1a1a2e',
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Course -> courses (depends on categories, instructors, certificate_templates)
CREATE TABLE IF NOT EXISTS "courses" (
"id" TEXT PRIMARY KEY,
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
"language" TEXT NOT NULL DEFAULT 'English',
"durationHours" INTEGER,
"thumbnailUrl" TEXT,
"promoVideoUrl" TEXT,
"introVideoUrl" TEXT,
"price" DECIMAL(10,2) NOT NULL DEFAULT 0,
"pricing" JSONB,
"isFree" BOOLEAN NOT NULL DEFAULT true,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"status" TEXT NOT NULL DEFAULT 'draft',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"certificateTemplateId" TEXT,
"certificateTemplateUrl" TEXT,
"instructorId" TEXT,
"whatYouWillLearn" JSONB,
"requirements" JSONB,
CONSTRAINT "courses_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE NO ACTION,
CONSTRAINT "courses_instructorId_fkey" FOREIGN KEY ("instructorId") REFERENCES "instructors" ("id") ON DELETE NO ACTION,
CONSTRAINT "courses_certificateTemplateId_fkey" FOREIGN KEY ("certificateTemplateId") REFERENCES "certificate_templates" ("id") ON DELETE NO ACTION
);

-- LearningPath -> learning_paths (depends on nothing)
CREATE TABLE IF NOT EXISTS "learning_paths" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"slug" TEXT NOT NULL UNIQUE,
"subtitle" TEXT,
"description" TEXT,
"thumbnailUrl" TEXT,
"difficultyLevel" TEXT NOT NULL DEFAULT 'beginner',
"estimatedHours" INTEGER,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isPublished" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Plan -> plans (depends on stripeprice, paystackplan stubs)
CREATE TABLE IF NOT EXISTS "plans" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"planType" TEXT NOT NULL DEFAULT 'subscription',
"billingCycle" TEXT NOT NULL DEFAULT 'monthly',
"allowedDomainIds" TEXT NOT NULL,
"allowedCategoryIds" TEXT NOT NULL,
"price" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"pricing" JSONB,
"stripePriceId" TEXT UNIQUE,
"paystackPlanId" TEXT UNIQUE,
"features" JSONB DEFAULT '[]',
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isFeatured" BOOLEAN NOT NULL DEFAULT false,
"discountPercentage" INTEGER DEFAULT 0,
"promoCode" TEXT,
"maxCourses" INTEGER,
"maxCertificates" INTEGER,
"trialDays" INTEGER DEFAULT 0,
"sortOrder" INTEGER NOT NULL DEFAULT 0,
"baseCurrency" TEXT NOT NULL DEFAULT 'NGN',
"supportedCurrencies" TEXT NOT NULL,
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
"status" TEXT NOT NULL DEFAULT 'PUBLISHED',
"visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
"isPopular" BOOLEAN NOT NULL DEFAULT false,
"isRecommended" BOOLEAN NOT NULL DEFAULT false,
"seoTitle" TEXT,
"seoDescription" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "plans_stripePriceId_fkey" FOREIGN KEY ("stripePriceId") REFERENCES "stripeprice" ("id") ON DELETE NO ACTION,
CONSTRAINT "plans_paystackPlanId_fkey" FOREIGN KEY ("paystackPlanId") REFERENCES "paystackplan" ("id") ON DELETE NO ACTION
);

-- PaymentGateway -> payment_gateways (depends on nothing)
CREATE TABLE IF NOT EXISTS "payment_gateways" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL UNIQUE,
"provider" TEXT NOT NULL,
"slug" TEXT NOT NULL UNIQUE,
"isEnabled" BOOLEAN NOT NULL DEFAULT false,
"isDefault" BOOLEAN NOT NULL DEFAULT false,
"environment" TEXT NOT NULL DEFAULT 'sandbox',
"logoUrl" TEXT,
"iconName" TEXT,
"color" TEXT,
"publicKey" TEXT,
"secretKey" TEXT,
"webhookSecret" TEXT,
"supportedCurrencies" TEXT NOT NULL,
"supportedCountries" TEXT NOT NULL,
"supportedMethods" TEXT NOT NULL,
"transactionFeePercent" DECIMAL(10,2) NOT NULL DEFAULT 0,
"transactionFeeFixed" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"priority" INTEGER NOT NULL DEFAULT 100,
"lastHealthCheck" TIMESTAMP(3),
"healthStatus" TEXT NOT NULL DEFAULT 'unknown',
"healthMessage" TEXT,
"notes" TEXT,
"metadata" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- CurrencySetting -> currency_settings (depends on nothing)
CREATE TABLE IF NOT EXISTS "currency_settings" (
"id" TEXT PRIMARY KEY,
"currency" TEXT NOT NULL UNIQUE,
"name" TEXT NOT NULL,
"symbol" TEXT NOT NULL,
"code" TEXT NOT NULL,
"exchangeRate" DECIMAL(10,2) NOT NULL DEFAULT 1,
"isEnabled" BOOLEAN NOT NULL DEFAULT true,
"isDefault" BOOLEAN NOT NULL DEFAULT false,
"sortOrder" INTEGER NOT NULL DEFAULT 0,
"gatewayProvider" TEXT,
"gatewayEnabled" BOOLEAN NOT NULL DEFAULT false,
"gatewayConfig" JSONB,
"decimalPlaces" INTEGER NOT NULL DEFAULT 2,
"thousandsSeparator" TEXT NOT NULL DEFAULT ',',
"decimalSeparator" TEXT NOT NULL DEFAULT '.',
"symbolPosition" TEXT NOT NULL DEFAULT 'before',
"exchangeRateProvider" TEXT,
"lastRateUpdate" TIMESTAMP(3),
"autoUpdateRates" BOOLEAN NOT NULL DEFAULT false,
"updateIntervalHours" INTEGER NOT NULL DEFAULT 24,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- ExchangeRate -> exchange_rates (depends on nothing)
CREATE TABLE IF NOT EXISTS "exchange_rates" (
"id" TEXT PRIMARY KEY,
"fromCurrency" TEXT NOT NULL,
"toCurrency" TEXT NOT NULL,
"rate" DECIMAL(10,2) NOT NULL,
"isAutomatic" BOOLEAN NOT NULL DEFAULT false,
"provider" TEXT,
"validFrom" TIMESTAMP(3) NOT NULL,
"validUntil" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS "exchange_rates_fromCurrency_toCurrency_key" ON "exchange_rates" ("fromCurrency", "toCurrency");

-- PaymentSettings -> payment_settings (depends on defaultgateway)
CREATE TABLE IF NOT EXISTS "payment_settings" (
"id" TEXT PRIMARY KEY,
"defaultGatewayId" TEXT,
"defaultCurrency" TEXT NOT NULL DEFAULT 'USD',
"supportedCurrencies" TEXT NOT NULL,
"exchangeRateMode" TEXT NOT NULL DEFAULT 'automatic',
"autoUpdateRates" BOOLEAN NOT NULL DEFAULT true,
"updateIntervalHours" INTEGER NOT NULL DEFAULT 24,
"paymentTimeout" INTEGER NOT NULL DEFAULT 30,
"retryAttempts" INTEGER NOT NULL DEFAULT 3,
"refundEnabled" BOOLEAN NOT NULL DEFAULT true,
"refundWindowDays" INTEGER NOT NULL DEFAULT 7,
"webhookEnabled" BOOLEAN NOT NULL DEFAULT true,
"webhookRetries" INTEGER NOT NULL DEFAULT 3,
"invoicePrefix" TEXT NOT NULL DEFAULT 'INV',
"invoiceAutoNumber" BOOLEAN NOT NULL DEFAULT true,
"receiptEnabled" BOOLEAN NOT NULL DEFAULT true,
"receiptEmailEnabled" BOOLEAN NOT NULL DEFAULT true,
"taxEnabled" BOOLEAN NOT NULL DEFAULT false,
"taxRate" DECIMAL(10,2) NOT NULL DEFAULT 0,
"taxName" TEXT NOT NULL DEFAULT 'Tax',
"platformFeePercent" DECIMAL(10,2) NOT NULL DEFAULT 0,
"platformFeeFixed" DECIMAL(10,2) NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "payment_settings_defaultGatewayId_fkey" FOREIGN KEY ("defaultGatewayId") REFERENCES "defaultgateway" ("id") ON DELETE NO ACTION
);

-- GatewayConfiguration -> gateway_configurations (depends on gateway)
CREATE TABLE IF NOT EXISTS "gateway_configurations" (
"id" TEXT PRIMARY KEY,
"gatewayId" TEXT NOT NULL,
"country" TEXT NOT NULL,
"countryName" TEXT NOT NULL,
"currency" TEXT NOT NULL,
"isEnabled" BOOLEAN NOT NULL DEFAULT true,
"priority" INTEGER NOT NULL DEFAULT 100,
"config" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "gateway_configurations_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "gateway" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "gateway_configurations_gatewayId_country_currency_key" ON "gateway_configurations" ("gatewayId", "country", "currency");

-- Coupon -> coupons (depends on nothing)
CREATE TABLE IF NOT EXISTS "coupons" (
"id" TEXT PRIMARY KEY,
"code" TEXT NOT NULL UNIQUE,
"discountType" TEXT NOT NULL,
"discountValue" DECIMAL(10,2) NOT NULL,
"currency" TEXT NOT NULL DEFAULT 'USD',
"maxUses" INTEGER,
"currentUses" INTEGER NOT NULL DEFAULT 0,
"maxUsesPerUser" INTEGER NOT NULL DEFAULT 1,
"startsAt" TIMESTAMP(3) NOT NULL,
"expiresAt" TIMESTAMP(3),
"applicableScope" TEXT NOT NULL DEFAULT 'all',
"applicablePlanIds" TEXT NOT NULL,
"applicableDomainIds" TEXT NOT NULL,
"applicableCategoryIds" TEXT NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isPublic" BOOLEAN NOT NULL DEFAULT true,
"minPurchaseAmount" DECIMAL(10,2),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE INDEX IF NOT EXISTS "coupons_code_idx" ON "coupons" ("code");
CREATE INDEX IF NOT EXISTS "coupons_isActive_idx" ON "coupons" ("isActive");

-- Invoice -> invoices (depends on users, payments, coupons)
CREATE TABLE IF NOT EXISTS "invoices" (
"id" TEXT PRIMARY KEY,
"invoiceNumber" TEXT NOT NULL UNIQUE,
"userId" TEXT NOT NULL,
"userEmail" TEXT NOT NULL,
"items" JSONB NOT NULL,
"subtotal" DECIMAL(10,2) NOT NULL DEFAULT 0,
"discountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
"taxAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
"totalAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"status" TEXT NOT NULL DEFAULT 'draft',
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
CONSTRAINT "invoices_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments" ("id") ON DELETE NO ACTION,
CONSTRAINT "invoices_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id") ON DELETE NO ACTION,
CONSTRAINT "invoices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "invoices_userId_idx" ON "invoices" ("userId");
CREATE INDEX IF NOT EXISTS "invoices_status_idx" ON "invoices" ("status");
CREATE INDEX IF NOT EXISTS "invoices_invoiceNumber_idx" ON "invoices" ("invoiceNumber");

-- Payment -> payments (depends on users, paystack, category_purchases, domain_purchases, academy_purchases)
CREATE TABLE IF NOT EXISTS "payments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"type" TEXT NOT NULL DEFAULT 'one_time',
"status" TEXT NOT NULL DEFAULT 'PENDING',
"amount" DECIMAL(10,2) NOT NULL,
"currency" TEXT NOT NULL DEFAULT 'NGN',
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
CONSTRAINT "payments_paystackId_fkey" FOREIGN KEY ("paystackId") REFERENCES "paystack" ("id") ON DELETE NO ACTION,
CONSTRAINT "payments_categoryPurchaseId_fkey" FOREIGN KEY ("categoryPurchaseId") REFERENCES "category_purchases" ("id") ON DELETE NO ACTION,
CONSTRAINT "payments_domainPurchaseId_fkey" FOREIGN KEY ("domainPurchaseId") REFERENCES "domain_purchases" ("id") ON DELETE NO ACTION,
CONSTRAINT "payments_academyPurchaseId_fkey" FOREIGN KEY ("academyPurchaseId") REFERENCES "academy_purchases" ("id") ON DELETE NO ACTION,
CONSTRAINT "payments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "payments_userId_idx" ON "payments" ("userId");
CREATE INDEX IF NOT EXISTS "payments_paystackRef_idx" ON "payments" ("paystackRef");
CREATE INDEX IF NOT EXISTS "payments_status_idx" ON "payments" ("status");
CREATE INDEX IF NOT EXISTS "payments_type_idx" ON "payments" ("type");

-- PaymentTransaction -> payment_transactions (depends on users, purchase, gateway)
CREATE TABLE IF NOT EXISTS "payment_transactions" (
"id" TEXT PRIMARY KEY,
"gatewayId" TEXT NOT NULL,
"reference" TEXT NOT NULL UNIQUE,
"gatewayRef" TEXT,
"userId" TEXT,
"amount" DECIMAL(10,2) NOT NULL,
"currency" TEXT NOT NULL,
"amountInBase" DECIMAL(10,2),
"exchangeRate" DECIMAL(10,2) NOT NULL DEFAULT 1,
"status" TEXT NOT NULL DEFAULT 'pending',
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
CONSTRAINT "payment_transactions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE NO ACTION,
CONSTRAINT "payment_transactions_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "purchase" ("id") ON DELETE NO ACTION,
CONSTRAINT "payment_transactions_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "gateway" ("id") ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "payment_transactions_userId_idx" ON "payment_transactions" ("userId");
CREATE INDEX IF NOT EXISTS "payment_transactions_gatewayId_idx" ON "payment_transactions" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_transactions_status_idx" ON "payment_transactions" ("status");
CREATE INDEX IF NOT EXISTS "payment_transactions_createdAt_idx" ON "payment_transactions" ("createdAt");

-- PaymentGatewayLog -> payment_gateway_logs (depends on gateway, transaction)
CREATE TABLE IF NOT EXISTS "payment_gateway_logs" (
"id" TEXT PRIMARY KEY,
"gatewayId" TEXT NOT NULL,
"transactionId" TEXT,
"logType" TEXT NOT NULL,
"level" TEXT NOT NULL DEFAULT 'info',
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
CONSTRAINT "payment_gateway_logs_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "transaction" ("id") ON DELETE NO ACTION,
CONSTRAINT "payment_gateway_logs_gatewayId_fkey" FOREIGN KEY ("gatewayId") REFERENCES "gateway" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "payment_gateway_logs_gatewayId_idx" ON "payment_gateway_logs" ("gatewayId");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_transactionId_idx" ON "payment_gateway_logs" ("transactionId");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_logType_idx" ON "payment_gateway_logs" ("logType");
CREATE INDEX IF NOT EXISTS "payment_gateway_logs_createdAt_idx" ON "payment_gateway_logs" ("createdAt");

-- Subscription -> subscriptions (depends on users, plans, stripesubscription)
CREATE TABLE IF NOT EXISTS "subscriptions" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"planId" TEXT,
"planName" TEXT NOT NULL DEFAULT 'FREE',
"status" TEXT NOT NULL DEFAULT 'active',
"startDate" TIMESTAMP(3) NOT NULL,
"endDate" TIMESTAMP(3),
"recurringPrice" DECIMAL(10,2),
"isPro" BOOLEAN NOT NULL DEFAULT false,
"autoRenew" BOOLEAN NOT NULL DEFAULT true,
"paystackSubscriptionCode" TEXT,
"stripeSubscriptionId" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "subscriptions_stripeSubscriptionId_fkey" FOREIGN KEY ("stripeSubscriptionId") REFERENCES "stripesubscription" ("id") ON DELETE NO ACTION,
CONSTRAINT "subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "subscriptions_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE SET NULL
);

-- DiscountCampaign -> discount_campaigns (depends on domains, categories, plans, coupons)
CREATE TABLE IF NOT EXISTS "discount_campaigns" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"discountType" TEXT NOT NULL,
"discountValue" DECIMAL(10,2) NOT NULL,
"currency" TEXT NOT NULL DEFAULT 'USD',
"targetType" TEXT NOT NULL,
"planId" TEXT,
"domainId" TEXT,
"categoryId" TEXT,
"startsAt" TIMESTAMP(3) NOT NULL,
"endsAt" TIMESTAMP(3),
"couponId" TEXT,
"couponCode" TEXT,
"requiresCoupon" BOOLEAN NOT NULL DEFAULT false,
"displayBanner" BOOLEAN NOT NULL DEFAULT true,
"bannerText" TEXT,
"bannerColor" TEXT,
"maxRedemptions" INTEGER,
"currentRedemptions" INTEGER NOT NULL DEFAULT 0,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"priority" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "discount_campaigns_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE NO ACTION,
CONSTRAINT "discount_campaigns_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE NO ACTION,
CONSTRAINT "discount_campaigns_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE SET NULL,
CONSTRAINT "discount_campaigns_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "discount_campaigns_isActive_idx" ON "discount_campaigns" ("isActive");
CREATE INDEX IF NOT EXISTS "discount_campaigns_startsAt_endsAt_idx" ON "discount_campaigns" ("startsAt", "endsAt");

-- ============================================
-- PHASE 3: CONTENT TABLES (course-related)
-- ============================================

-- Module -> modules (depends on courses)
CREATE TABLE IF NOT EXISTS "modules" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "modules_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "modules_courseId_orderIndex_key" ON "modules" ("courseId", "orderIndex");

-- Lesson -> lessons (depends on courses, modules)
CREATE TABLE IF NOT EXISTS "lessons" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"moduleId" TEXT,
"title" TEXT NOT NULL,
"description" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"lessonType" TEXT NOT NULL DEFAULT 'video',
"duration" INTEGER,
"videoUrl" TEXT,
"isPreview" BOOLEAN NOT NULL DEFAULT false,
"isFree" BOOLEAN NOT NULL DEFAULT false,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"isExercise" BOOLEAN NOT NULL DEFAULT false,
"exerciseDescription" TEXT,
"exerciseFilesUrl" TEXT,
"solutionVideoUrl" TEXT,
CONSTRAINT "lessons_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE,
CONSTRAINT "lessons_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES "modules" ("id") ON DELETE SET NULL
);

-- Material -> materials (depends on lessons)
CREATE TABLE IF NOT EXISTS "materials" (
"id" TEXT PRIMARY KEY,
"lessonId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"type" TEXT,
"fileUrl" TEXT NOT NULL,
"visibility" TEXT NOT NULL DEFAULT 'public',
"downloadAllowed" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "materials_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") ON DELETE CASCADE
);

-- Video -> videos (depends on lessons)
CREATE TABLE IF NOT EXISTS "videos" (
"id" TEXT PRIMARY KEY,
"lessonId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"videoUrl" TEXT NOT NULL,
"duration" INTEGER,
"provider" TEXT,
"storageType" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "videos_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") ON DELETE CASCADE
);

-- PracticalExercise -> practical_exercises (depends on lessons)
CREATE TABLE IF NOT EXISTS "practical_exercises" (
"id" TEXT PRIMARY KEY,
"lessonId" TEXT NOT NULL UNIQUE,
"instructions" TEXT,
"starterCode" TEXT,
"solutionCode" TEXT,
"hints" JSONB,
"rubric" JSONB,
"maxScore" INTEGER NOT NULL DEFAULT 100,
"passingScore" INTEGER NOT NULL DEFAULT 70,
"timeLimit" INTEGER,
"isRequired" BOOLEAN NOT NULL DEFAULT false,
"allowRetry" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "practical_exercises_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") ON DELETE CASCADE
);

-- ============================================
-- PHASE 4: ENROLLMENT AND PROGRESS TABLES
-- ============================================

-- Enrollment -> enrollments (depends on users, courses)
CREATE TABLE IF NOT EXISTS "enrollments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"progressPercent" INTEGER NOT NULL DEFAULT 0,
"completed" BOOLEAN NOT NULL DEFAULT false,
"enrolledAt" TIMESTAMP(3) NOT NULL,
"completedAt" TIMESTAMP(3),
CONSTRAINT "enrollments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "enrollments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "enrollments_userId_courseId_key" ON "enrollments" ("userId", "courseId");

-- LearningProgress -> learning_progress (depends on users, courses, lessons)
CREATE TABLE IF NOT EXISTS "learning_progress" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"lessonId" TEXT NOT NULL,
"completed" BOOLEAN NOT NULL DEFAULT false,
"watchTime" INTEGER NOT NULL DEFAULT 0,
"completedAt" TIMESTAMP(3),
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "learning_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "learning_progress_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE,
CONSTRAINT "learning_progress_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "learning_progress_userId_lessonId_key" ON "learning_progress" ("userId", "lessonId");

-- UserLectureProgress -> user_lecture_progress (depends on users, lessons, courses)
CREATE TABLE IF NOT EXISTS "user_lecture_progress" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"lessonId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"completed" BOOLEAN NOT NULL DEFAULT false,
"completedAt" TIMESTAMP(3),
"watchTime" INTEGER NOT NULL DEFAULT 0,
"lastPosition" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "user_lecture_progress_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE NO ACTION,
CONSTRAINT "user_lecture_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "user_lecture_progress_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "lessons" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "user_lecture_progress_userId_lessonId_key" ON "user_lecture_progress" ("userId", "lessonId");
CREATE INDEX IF NOT EXISTS "user_lecture_progress_userId_courseId_idx" ON "user_lecture_progress" ("userId", "courseId");

-- Wishlist -> wishlists (depends on users, courses)
CREATE TABLE IF NOT EXISTS "wishlists" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"addedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "wishlists_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "wishlists_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "wishlists_userId_courseId_key" ON "wishlists" ("userId", "courseId");

-- LearningPathCourse -> learning_path_courses (depends on learning_paths, courses)
CREATE TABLE IF NOT EXISTS "learning_path_courses" (
"id" TEXT PRIMARY KEY,
"learningPathId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"isRequired" BOOLEAN NOT NULL DEFAULT true,
"stepTitle" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "learning_path_courses_learningPathId_fkey" FOREIGN KEY ("learningPathId") REFERENCES "learning_paths" ("id") ON DELETE CASCADE,
CONSTRAINT "learning_path_courses_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "learning_path_courses_learningPathId_courseId_key" ON "learning_path_courses" ("learningPathId", "courseId");

-- LearningPathProgress -> learning_path_progress (depends on users, learning_paths)
CREATE TABLE IF NOT EXISTS "learning_path_progress" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"learningPathId" TEXT NOT NULL,
"enrolledAt" TIMESTAMP(3) NOT NULL,
"completedAt" TIMESTAMP(3),
"progressPercent" INTEGER NOT NULL DEFAULT 0,
CONSTRAINT "learning_path_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "learning_path_progress_learningPathId_fkey" FOREIGN KEY ("learningPathId") REFERENCES "learning_paths" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "learning_path_progress_userId_learningPathId_key" ON "learning_path_progress" ("userId", "learningPathId");

-- ============================================
-- PHASE 5: CERTIFICATE TABLES
-- ============================================

-- Certificate -> certificates (depends on users, courses)
CREATE TABLE IF NOT EXISTS "certificates" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"certificateUrl" TEXT,
"pdfUrl" TEXT,
"verificationUrl" TEXT,
"verificationCode" TEXT NOT NULL UNIQUE,
"issuedAt" TIMESTAMP(3) NOT NULL,
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
CONSTRAINT "certificates_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "certificates_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "certificates_userId_courseId_key" ON "certificates" ("userId", "courseId");
CREATE INDEX IF NOT EXISTS "certificates_userId_idx" ON "certificates" ("userId");
CREATE INDEX IF NOT EXISTS "certificates_courseId_idx" ON "certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "certificates_status_idx" ON "certificates" ("status");

-- IssuedCertificate -> issued_certificates (depends on certificates, student, courses)
CREATE TABLE IF NOT EXISTS "issued_certificates" (
"id" TEXT PRIMARY KEY,
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
CONSTRAINT "issued_certificates_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "issued_certificates_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "student" ("id") ON DELETE CASCADE,
CONSTRAINT "issued_certificates_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "issued_certificates_studentId_idx" ON "issued_certificates" ("studentId");
CREATE INDEX IF NOT EXISTS "issued_certificates_courseId_idx" ON "issued_certificates" ("courseId");
CREATE INDEX IF NOT EXISTS "issued_certificates_issuedAt_idx" ON "issued_certificates" ("issuedAt");

-- CategoryCertificate -> category_certificates (depends on categories)
CREATE TABLE IF NOT EXISTS "category_certificates" (
"id" TEXT PRIMARY KEY,
"categoryId" TEXT NOT NULL,
"certificateName" TEXT NOT NULL,
"description" TEXT,
"requirements" JSONB,
"templateData" JSONB,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "category_certificates_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "category_certificates_categoryId_key" ON "category_certificates" ("categoryId");
CREATE INDEX IF NOT EXISTS "category_certificates_categoryId_idx" ON "category_certificates" ("categoryId");

-- DomainCertificate -> domain_certificates (depends on domains)
CREATE TABLE IF NOT EXISTS "domain_certificates" (
"id" TEXT PRIMARY KEY,
"domainId" TEXT NOT NULL,
"certificateName" TEXT NOT NULL,
"description" TEXT,
"requirements" JSONB,
"templateData" JSONB,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "domain_certificates_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "domain_certificates_domainId_key" ON "domain_certificates" ("domainId");
CREATE INDEX IF NOT EXISTS "domain_certificates_domainId_idx" ON "domain_certificates" ("domainId");

-- CategoryIssuedCert -> category_issued_certs (depends on users, category_certificates)
CREATE TABLE IF NOT EXISTS "category_issued_certs" (
"id" TEXT PRIMARY KEY,
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
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
CONSTRAINT "category_issued_certs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "category_issued_certs_categoryCertificateId_fkey" FOREIGN KEY ("categoryCertificateId") REFERENCES "category_certificates" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "category_issued_certs_categoryCertificateId_userId_key" ON "category_issued_certs" ("categoryCertificateId", "userId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_userId_idx" ON "category_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_categoryCertificateId_idx" ON "category_issued_certs" ("categoryCertificateId");
CREATE INDEX IF NOT EXISTS "category_issued_certs_status_idx" ON "category_issued_certs" ("status");

-- DomainIssuedCert -> domain_issued_certs (depends on users, domain_certificates)
CREATE TABLE IF NOT EXISTS "domain_issued_certs" (
"id" TEXT PRIMARY KEY,
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
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
CONSTRAINT "domain_issued_certs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "domain_issued_certs_domainCertificateId_fkey" FOREIGN KEY ("domainCertificateId") REFERENCES "domain_certificates" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "domain_issued_certs_domainCertificateId_userId_key" ON "domain_issued_certs" ("domainCertificateId", "userId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_userId_idx" ON "domain_issued_certs" ("userId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_domainCertificateId_idx" ON "domain_issued_certs" ("domainCertificateId");
CREATE INDEX IF NOT EXISTS "domain_issued_certs_status_idx" ON "domain_issued_certs" ("status");

-- CertificateProgress -> certificate_progress (depends on users, category_certificates, domain_certificates)
CREATE TABLE IF NOT EXISTS "certificate_progress" (
"id" TEXT PRIMARY KEY,
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
"completedCourseIds" TEXT NOT NULL,
"completedLessonIds" TEXT NOT NULL,
"completedExerciseIds" TEXT NOT NULL,
"completedMiniProjectIds" TEXT NOT NULL,
"completedCapstoneIds" TEXT NOT NULL,
"earnedCategoryCertIds" TEXT NOT NULL,
"lastActivityAt" TIMESTAMP(3) NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "certificate_progress_categoryCertificateId_fkey" FOREIGN KEY ("categoryCertificateId") REFERENCES "category_certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "certificate_progress_domainCertificateId_fkey" FOREIGN KEY ("domainCertificateId") REFERENCES "domain_certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "certificate_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "certificate_progress_userId_categoryCertificateId_key" ON "certificate_progress" ("userId", "categoryCertificateId");
CREATE UNIQUE INDEX IF NOT EXISTS "certificate_progress_userId_domainCertificateId_key" ON "certificate_progress" ("userId", "domainCertificateId");
CREATE INDEX IF NOT EXISTS "certificate_progress_userId_idx" ON "certificate_progress" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_progress_categoryCertificateId_idx" ON "certificate_progress" ("categoryCertificateId");
CREATE INDEX IF NOT EXISTS "certificate_progress_domainCertificateId_idx" ON "certificate_progress" ("domainCertificateId");

-- CertificateEligibility -> certificate_eligibility (depends on users, certificates)
CREATE TABLE IF NOT EXISTS "certificate_eligibility" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"certificateType" TEXT NOT NULL,
"certificateId" TEXT NOT NULL,
"isEligible" BOOLEAN NOT NULL DEFAULT false,
"eligibilityCheckedAt" TIMESTAMP(3) NOT NULL,
"lastCheckedAt" TIMESTAMP(3) NOT NULL,
"requirements" JSONB NOT NULL,
"eligibleAt" TIMESTAMP(3),
"notifiedAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "certificate_eligibility_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "certificate_eligibility_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "certificate_eligibility_userId_certificateType_certificateId_key" ON "certificate_eligibility" ("userId", "certificateType", "certificateId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_userId_idx" ON "certificate_eligibility" ("userId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_certificateType_certificateId_idx" ON "certificate_eligibility" ("certificateType", "certificateId");
CREATE INDEX IF NOT EXISTS "certificate_eligibility_isEligible_idx" ON "certificate_eligibility" ("isEligible");

-- ============================================
-- PHASE 6: PURCHASE TABLES
-- ============================================

-- CategoryPurchase -> category_purchases (depends on users, plans, domains, payments, coupons, invoices, categories)
CREATE TABLE IF NOT EXISTS "category_purchases" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"planId" TEXT,
"categoryId" TEXT NOT NULL,
"categoryName" TEXT NOT NULL,
"domainId" TEXT,
"domainName" TEXT,
"amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"paymentId" TEXT,
"status" TEXT NOT NULL DEFAULT 'active',
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
CONSTRAINT "category_purchases_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE NO ACTION,
CONSTRAINT "category_purchases_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments" ("id") ON DELETE NO ACTION,
CONSTRAINT "category_purchases_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id") ON DELETE NO ACTION,
CONSTRAINT "category_purchases_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices" ("id") ON DELETE NO ACTION,
CONSTRAINT "category_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "category_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE SET NULL,
CONSTRAINT "category_purchases_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE NO ACTION
);

CREATE UNIQUE INDEX IF NOT EXISTS "category_purchases_userId_categoryId_key" ON "category_purchases" ("userId", "categoryId");
CREATE INDEX IF NOT EXISTS "category_purchases_userId_idx" ON "category_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "category_purchases_categoryId_idx" ON "category_purchases" ("categoryId");
CREATE INDEX IF NOT EXISTS "category_purchases_status_idx" ON "category_purchases" ("status");

-- DomainPurchase -> domain_purchases (depends on users, plans, domains, payments, coupons, invoices)
CREATE TABLE IF NOT EXISTS "domain_purchases" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"planId" TEXT,
"domainId" TEXT NOT NULL,
"domainName" TEXT NOT NULL,
"amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"paymentId" TEXT,
"status" TEXT NOT NULL DEFAULT 'active',
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
CONSTRAINT "domain_purchases_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments" ("id") ON DELETE NO ACTION,
CONSTRAINT "domain_purchases_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id") ON DELETE NO ACTION,
CONSTRAINT "domain_purchases_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices" ("id") ON DELETE NO ACTION,
CONSTRAINT "domain_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "domain_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE SET NULL,
CONSTRAINT "domain_purchases_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE NO ACTION
);

CREATE UNIQUE INDEX IF NOT EXISTS "domain_purchases_userId_domainId_key" ON "domain_purchases" ("userId", "domainId");
CREATE INDEX IF NOT EXISTS "domain_purchases_userId_idx" ON "domain_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "domain_purchases_domainId_idx" ON "domain_purchases" ("domainId");
CREATE INDEX IF NOT EXISTS "domain_purchases_status_idx" ON "domain_purchases" ("status");

-- AcademyPurchase -> academy_purchases (depends on users, plans, payments, coupons, invoices)
CREATE TABLE IF NOT EXISTS "academy_purchases" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"planId" TEXT,
"amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"paymentId" TEXT,
"status" TEXT NOT NULL DEFAULT 'active',
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
CONSTRAINT "academy_purchases_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments" ("id") ON DELETE NO ACTION,
CONSTRAINT "academy_purchases_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons" ("id") ON DELETE NO ACTION,
CONSTRAINT "academy_purchases_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices" ("id") ON DELETE NO ACTION,
CONSTRAINT "academy_purchases_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "academy_purchases_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS "academy_purchases_userId_key" ON "academy_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "academy_purchases_userId_idx" ON "academy_purchases" ("userId");
CREATE INDEX IF NOT EXISTS "academy_purchases_status_idx" ON "academy_purchases" ("status");

-- AccessLicense -> access_licenses (depends on users, target, purchase, grantedbyadmin)
CREATE TABLE IF NOT EXISTS "access_licenses" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"licenseType" TEXT NOT NULL,
"targetId" TEXT NOT NULL,
"status" TEXT NOT NULL DEFAULT 'active',
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
CONSTRAINT "access_licenses_targetId_fkey" FOREIGN KEY ("targetId") REFERENCES "target" ("id") ON DELETE NO ACTION,
CONSTRAINT "access_licenses_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "purchase" ("id") ON DELETE NO ACTION,
CONSTRAINT "access_licenses_grantedByAdminId_fkey" FOREIGN KEY ("grantedByAdminId") REFERENCES "grantedbyadmin" ("id") ON DELETE NO ACTION,
CONSTRAINT "access_licenses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "access_licenses_userId_licenseType_targetId_key" ON "access_licenses" ("userId", "licenseType", "targetId");
CREATE INDEX IF NOT EXISTS "access_licenses_userId_idx" ON "access_licenses" ("userId");
CREATE INDEX IF NOT EXISTS "access_licenses_licenseType_targetId_idx" ON "access_licenses" ("licenseType", "targetId");
CREATE INDEX IF NOT EXISTS "access_licenses_status_idx" ON "access_licenses" ("status");

-- ============================================
-- PHASE 7: MINI-PROJECTS AND CAPSTONES
-- ============================================

-- MiniProject -> mini_projects (depends on courses)
CREATE TABLE IF NOT EXISTS "mini_projects" (
"id" TEXT PRIMARY KEY,
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
"isRequired" BOOLEAN NOT NULL DEFAULT false,
"dueDaysAfterStart" INTEGER,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "mini_projects_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "mini_projects_courseId_idx" ON "mini_projects" ("courseId");

-- ProfessionalCapstone -> professional_caps (depends on categories, certificate_templates)
CREATE TABLE IF NOT EXISTS "professional_caps" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"slug" TEXT NOT NULL UNIQUE,
"description" TEXT,
"categoryId" TEXT,
"includedCourses" JSONB,
"requirements" TEXT,
"deliverables" JSONB,
"evaluationCriteria" JSONB,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"isPublished" BOOLEAN NOT NULL DEFAULT false,
"thumbnailUrl" TEXT,
"certificateTemplateId" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "professional_caps_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE NO ACTION,
CONSTRAINT "professional_caps_certificateTemplateId_fkey" FOREIGN KEY ("certificateTemplateId") REFERENCES "certificate_templates" ("id") ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "professional_caps_categoryId_idx" ON "professional_caps" ("categoryId");
CREATE INDEX IF NOT EXISTS "professional_caps_isPublished_idx" ON "professional_caps" ("isPublished");

-- DifficultyLevelCapstone -> difficulty_level_caps (depends on certificate_templates)
CREATE TABLE IF NOT EXISTS "difficulty_level_caps" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"slug" TEXT NOT NULL UNIQUE,
"description" TEXT,
"difficultyLevel" TEXT NOT NULL,
"includedCourses" JSONB,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"isPublished" BOOLEAN NOT NULL DEFAULT false,
"thumbnailUrl" TEXT,
"certificateTemplateId" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "difficulty_level_caps_certificateTemplateId_fkey" FOREIGN KEY ("certificateTemplateId") REFERENCES "certificate_templates" ("id") ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "difficulty_level_caps_difficultyLevel_idx" ON "difficulty_level_caps" ("difficultyLevel");
CREATE INDEX IF NOT EXISTS "difficulty_level_caps_isPublished_idx" ON "difficulty_level_caps" ("isPublished");

-- CapstoneEnrollment -> capstone_enrollments (depends on users, certificates, difficultycapstone, professional_caps)
CREATE TABLE IF NOT EXISTS "capstone_enrollments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"difficultyCapstoneId" TEXT,
"professionalCapstoneId" TEXT,
"progressPercent" INTEGER NOT NULL DEFAULT 0,
"status" TEXT NOT NULL DEFAULT 'not_started',
"submittedAt" TIMESTAMP(3),
"grade" INTEGER,
"feedback" TEXT,
"certificateId" TEXT,
"enrolledAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "capstone_enrollments_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "capstone_enrollments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "capstone_enrollments_difficultyCapstoneId_fkey" FOREIGN KEY ("difficultyCapstoneId") REFERENCES "difficultycapstone" ("id") ON DELETE SET NULL,
CONSTRAINT "capstone_enrollments_professionalCapstoneId_fkey" FOREIGN KEY ("professionalCapstoneId") REFERENCES "professional_caps" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "capstone_enrollments_userId_idx" ON "capstone_enrollments" ("userId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_difficultyCapstoneId_idx" ON "capstone_enrollments" ("difficultyCapstoneId");
CREATE INDEX IF NOT EXISTS "capstone_enrollments_professionalCapstoneId_idx" ON "capstone_enrollments" ("professionalCapstoneId");

-- ============================================
-- PHASE 8: COURSE EXTENSIONS
-- ============================================

-- CourseLearningOutcome -> course_learning_outcomes (depends on courses)
CREATE TABLE IF NOT EXISTS "course_learning_outcomes" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"outcome" TEXT NOT NULL,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_learning_outcomes_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "course_learning_outcomes_courseId_idx" ON "course_learning_outcomes" ("courseId");

-- CourseObjective -> course_objectives (depends on courses)
CREATE TABLE IF NOT EXISTS "course_objectives" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"objective" TEXT NOT NULL,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_objectives_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "course_objectives_courseId_idx" ON "course_objectives" ("courseId");

-- CourseResource -> course_resources (depends on courses)
CREATE TABLE IF NOT EXISTS "course_resources" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"type" TEXT NOT NULL,
"url" TEXT NOT NULL,
"fileType" TEXT,
"fileSize" INTEGER,
"isDownloadable" BOOLEAN NOT NULL DEFAULT true,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_resources_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "course_resources_courseId_idx" ON "course_resources" ("courseId");

-- CourseSoftware -> course_software (depends on courses)
CREATE TABLE IF NOT EXISTS "course_software" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"name" TEXT NOT NULL,
"version" TEXT,
"url" TEXT,
"description" TEXT,
"isRequired" BOOLEAN NOT NULL DEFAULT true,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_software_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "course_software_courseId_idx" ON "course_software" ("courseId");

-- CourseDataset -> course_datasets (depends on courses)
CREATE TABLE IF NOT EXISTS "course_datasets" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"name" TEXT NOT NULL,
"description" TEXT,
"sourceUrl" TEXT,
"fileUrl" TEXT,
"fileType" TEXT,
"fileSize" INTEGER,
"isDownloadable" BOOLEAN NOT NULL DEFAULT false,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_datasets_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "course_datasets_courseId_idx" ON "course_datasets" ("courseId");

-- Prerequisite -> prerequisites (depends on courses)
CREATE TABLE IF NOT EXISTS "prerequisites" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"type" TEXT NOT NULL DEFAULT 'course',
"externalUrl" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "prerequisites_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "prerequisites_courseId_idx" ON "prerequisites" ("courseId");

-- CareerOutcome -> career_outcomes (depends on courses)
CREATE TABLE IF NOT EXISTS "career_outcomes" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"icon" TEXT,
"orderIndex" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "career_outcomes_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "career_outcomes_courseId_idx" ON "career_outcomes" ("courseId");

-- CourseSEO -> course_seo (depends on courses)
CREATE TABLE IF NOT EXISTS "course_seo" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL UNIQUE,
"metaTitle" TEXT,
"metaDescription" TEXT,
"keywords" TEXT NOT NULL,
"ogImage" TEXT,
"canonicalUrl" TEXT,
"noIndex" BOOLEAN NOT NULL DEFAULT false,
"noFollow" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_seo_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

-- CourseVersion -> course_versions (depends on courses)
CREATE TABLE IF NOT EXISTS "course_versions" (
"id" TEXT PRIMARY KEY,
"courseId" TEXT NOT NULL,
"version" INTEGER NOT NULL,
"changes" TEXT,
"createdBy" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_versions_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "course_versions_courseId_version_key" ON "course_versions" ("courseId", "version");
CREATE INDEX IF NOT EXISTS "course_versions_courseId_idx" ON "course_versions" ("courseId");

-- StoredFile -> stored_files (depends on courses)
CREATE TABLE IF NOT EXISTS "stored_files" (
"id" TEXT PRIMARY KEY,
"originalName" TEXT NOT NULL,
"storedName" TEXT NOT NULL UNIQUE,
"fileUrl" TEXT NOT NULL UNIQUE,
"fileSize" INTEGER NOT NULL,
"mimeType" TEXT NOT NULL,
"fileType" TEXT NOT NULL,
"storageType" TEXT NOT NULL DEFAULT 'local',
"folder" TEXT,
"tags" TEXT NOT NULL,
"courseId" TEXT,
"uploadedBy" TEXT,
"isOrphaned" BOOLEAN NOT NULL DEFAULT false,
"lastAccessedAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "stored_files_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE NO ACTION
);

-- ============================================
-- PHASE 9: SUPPORT AND NOTIFICATIONS
-- ============================================

-- Notification -> notifications (depends on users)
CREATE TABLE IF NOT EXISTS "notifications" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"message" TEXT NOT NULL,
"type" TEXT NOT NULL DEFAULT 'info',
"read" BOOLEAN NOT NULL DEFAULT false,
"data" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

-- SupportTicket -> support_tickets (depends on users)
CREATE TABLE IF NOT EXISTS "support_tickets" (
"id" TEXT PRIMARY KEY,
"userId" TEXT,
"email" TEXT NOT NULL,
"category" TEXT NOT NULL,
"subject" TEXT,
"message" TEXT NOT NULL,
"status" TEXT NOT NULL DEFAULT 'open',
"priority" TEXT NOT NULL DEFAULT 'medium',
"assignedTo" TEXT,
"labels" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"resolvedAt" TIMESTAMP(3),
CONSTRAINT "support_tickets_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "support_tickets_status_idx" ON "support_tickets" ("status");
CREATE INDEX IF NOT EXISTS "support_tickets_priority_idx" ON "support_tickets" ("priority");
CREATE INDEX IF NOT EXISTS "support_tickets_createdAt_idx" ON "support_tickets" ("createdAt");
CREATE INDEX IF NOT EXISTS "support_tickets_userId_idx" ON "support_tickets" ("userId");
CREATE INDEX IF NOT EXISTS "support_tickets_assignedTo_idx" ON "support_tickets" ("assignedTo");

-- TicketComment -> ticket_comments (depends on ticket, users)
CREATE TABLE IF NOT EXISTS "ticket_comments" (
"id" TEXT PRIMARY KEY,
"ticketId" TEXT NOT NULL,
"userId" TEXT,
"message" TEXT NOT NULL,
"isInternal" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "ticket_comments_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "ticket" ("id") ON DELETE CASCADE,
CONSTRAINT "ticket_comments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "ticket_comments_ticketId_idx" ON "ticket_comments" ("ticketId");

-- NewsletterSubscriber -> newsletter_subscribers (depends on nothing)
CREATE TABLE IF NOT EXISTS "newsletter_subscribers" (
"id" TEXT PRIMARY KEY,
"email" TEXT NOT NULL UNIQUE,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"subscribedAt" TIMESTAMP(3) NOT NULL,
"unsubscribedAt" TIMESTAMP(3)
);

-- NewsletterCampaign -> newsletter_campaigns (depends on recipientcourse)
CREATE TABLE IF NOT EXISTS "newsletter_campaigns" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"subject" TEXT NOT NULL,
"content" TEXT NOT NULL,
"status" TEXT NOT NULL DEFAULT 'draft',
"recipientType" TEXT NOT NULL DEFAULT 'all',
"recipientCourseId" TEXT,
"scheduledAt" TIMESTAMP(3),
"sentAt" TIMESTAMP(3),
"totalRecipients" INTEGER NOT NULL DEFAULT 0,
"successfulSends" INTEGER NOT NULL DEFAULT 0,
"failedSends" INTEGER NOT NULL DEFAULT 0,
"createdBy" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "newsletter_campaigns_recipientCourseId_fkey" FOREIGN KEY ("recipientCourseId") REFERENCES "recipientcourse" ("id") ON DELETE NO ACTION
);

-- SystemSetting -> system_settings (depends on nothing)
CREATE TABLE IF NOT EXISTS "system_settings" (
"id" TEXT PRIMARY KEY,
"key" TEXT NOT NULL UNIQUE,
"value" TEXT NOT NULL,
"type" TEXT NOT NULL DEFAULT 'string',
"category" TEXT NOT NULL DEFAULT 'general',
"description" TEXT,
"isPublic" BOOLEAN NOT NULL DEFAULT false,
"isEncrypted" BOOLEAN NOT NULL DEFAULT false,
"validation" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- ============================================
-- PHASE 10: FORUM TABLES
-- ============================================

-- ForumThread -> forum_threads (depends on author)
CREATE TABLE IF NOT EXISTS "forum_threads" (
"id" TEXT PRIMARY KEY,
"title" TEXT NOT NULL,
"content" TEXT NOT NULL,
"category" TEXT NOT NULL DEFAULT 'general',
"authorId" TEXT NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isPinned" BOOLEAN NOT NULL DEFAULT false,
"isResolved" BOOLEAN NOT NULL DEFAULT false,
"viewCount" INTEGER NOT NULL DEFAULT 0,
"replyCount" INTEGER NOT NULL DEFAULT 0,
"lastReplyAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "forum_threads_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "author" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "forum_threads_category_idx" ON "forum_threads" ("category");
CREATE INDEX IF NOT EXISTS "forum_threads_authorId_idx" ON "forum_threads" ("authorId");
CREATE INDEX IF NOT EXISTS "forum_threads_createdAt_idx" ON "forum_threads" ("createdAt");
CREATE INDEX IF NOT EXISTS "forum_threads_isPinned_idx" ON "forum_threads" ("isPinned");

-- ForumReply -> forum_replies (depends on author, thread)
CREATE TABLE IF NOT EXISTS "forum_replies" (
"id" TEXT PRIMARY KEY,
"content" TEXT NOT NULL,
"authorId" TEXT NOT NULL,
"threadId" TEXT NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isAccepted" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "forum_replies_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "author" ("id") ON DELETE CASCADE,
CONSTRAINT "forum_replies_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "thread" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "forum_replies_threadId_idx" ON "forum_replies" ("threadId");
CREATE INDEX IF NOT EXISTS "forum_replies_authorId_idx" ON "forum_replies" ("authorId");
CREATE INDEX IF NOT EXISTS "forum_replies_createdAt_idx" ON "forum_replies" ("createdAt");

-- ============================================
-- PHASE 11: PROJECT SUBMISSION TABLES
-- ============================================

-- ProjectRubric -> project_rubrics (depends on courses)
CREATE TABLE IF NOT EXISTS "project_rubrics" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"type" TEXT NOT NULL DEFAULT 'MINI_PROJECT',
"courseId" TEXT,
"difficultyLevel" TEXT,
"criteria" JSONB NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"isDefault" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_rubrics_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE NO ACTION
);

-- ProjectSubmission -> project_submissions (depends on users, courses, mini_projects, capstone, rubric)
CREATE TABLE IF NOT EXISTS "project_submissions" (
"id" TEXT PRIMARY KEY,
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
"status" TEXT NOT NULL DEFAULT 'DRAFT',
"isLocked" BOOLEAN NOT NULL DEFAULT false,
"isDeleted" BOOLEAN NOT NULL DEFAULT false,
"projectType" TEXT NOT NULL DEFAULT 'MINI_PROJECT',
"grade" INTEGER,
"gradeType" TEXT,
"rubricId" TEXT,
"rubricScore" DECIMAL(10,2) DEFAULT 0,
"maxScore" DECIMAL(10,2) DEFAULT 100,
"feedback" TEXT,
"submittedAt" TIMESTAMP(3),
"gradedAt" TIMESTAMP(3),
"isFromMCCS" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_submissions_capstoneId_fkey" FOREIGN KEY ("capstoneId") REFERENCES "capstone" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_submissions_rubricId_fkey" FOREIGN KEY ("rubricId") REFERENCES "rubric" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_submissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "project_submissions_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE SET NULL,
CONSTRAINT "project_submissions_miniProjectId_fkey" FOREIGN KEY ("miniProjectId") REFERENCES "mini_projects" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "project_submissions_userId_idx" ON "project_submissions" ("userId");
CREATE INDEX IF NOT EXISTS "project_submissions_courseId_idx" ON "project_submissions" ("courseId");
CREATE INDEX IF NOT EXISTS "project_submissions_miniProjectId_idx" ON "project_submissions" ("miniProjectId");
CREATE INDEX IF NOT EXISTS "project_submissions_status_idx" ON "project_submissions" ("status");
CREATE INDEX IF NOT EXISTS "project_submissions_capstoneType_idx" ON "project_submissions" ("capstoneType");
CREATE INDEX IF NOT EXISTS "project_submissions_projectType_idx" ON "project_submissions" ("projectType");

-- PortfolioEntry -> portfolio_entries (depends on users, linkedcourse, linkedminiproject, linkedcapstone)
CREATE TABLE IF NOT EXISTS "portfolio_entries" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"liveUrl" TEXT,
"githubUrl" TEXT,
"demoVideoUrl" TEXT,
"techStack" TEXT NOT NULL,
"screenshots" JSONB,
"demoVideo" TEXT,
"rationale" TEXT,
"visibility" TEXT NOT NULL DEFAULT 'PRIVATE',
"publicSlug" TEXT UNIQUE,
"linkedCourseId" TEXT,
"linkedMiniProjectId" TEXT,
"linkedCapstoneId" TEXT,
"isPublished" BOOLEAN NOT NULL DEFAULT false,
"viewCount" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "portfolio_entries_linkedCourseId_fkey" FOREIGN KEY ("linkedCourseId") REFERENCES "linkedcourse" ("id") ON DELETE NO ACTION,
CONSTRAINT "portfolio_entries_linkedMiniProjectId_fkey" FOREIGN KEY ("linkedMiniProjectId") REFERENCES "linkedminiproject" ("id") ON DELETE NO ACTION,
CONSTRAINT "portfolio_entries_linkedCapstoneId_fkey" FOREIGN KEY ("linkedCapstoneId") REFERENCES "linkedcapstone" ("id") ON DELETE NO ACTION,
CONSTRAINT "portfolio_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "portfolio_entries_userId_idx" ON "portfolio_entries" ("userId");
CREATE INDEX IF NOT EXISTS "portfolio_entries_visibility_idx" ON "portfolio_entries" ("visibility");
CREATE INDEX IF NOT EXISTS "portfolio_entries_publicSlug_idx" ON "portfolio_entries" ("publicSlug");

-- ProjectStatusHistory -> project_status_history (depends on submission)
CREATE TABLE IF NOT EXISTS "project_status_history" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT NOT NULL,
"previousStatus" TEXT,
"newStatus" TEXT NOT NULL,
"changedBy" TEXT NOT NULL,
"reason" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_status_history_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "submission" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "project_status_history_submissionId_idx" ON "project_status_history" ("submissionId");

-- SubmissionVersion -> submission_versions (depends on submission)
CREATE TABLE IF NOT EXISTS "submission_versions" (
"id" TEXT PRIMARY KEY,
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
"isLatest" BOOLEAN NOT NULL DEFAULT false,
"submittedAt" TIMESTAMP(3) NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "submission_versions_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "submission" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "submission_versions_submissionId_versionNumber_key" ON "submission_versions" ("submissionId", "versionNumber");
CREATE INDEX IF NOT EXISTS "submission_versions_submissionId_idx" ON "submission_versions" ("submissionId");

-- ProjectReview -> project_reviews (depends on submission, version, reviewer)
CREATE TABLE IF NOT EXISTS "project_reviews" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT NOT NULL,
"versionId" TEXT,
"reviewerId" TEXT NOT NULL,
"decision" TEXT NOT NULL,
"overallFeedback" TEXT,
"reviewedAt" TIMESTAMP(3) NOT NULL,
"isLatest" BOOLEAN NOT NULL DEFAULT true,
"timeSpentMinutes" INTEGER,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_reviews_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES "version" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_reviews_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "submission" ("id") ON DELETE CASCADE,
CONSTRAINT "project_reviews_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "reviewer" ("id") ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "project_reviews_submissionId_idx" ON "project_reviews" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_reviews_reviewerId_idx" ON "project_reviews" ("reviewerId");

-- ProjectFeedback -> project_feedback (depends on review, reference)
CREATE TABLE IF NOT EXISTS "project_feedback" (
"id" TEXT PRIMARY KEY,
"reviewId" TEXT NOT NULL,
"category" TEXT NOT NULL,
"title" TEXT,
"content" TEXT NOT NULL,
"recommendation" TEXT,
"referenceType" TEXT,
"referenceId" TEXT,
"referenceDetail" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_feedback_referenceId_fkey" FOREIGN KEY ("referenceId") REFERENCES "reference" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_feedback_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES "review" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "project_feedback_reviewId_idx" ON "project_feedback" ("reviewId");
CREATE INDEX IF NOT EXISTS "project_feedback_category_idx" ON "project_feedback" ("category");

-- ProjectScore -> project_scores (depends on review, rubric)
CREATE TABLE IF NOT EXISTS "project_scores" (
"id" TEXT PRIMARY KEY,
"reviewId" TEXT NOT NULL,
"rubricId" TEXT NOT NULL,
"criteriaName" TEXT NOT NULL,
"pointsAwarded" DECIMAL(10,2) NOT NULL DEFAULT 0,
"maxPoints" DECIMAL(10,2) NOT NULL,
"feedback" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_scores_rubricId_fkey" FOREIGN KEY ("rubricId") REFERENCES "rubric" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_scores_reviewId_fkey" FOREIGN KEY ("reviewId") REFERENCES "review" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "project_scores_reviewId_rubricId_criteriaName_key" ON "project_scores" ("reviewId", "rubricId", "criteriaName");
CREATE INDEX IF NOT EXISTS "project_scores_reviewId_idx" ON "project_scores" ("reviewId");

-- ReviewerAssignment -> reviewer_assignments (depends on submission, reviewer)
CREATE TABLE IF NOT EXISTS "reviewer_assignments" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT NOT NULL,
"reviewerId" TEXT NOT NULL,
"assignedAt" TIMESTAMP(3) NOT NULL,
"assignedBy" TEXT,
"dueDate" TIMESTAMP(3),
"status" TEXT NOT NULL DEFAULT 'PENDING',
"completedAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "reviewer_assignments_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "submission" ("id") ON DELETE CASCADE,
CONSTRAINT "reviewer_assignments_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "reviewer" ("id") ON DELETE NO ACTION
);

CREATE UNIQUE INDEX IF NOT EXISTS "reviewer_assignments_submissionId_reviewerId_key" ON "reviewer_assignments" ("submissionId", "reviewerId");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_reviewerId_idx" ON "reviewer_assignments" ("reviewerId");
CREATE INDEX IF NOT EXISTS "reviewer_assignments_status_idx" ON "reviewer_assignments" ("status");

-- ProjectComment -> project_comments (depends on submission, author, reference, parent)
CREATE TABLE IF NOT EXISTS "project_comments" (
"id" TEXT PRIMARY KEY,
"submissionId" TEXT NOT NULL,
"authorId" TEXT NOT NULL,
"content" TEXT NOT NULL,
"isInternal" BOOLEAN NOT NULL DEFAULT false,
"referenceType" TEXT,
"referenceId" TEXT,
"parentId" TEXT,
"isResolved" BOOLEAN NOT NULL DEFAULT false,
"resolvedBy" TEXT,
"resolvedAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "project_comments_referenceId_fkey" FOREIGN KEY ("referenceId") REFERENCES "reference" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_comments_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "submission" ("id") ON DELETE CASCADE,
CONSTRAINT "project_comments_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "author" ("id") ON DELETE NO ACTION,
CONSTRAINT "project_comments_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "parent" ("id") ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "project_comments_submissionId_idx" ON "project_comments" ("submissionId");
CREATE INDEX IF NOT EXISTS "project_comments_authorId_idx" ON "project_comments" ("authorId");
CREATE INDEX IF NOT EXISTS "project_comments_parentId_idx" ON "project_comments" ("parentId");

-- ============================================
-- PHASE 12: SCHOLARSHIP TABLES
-- ============================================

-- Sponsor -> sponsors (depends on nothing)
CREATE TABLE IF NOT EXISTS "sponsors" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"shortName" TEXT,
"slug" TEXT NOT NULL UNIQUE,
"logo" TEXT,
"website" TEXT,
"description" TEXT,
"contactName" TEXT,
"contactEmail" TEXT,
"contactPhone" TEXT,
"address" TEXT,
"budget" DECIMAL(10,2) DEFAULT 0,
"spent" DECIMAL(10,2) NOT NULL DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"seoTitle" TEXT,
"seoDescription" TEXT,
"config" JSONB,
"status" TEXT DEFAULT 'ACTIVE',
"type" TEXT DEFAULT 'INDIVIDUAL',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE INDEX IF NOT EXISTS "sponsors_slug_idx" ON "sponsors" ("slug");
CREATE INDEX IF NOT EXISTS "sponsors_status_idx" ON "sponsors" ("status");
CREATE INDEX IF NOT EXISTS "sponsors_type_idx" ON "sponsors" ("type");

-- Scholarship -> scholarships (depends on scoringrubric, sponsors)
CREATE TABLE IF NOT EXISTS "scholarships" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"shortName" TEXT,
"slug" TEXT NOT NULL UNIQUE,
"description" TEXT,
"objectives" TEXT,
"eligibility" TEXT,
"benefits" TEXT,
"coverage" TEXT,
"awardAmount" DECIMAL(10,2) DEFAULT 0,
"currency" TEXT NOT NULL DEFAULT 'USD',
"availableSlots" INTEGER DEFAULT 0,
"openingDate" TIMESTAMP(3),
"closingDate" TIMESTAMP(3),
"applicationDeadline" TIMESTAMP(3),
"selectionMethod" TEXT,
"visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
"isFeatured" BOOLEAN NOT NULL DEFAULT false,
"bannerUrl" TEXT,
"thumbnailUrl" TEXT,
"color" TEXT,
"icon" TEXT,
"seoTitle" TEXT,
"seoDescription" TEXT,
"seoKeywords" TEXT,
"config" JSONB,
"benefitsConfig" JSONB,
"autoEnroll" BOOLEAN NOT NULL DEFAULT false,
"createAccount" BOOLEAN NOT NULL DEFAULT true,
"assignMembership" BOOLEAN NOT NULL DEFAULT false,
"assignDomain" BOOLEAN NOT NULL DEFAULT false,
"assignCategory" BOOLEAN NOT NULL DEFAULT false,
"assignCourse" BOOLEAN NOT NULL DEFAULT false,
"waiverFees" BOOLEAN NOT NULL DEFAULT false,
"requireInterview" BOOLEAN NOT NULL DEFAULT false,
"scoringRubricId" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"publishedAt" TIMESTAMP(3),
"closedAt" TIMESTAMP(3),
"sponsorId" TEXT,
"viewCount" INTEGER NOT NULL DEFAULT 0,
"applicationCount" INTEGER NOT NULL DEFAULT 0,
"status" TEXT NOT NULL DEFAULT 'DRAFT',
"type" TEXT NOT NULL DEFAULT 'FULL_SCHOLARSHIP',
CONSTRAINT "scholarships_scoringRubricId_fkey" FOREIGN KEY ("scoringRubricId") REFERENCES "scoringrubric" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarships_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "scholarships_slug_idx" ON "scholarships" ("slug");
CREATE INDEX IF NOT EXISTS "scholarships_status_idx" ON "scholarships" ("status");
CREATE INDEX IF NOT EXISTS "scholarships_visibility_idx" ON "scholarships" ("visibility");
CREATE INDEX IF NOT EXISTS "scholarships_type_idx" ON "scholarships" ("type");
CREATE INDEX IF NOT EXISTS "scholarships_isFeatured_idx" ON "scholarships" ("isFeatured");
CREATE INDEX IF NOT EXISTS "scholarships_sponsorId_idx" ON "scholarships" ("sponsorId");
CREATE INDEX IF NOT EXISTS "scholarships_closingDate_idx" ON "scholarships" ("closingDate");

-- ScholarshipDomain -> scholarship_domains (depends on scholarships, domains)
CREATE TABLE IF NOT EXISTS "scholarship_domains" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"domainId" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_domains_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE,
CONSTRAINT "scholarship_domains_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_domains_scholarshipId_domainId_key" ON "scholarship_domains" ("scholarshipId", "domainId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_scholarshipId_idx" ON "scholarship_domains" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_domains_domainId_idx" ON "scholarship_domains" ("domainId");

-- ScholarshipCategory -> scholarship_categories (depends on scholarships, categories)
CREATE TABLE IF NOT EXISTS "scholarship_categories" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"categoryId" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_categories_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE,
CONSTRAINT "scholarship_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_categories_scholarshipId_categoryId_key" ON "scholarship_categories" ("scholarshipId", "categoryId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_scholarshipId_idx" ON "scholarship_categories" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_categories_categoryId_idx" ON "scholarship_categories" ("categoryId");

-- ScholarshipDifficulty -> scholarship_difficulties (depends on scholarships)
CREATE TABLE IF NOT EXISTS "scholarship_difficulties" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"difficultyLevel" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_difficulties_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_difficulties_scholarshipId_difficultyLevel_key" ON "scholarship_difficulties" ("scholarshipId", "difficultyLevel");
CREATE INDEX IF NOT EXISTS "scholarship_difficulties_scholarshipId_idx" ON "scholarship_difficulties" ("scholarshipId");

-- ScholarshipCertificate -> scholarship_certificates (depends on scholarships, certificates)
CREATE TABLE IF NOT EXISTS "scholarship_certificates" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"certificateId" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_certificates_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE,
CONSTRAINT "scholarship_certificates_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificates" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_certificates_scholarshipId_certificateId_key" ON "scholarship_certificates" ("scholarshipId", "certificateId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_scholarshipId_idx" ON "scholarship_certificates" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_certificates_certificateId_idx" ON "scholarship_certificates" ("certificateId");

-- ScholarshipPlan -> scholarship_plans (depends on scholarships, plans)
CREATE TABLE IF NOT EXISTS "scholarship_plans" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"planId" TEXT NOT NULL,
"duration" INTEGER DEFAULT 365,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_plans_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE,
CONSTRAINT "scholarship_plans_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_plans_scholarshipId_planId_key" ON "scholarship_plans" ("scholarshipId", "planId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_scholarshipId_idx" ON "scholarship_plans" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_plans_planId_idx" ON "scholarship_plans" ("planId");

-- SponsorStudent -> sponsor_students (depends on sponsors, student, scholarships, application, award)
CREATE TABLE IF NOT EXISTS "sponsor_students" (
"id" TEXT PRIMARY KEY,
"sponsorId" TEXT NOT NULL,
"studentEmail" TEXT NOT NULL,
"studentName" TEXT,
"studentId" TEXT,
"scholarshipId" TEXT,
"applicationId" TEXT,
"awardId" TEXT,
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"amount" DECIMAL(10,2),
"currency" TEXT NOT NULL DEFAULT 'USD',
"progressReport" TEXT,
"lastReportDate" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "sponsor_students_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "student" ("id") ON DELETE NO ACTION,
CONSTRAINT "sponsor_students_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE NO ACTION,
CONSTRAINT "sponsor_students_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "application" ("id") ON DELETE NO ACTION,
CONSTRAINT "sponsor_students_awardId_fkey" FOREIGN KEY ("awardId") REFERENCES "award" ("id") ON DELETE NO ACTION,
CONSTRAINT "sponsor_students_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "sponsor_students_sponsorId_idx" ON "sponsor_students" ("sponsorId");
CREATE INDEX IF NOT EXISTS "sponsor_students_studentEmail_idx" ON "sponsor_students" ("studentEmail");
CREATE INDEX IF NOT EXISTS "sponsor_students_status_idx" ON "sponsor_students" ("status");

-- SponsorReport -> sponsor_reports (depends on sponsors)
CREATE TABLE IF NOT EXISTS "sponsor_reports" (
"id" TEXT PRIMARY KEY,
"sponsorId" TEXT NOT NULL,
"title" TEXT NOT NULL,
"description" TEXT,
"data" JSONB,
"fileUrl" TEXT,
"period" TEXT,
"periodStart" TIMESTAMP(3),
"periodEnd" TIMESTAMP(3),
"sentAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "sponsor_reports_sponsorId_fkey" FOREIGN KEY ("sponsorId") REFERENCES "sponsors" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "sponsor_reports_sponsorId_idx" ON "sponsor_reports" ("sponsorId");
CREATE INDEX IF NOT EXISTS "sponsor_reports_sentAt_idx" ON "sponsor_reports" ("sentAt");

-- ScholarshipApplication -> scholarship_applications (depends on scholarships, users, award)
CREATE TABLE IF NOT EXISTS "scholarship_applications" (
"id" TEXT PRIMARY KEY,
"applicationNumber" TEXT NOT NULL UNIQUE,
"trackingNumber" TEXT NOT NULL UNIQUE,
"scholarshipId" TEXT NOT NULL,
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
"accountCreated" BOOLEAN NOT NULL DEFAULT false,
"isDraft" BOOLEAN NOT NULL DEFAULT true,
"lastSavedAt" TIMESTAMP(3),
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"submittedAt" TIMESTAMP(3),
"status" TEXT NOT NULL DEFAULT 'PENDING',
CONSTRAINT "scholarship_applications_awardId_fkey" FOREIGN KEY ("awardId") REFERENCES "award" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_applications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_applications_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "scholarship_applications_applicationNumber_idx" ON "scholarship_applications" ("applicationNumber");
CREATE INDEX IF NOT EXISTS "scholarship_applications_trackingNumber_idx" ON "scholarship_applications" ("trackingNumber");
CREATE INDEX IF NOT EXISTS "scholarship_applications_scholarshipId_idx" ON "scholarship_applications" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_applications_status_idx" ON "scholarship_applications" ("status");
CREATE INDEX IF NOT EXISTS "scholarship_applications_email_idx" ON "scholarship_applications" ("email");
CREATE INDEX IF NOT EXISTS "scholarship_applications_country_idx" ON "scholarship_applications" ("country");
CREATE INDEX IF NOT EXISTS "scholarship_applications_submittedAt_idx" ON "scholarship_applications" ("submittedAt");

-- ApplicationReview -> application_reviews (depends on application, reviewer)
CREATE TABLE IF NOT EXISTS "application_reviews" (
"id" TEXT PRIMARY KEY,
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
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"completedAt" TIMESTAMP(3),
"status" TEXT NOT NULL DEFAULT 'PENDING',
CONSTRAINT "application_reviews_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "reviewer" ("id") ON DELETE NO ACTION,
CONSTRAINT "application_reviews_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "application" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "application_reviews_applicationId_idx" ON "application_reviews" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_reviews_reviewerId_idx" ON "application_reviews" ("reviewerId");
CREATE INDEX IF NOT EXISTS "application_reviews_status_idx" ON "application_reviews" ("status");

-- ApplicationStatusHistory -> application_status_history (depends on application)
CREATE TABLE IF NOT EXISTS "application_status_history" (
"id" TEXT PRIMARY KEY,
"applicationId" TEXT NOT NULL,
"previousStatus" TEXT,
"newStatus" TEXT NOT NULL,
"changedBy" TEXT,
"changedByName" TEXT,
"notes" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "application_status_history_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "application" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "application_status_history_applicationId_idx" ON "application_status_history" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_status_history_createdAt_idx" ON "application_status_history" ("createdAt");

-- ApplicationNotification -> application_notifications (depends on application)
CREATE TABLE IF NOT EXISTS "application_notifications" (
"id" TEXT PRIMARY KEY,
"applicationId" TEXT NOT NULL,
"type" TEXT NOT NULL,
"title" TEXT NOT NULL,
"message" TEXT NOT NULL,
"channel" TEXT NOT NULL DEFAULT 'EMAIL',
"sentAt" TIMESTAMP(3),
"deliveredAt" TIMESTAMP(3),
"readAt" TIMESTAMP(3),
"metadata" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "application_notifications_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "application" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "application_notifications_applicationId_idx" ON "application_notifications" ("applicationId");
CREATE INDEX IF NOT EXISTS "application_notifications_type_idx" ON "application_notifications" ("type");
CREATE INDEX IF NOT EXISTS "application_notifications_createdAt_idx" ON "application_notifications" ("createdAt");

-- ScholarshipAward -> scholarship_awards (depends on scholarships, users, application)
CREATE TABLE IF NOT EXISTS "scholarship_awards" (
"id" TEXT PRIMARY KEY,
"awardNumber" TEXT NOT NULL UNIQUE,
"applicationId" TEXT UNIQUE,
"scholarshipId" TEXT NOT NULL,
"recipientName" TEXT NOT NULL,
"recipientEmail" TEXT NOT NULL,
"userId" TEXT,
"amount" DECIMAL(10,2),
"currency" TEXT NOT NULL DEFAULT 'USD',
"startDate" TIMESTAMP(3),
"endDate" TIMESTAMP(3),
"benefits" JSONB,
"acceptanceDeadline" TIMESTAMP(3),
"acceptedAt" TIMESTAMP(3),
"declinedAt" TIMESTAMP(3),
"awardLetterUrl" TEXT,
"certificateUrl" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
"issuedAt" TIMESTAMP(3),
"status" TEXT NOT NULL DEFAULT 'PENDING',
CONSTRAINT "scholarship_awards_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_awards_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_awards_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "application" ("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "scholarship_awards_awardNumber_idx" ON "scholarship_awards" ("awardNumber");
CREATE INDEX IF NOT EXISTS "scholarship_awards_scholarshipId_idx" ON "scholarship_awards" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_awards_recipientEmail_idx" ON "scholarship_awards" ("recipientEmail");
CREATE INDEX IF NOT EXISTS "scholarship_awards_status_idx" ON "scholarship_awards" ("status");

-- ScholarshipEnrollment -> scholarship_enrollments (depends on scholarship_awards, membership, domains, categories, courses, plans, certificates)
CREATE TABLE IF NOT EXISTS "scholarship_enrollments" (
"id" TEXT PRIMARY KEY,
"awardId" TEXT NOT NULL,
"type" TEXT NOT NULL,
"membershipId" TEXT,
"domainId" TEXT,
"categoryId" TEXT,
"courseId" TEXT,
"planId" TEXT,
"certificateId" TEXT,
"status" TEXT NOT NULL DEFAULT 'PENDING',
"durationDays" INTEGER,
"createdAt" TIMESTAMP(3) NOT NULL,
"activatedAt" TIMESTAMP(3),
"expiresAt" TIMESTAMP(3),
CONSTRAINT "scholarship_enrollments_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES "membership" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plans" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_certificateId_fkey" FOREIGN KEY ("certificateId") REFERENCES "certificates" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_enrollments_awardId_fkey" FOREIGN KEY ("awardId") REFERENCES "award" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "scholarship_enrollments_awardId_idx" ON "scholarship_enrollments" ("awardId");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_type_idx" ON "scholarship_enrollments" ("type");
CREATE INDEX IF NOT EXISTS "scholarship_enrollments_status_idx" ON "scholarship_enrollments" ("status");

-- ScholarshipReviewer -> scholarship_reviewers (depends on scholarships, reviewer)
CREATE TABLE IF NOT EXISTS "scholarship_reviewers" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"reviewerId" TEXT,
"reviewerEmail" TEXT NOT NULL,
"reviewerName" TEXT,
"canApprove" BOOLEAN NOT NULL DEFAULT false,
"canReject" BOOLEAN NOT NULL DEFAULT false,
"canScheduleInterview" BOOLEAN NOT NULL DEFAULT false,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"assignedCount" INTEGER NOT NULL DEFAULT 0,
"reviewedCount" INTEGER NOT NULL DEFAULT 0,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_reviewers_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "reviewer" ("id") ON DELETE NO ACTION,
CONSTRAINT "scholarship_reviewers_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_reviewers_scholarshipId_reviewerEmail_key" ON "scholarship_reviewers" ("scholarshipId", "reviewerEmail");
CREATE INDEX IF NOT EXISTS "scholarship_reviewers_scholarshipId_idx" ON "scholarship_reviewers" ("scholarshipId");
CREATE INDEX IF NOT EXISTS "scholarship_reviewers_reviewerId_idx" ON "scholarship_reviewers" ("reviewerId");

-- ScholarshipCustomQuestion -> scholarship_custom_questions (depends on scholarships)
CREATE TABLE IF NOT EXISTS "scholarship_custom_questions" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT NOT NULL,
"question" TEXT NOT NULL,
"questionType" TEXT NOT NULL DEFAULT 'TEXT',
"options" JSONB,
"isRequired" BOOLEAN NOT NULL DEFAULT true,
"order" INTEGER NOT NULL DEFAULT 0,
"validation" JSONB,
"helpText" TEXT,
"placeholder" TEXT,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_custom_questions_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "scholarship_custom_questions_scholarshipId_idx" ON "scholarship_custom_questions" ("scholarshipId");

-- ScholarshipAnalytics -> scholarship_analytics (depends on scholarships)
CREATE TABLE IF NOT EXISTS "scholarship_analytics" (
"id" TEXT PRIMARY KEY,
"scholarshipId" TEXT,
"date" TIMESTAMP(3) NOT NULL,
"views" INTEGER NOT NULL DEFAULT 0,
"applications" INTEGER NOT NULL DEFAULT 0,
"approved" INTEGER NOT NULL DEFAULT 0,
"rejected" INTEGER NOT NULL DEFAULT 0,
"pending" INTEGER NOT NULL DEFAULT 0,
"demographics" JSONB,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "scholarship_analytics_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "scholarships" ("id") ON DELETE NO ACTION
);

CREATE UNIQUE INDEX IF NOT EXISTS "scholarship_analytics_scholarshipId_date_key" ON "scholarship_analytics" ("scholarshipId", "date");
CREATE INDEX IF NOT EXISTS "scholarship_analytics_date_idx" ON "scholarship_analytics" ("date");

-- ScholarshipScoringRubric -> scholarship_scoring_rubrics (depends on nothing)
CREATE TABLE IF NOT EXISTS "scholarship_scoring_rubrics" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL,
"description" TEXT,
"criteria" JSONB NOT NULL,
"totalScore" INTEGER NOT NULL DEFAULT 100,
"passingScore" INTEGER NOT NULL DEFAULT 60,
"isDefault" BOOLEAN NOT NULL DEFAULT false,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- ============================================
-- PHASE 13: RBAC TABLES
-- ============================================

-- Role -> roles (depends on nothing)
CREATE TABLE IF NOT EXISTS "roles" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL UNIQUE,
"displayName" TEXT NOT NULL,
"description" TEXT,
"level" INTEGER NOT NULL DEFAULT 0,
"portal" TEXT NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- Permission -> permissions (depends on nothing)
CREATE TABLE IF NOT EXISTS "permissions" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL UNIQUE,
"category" TEXT NOT NULL,
"description" TEXT,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- RolePermission -> role_permissions (depends on roles, permissions)
CREATE TABLE IF NOT EXISTS "role_permissions" (
"id" TEXT PRIMARY KEY,
"roleId" TEXT NOT NULL,
"permissionId" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles" ("id") ON DELETE CASCADE,
CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "role_permissions_roleId_permissionId_key" ON "role_permissions" ("roleId", "permissionId");

-- UserRole -> user_roles (depends on users, roles)
CREATE TABLE IF NOT EXISTS "user_roles" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"roleId" TEXT NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "user_roles_userId_roleId_key" ON "user_roles" ("userId", "roleId");

-- Policy -> policies (depends on nothing)
CREATE TABLE IF NOT EXISTS "policies" (
"id" TEXT PRIMARY KEY,
"name" TEXT NOT NULL UNIQUE,
"description" TEXT,
"type" TEXT NOT NULL,
"rules" JSONB NOT NULL,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL
);

-- PolicyRule -> policy_rules (depends on policies)
CREATE TABLE IF NOT EXISTS "policy_rules" (
"id" TEXT PRIMARY KEY,
"policyId" TEXT NOT NULL,
"ruleType" TEXT NOT NULL,
"field" TEXT NOT NULL,
"operator" TEXT NOT NULL,
"value" JSONB NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "policy_rules_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies" ("id") ON DELETE CASCADE
);

-- UserPolicy -> user_policies (depends on users, policies, scope)
CREATE TABLE IF NOT EXISTS "user_policies" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"policyId" TEXT NOT NULL,
"scopeId" TEXT,
"isActive" BOOLEAN NOT NULL DEFAULT true,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "user_policies_scopeId_fkey" FOREIGN KEY ("scopeId") REFERENCES "scope" ("id") ON DELETE NO ACTION,
CONSTRAINT "user_policies_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "user_policies_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "policies" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "user_policies_userId_policyId_scopeId_key" ON "user_policies" ("userId", "policyId", "scopeId");

-- PortalAssignment -> portal_assignments (depends on users)
CREATE TABLE IF NOT EXISTS "portal_assignments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL UNIQUE,
"portal" TEXT NOT NULL,
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "portal_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE
);

-- DomainAssignment -> domain_assignments (depends on users, domains)
CREATE TABLE IF NOT EXISTS "domain_assignments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"domainId" TEXT NOT NULL,
"role" TEXT NOT NULL DEFAULT 'HEAD_OF_DOMAIN',
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "domain_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "domain_assignments_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domains" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "domain_assignments_userId_domainId_key" ON "domain_assignments" ("userId", "domainId");

-- CategoryAssignment -> category_assignments (depends on users, categories)
CREATE TABLE IF NOT EXISTS "category_assignments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"categoryId" TEXT NOT NULL,
"role" TEXT NOT NULL DEFAULT 'CATEGORY_LEAD',
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "category_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "category_assignments_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "category_assignments_userId_categoryId_key" ON "category_assignments" ("userId", "categoryId");

-- CourseAssignment -> course_assignments (depends on users, courses)
CREATE TABLE IF NOT EXISTS "course_assignments" (
"id" TEXT PRIMARY KEY,
"userId" TEXT NOT NULL,
"courseId" TEXT NOT NULL,
"role" TEXT NOT NULL DEFAULT 'INSTRUCTOR',
"status" TEXT NOT NULL DEFAULT 'ACTIVE',
"createdAt" TIMESTAMP(3) NOT NULL,
"updatedAt" TIMESTAMP(3) NOT NULL,
CONSTRAINT "course_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE,
CONSTRAINT "course_assignments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses" ("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "course_assignments_userId_courseId_key" ON "course_assignments" ("userId", "courseId");

-- ============================================
-- PHASE 14: FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to auto-update updatedAt timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for auto-updating timestamps on major tables
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at
    BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lessons_updated_at
    BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_materials_updated_at
    BEFORE UPDATE ON materials
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_modules_updated_at
    BEFORE UPDATE ON modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_enrollments_updated_at
    BEFORE UPDATE ON enrollments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_progress_updated_at
    BEFORE UPDATE ON learning_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notifications_updated_at
    BEFORE UPDATE ON notifications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_support_tickets_updated_at
    BEFORE UPDATE ON support_tickets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_instructors_updated_at
    BEFORE UPDATE ON instructors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_paths_updated_at
    BEFORE UPDATE ON learning_paths
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_plans_updated_at
    BEFORE UPDATE ON plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_gateways_updated_at
    BEFORE UPDATE ON payment_gateways
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_coupons_updated_at
    BEFORE UPDATE ON coupons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_invoices_updated_at
    BEFORE UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at
    BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_certificates_updated_at
    BEFORE UPDATE ON certificates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_category_purchases_updated_at
    BEFORE UPDATE ON category_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domain_purchases_updated_at
    BEFORE UPDATE ON domain_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_academy_purchases_updated_at
    BEFORE UPDATE ON academy_purchases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sponsors_updated_at
    BEFORE UPDATE ON sponsors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarships_updated_at
    BEFORE UPDATE ON scholarships
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_applications_updated_at
    BEFORE UPDATE ON scholarship_applications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scholarship_awards_updated_at
    BEFORE UPDATE ON scholarship_awards
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

CREATE TRIGGER update_portal_assignments_updated_at
    BEFORE UPDATE ON portal_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_domain_assignments_updated_at
    BEFORE UPDATE ON domain_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_category_assignments_updated_at
    BEFORE UPDATE ON category_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_assignments_updated_at
    BEFORE UPDATE ON course_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- PHASE 15: ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE "users" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "domains" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "categories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "courses" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "modules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "lessons" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "enrollments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "learning_progress" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "certificates" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notifications" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "subscriptions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "wishlists" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "support_tickets" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "scholarship_applications" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "category_issued_certs" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "domain_issued_certs" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "user_roles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "category_purchases" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "domain_purchases" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "academy_purchases" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "access_licenses" ENABLE ROW LEVEL SECURITY;

-- ============================================
-- COMPLETION
-- ============================================
SELECT 'Schema created successfully!' as status;
