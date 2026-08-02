#!/bin/bash
# =============================================================================
# InnovaSci Open Academy - Database Setup Script
# =============================================================================
# This script performs a complete database initialization:
# 1. Applies the initial schema SQL file
# 2. Runs all Prisma migrations
# 3. Seeds the database with initial data
#
# Usage: npm run db:setup
# =============================================================================

set -e  # Exit on any error

# Load environment variables from .env file
if [ -f .env ]; then
    set -a  # Auto-export variables
    source .env
    set +a
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    log_error "DATABASE_URL environment variable is not set!"
    log_info "Please set DATABASE_URL in your .env file or environment"
    exit 1
fi

# Parse DATABASE_URL to extract connection parameters
# Format: postgresql://user:password@host:port/dbname
DB_URL="$DATABASE_URL"
DB_USER=$(echo "$DB_URL" | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
DB_PASSWORD=$(echo "$DB_URL" | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')
DB_HOST=$(echo "$DB_URL" | sed -n 's/.*@\([^:]*\):.*/\1/p')
DB_PORT=$(echo "$DB_URL" | sed -n 's/.*:[0-9]*\/\([^?]*\).*/\1/p' | sed 's/.*:\([0-9]*\)$/\1/; s/[^0-9]//g')
DB_NAME=$(echo "$DB_URL" | sed -n 's/.*\/\([^?]*\).*/\1/p')

# Fallback port if not specified
if [ -z "$DB_PORT" ]; then
    DB_PORT="5432"
fi

export PGPASSWORD="$DB_PASSWORD"

log_info "=============================================="
log_info "InnovaSci Open Academy - Database Setup"
log_info "=============================================="
log_info "Host: $DB_HOST:$DB_PORT"
log_info "Database: $DB_NAME"
log_info "User: $DB_USER"
echo ""

# =============================================================================
# Step 1: Apply initial schema
# =============================================================================
log_info "Step 1/4: Applying initial schema..."
if [ -f "prisma/migrations/001_initial_schema.sql" ]; then
    PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" -f prisma/migrations/001_initial_schema.sql > /dev/null 2>&1
    log_success "Initial schema applied successfully"
else
    log_warning "Initial schema file not found, skipping..."
fi

# =============================================================================
# Step 2: Run Prisma migrations
# =============================================================================
log_info "Step 2/4: Running Prisma migrations..."

# Clean up any failed migrations from previous runs
PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" << 'CLEANSQL' > /dev/null 2>&1 || true
-- Remove any failed migrations so they can be re-run
DELETE FROM "_prisma_migrations" WHERE finished_at IS NULL;
DELETE FROM "_prisma_migrations" WHERE migration_name = '006_fix_schema_consistency' AND (
    SELECT COUNT(*) FROM "_prisma_migrations" WHERE migration_name = '006_fix_schema_consistency'
) > 1;
-- Remove duplicates
DELETE FROM "_prisma_migrations" a USING "_prisma_migrations" b
WHERE a.ctid < b.ctid AND a.migration_name = b.migration_name;
CLEANSQL

npx prisma migrate deploy
log_success "Migrations applied successfully"

# =============================================================================
# Step 3: Fix any schema inconsistencies
# =============================================================================
log_info "Step 3/4: Applying additional schema fixes..."

# Fix system_settings table columns
PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" << 'FIXSQL' > /dev/null 2>&1 || true
-- Fix system_settings columns
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS category VARCHAR(100) DEFAULT 'general';
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS validation JSONB;
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'system_settings' AND column_name = 'isPublic'
    ) THEN
        ALTER TABLE system_settings ADD COLUMN "isPublic" BOOLEAN DEFAULT false;
    END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'system_settings' AND column_name = 'isEncrypted'
    ) THEN
        ALTER TABLE system_settings ADD COLUMN "isEncrypted" BOOLEAN DEFAULT false;
    END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- Fix users table emailVerified column (handle both boolean and missing cases)
DO $$
DECLARE
    col_exists BOOLEAN;
    col_type TEXT;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'users' AND column_name = 'emailVerified'
    ) INTO col_exists;
    
    IF NOT col_exists THEN
        -- Check for lowercase version
        SELECT data_type INTO col_type FROM information_schema.columns
        WHERE table_name = 'users' AND column_name = 'emailverified';
        
        IF col_type = 'boolean' THEN
            ALTER TABLE users DROP COLUMN IF EXISTS "emailVerified";
            ALTER TABLE users ADD COLUMN "emailVerified" TIMESTAMP;
        ELSE
            ALTER TABLE users ADD COLUMN "emailVerified" TIMESTAMP;
        END IF;
    END IF;
EXCEPTION WHEN OTHERS THEN
    -- If column doesn't exist at all, create it
    ALTER TABLE users ADD COLUMN IF NOT EXISTS "emailVerified" TIMESTAMP;
END $$;

-- Fix courses table columns
ALTER TABLE courses ADD COLUMN IF NOT EXISTS "instructorId" TEXT;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS "whatYouWillLearn" JSONB;
ALTER TABLE courses ADD COLUMN IF NOT EXISTS "requirements" JSONB;
FIXSQL

# Apply RBAC tables
log_info "  Applying RBAC tables..."
PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" -f prisma/migrations/rbac_tables.sql 2>&1 || log_warning "  RBAC tables may already exist"

log_success "Schema fixes applied"

# =============================================================================
# Step 4: Seed the database
# =============================================================================
log_info "Step 4/4: Seeding database..."
npm run db:seed-all
log_success "Database seeded successfully"

# =============================================================================
# Summary
# =============================================================================
echo ""
log_success "=============================================="
log_success "Database setup completed successfully!"
log_success "=============================================="
log_info ""
log_info "You can now start the application with:"
log_info "  npm run dev"
log_info ""
log_info "For production, use:"
log_info "  npm run build && npm start"
log_info ""
