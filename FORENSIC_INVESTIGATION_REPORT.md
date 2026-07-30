# InnovaSci Open Academy — Forensic Investigation Report

**Date:** July 30, 2026  
**Project:** InnovaSci Open Academy  
**Repository:** https://github.com/Abdulmalik-hub-Abdulmalik-hub/InnovaSci-Open-Academy-  
**Branch:** main

---

## Executive Summary

This report documents a comprehensive forensic investigation of the InnovaSci Open Academy codebase, revealing a multi-portal architecture with significant complexity. The investigation identified 8+ distinct portals with complex RBAC systems that were subsequently archived, resulting in a simplified student-focused platform.

### Key Findings

| Metric | Value |
|--------|-------|
| Total Portals Identified | 8 |
| Admin Portal Pages | 85 |
| Admin API Routes | 141 |
| Admin Components | ~50 |
| Admin Hooks | ~20 |
| Roles Defined | 15+ |
| LOC Removed | ~51,806 |
| Build Status | ✅ Passing |

---

## Phase 1: Portal Discovery

### All Identified Portals

| Portal Name | Route Group | Status | Primary Layout |
|------------|-------------|--------|----------------|
| Student Portal | `(student)` | ✅ Active | `layout.tsx` |
| Admin Portal | `(dashboard)` | ❌ Archived | `layout.tsx` |
| Marketing Portal | `(marketing)` | ❌ Archived | N/A |
| Public Portal | `(public)` | ❌ Archived | N/A |
| Auth Portal | `auth/` | ✅ Active | N/A |
| Certificate Verification | `(public)/verify` | ❌ Archived | N/A |
| Student Dashboard | `(student)/dashboard` | ✅ Active | N/A |
| Admin Dashboard | `(dashboard)/admin` | ❌ Archived | N/A |

### Portal Details

#### 1. Student Portal
- **Path:** `src/app/(student)/`
- **Pages:** 18
- **Status:** Active
- **Purpose:** Student learning experience

#### 2. Admin Portal (ARCHIVED)
- **Path:** `src/app/(dashboard)/`
- **Pages:** 85
- **Status:** Archived
- **Purpose:** Platform administration

#### 3. Marketing Portal (ARCHIVED)
- **Path:** `src/app/(marketing)/`
- **Pages:** 2
- **Status:** Archived
- **Purpose:** Marketing and course promotion

#### 4. Public Portal (ARCHIVED)
- **Path:** `src/app/(public)/`
- **Pages:** 1
- **Status:** Archived
- **Purpose:** Public verification

---

## Phase 2: Admin Portal Inventory (ARCHIVED)

### All Archived Admin Pages

```
Admin Portal (Archived)
├── analytics/
│   └── page.tsx
├── audit-logs/
│   └── page.tsx
├── categories/
│   └── page.tsx
├── certificates/
│   ├── analytics/
│   ├── categories/
│   ├── domains/
│   ├── settings/
│   ├── templates/
│   ├── verification/
│   └── page.tsx
├── courses/
│   ├── [id]/curriculum/
│   ├── capstones/difficulty/
│   ├── capstones/professional/
│   ├── wizard/
│   └── page.tsx
├── database/
│   └── page.tsx
├── domains/
│   └── page.tsx
├── exchange-rates/
│   └── page.tsx
├── materials/
│   └── page.tsx
├── mccs/courses/
│   └── page.tsx
├── newsletter/
│   └── page.tsx
├── portal-management/
│   └── page.tsx
├── pricing/
│   └── page.tsx
├── projects/
│   ├── [submissionId]/
│   ├── rubrics/
│   └── page.tsx
├── roles/
│   └── page.tsx
├── scholarships/
│   ├── analytics/
│   ├── applications/[id]/
│   ├── awards/
│   ├── create/
│   ├── settings/
│   ├── sponsors/
│   └── page.tsx
├── settings/
│   ├── payment-gateways/
│   └── page.tsx
├── staff-management/
│   ├── staff-create/
│   ├── staff-directory/[id]/
│   ├── staff-directory/
│   └── page.tsx
├── storage/
│   └── page.tsx
├── support/
│   └── page.tsx
├── users/
│   └── page.tsx
├── videos/
│   └── page.tsx
└── layout.tsx
```

---

## Phase 3: Role Mapping

### All Defined Roles

| Role | Purpose | Portal | Status |
|------|---------|--------|--------|
| STUDENT | Default learning platform access | Student | ✅ Active |
| ADMIN | Full platform administration | Archived | ❌ Archived |
| SUPER_ADMIN | System-wide administrative control | Archived | ❌ Archived |
| ACADEMIC_DIRECTOR | Academic program oversight | Archived | ❌ Archived |
| INSTRUCTOR | Course content creation and delivery | Archived | ❌ Archived |
| REVIEWER | Content review and approval | Archived | ❌ Archived |
| PROJECT_SUPERVISOR | Student project supervision | Archived | ❌ Archived |
| FINANCE_OFFICER | Financial operations management | Archived | ❌ Archived |
| ADMISSIONS_OFFICER | Student admissions handling | Archived | ❌ Archived |
| CONTENT_EDITOR | Content creation and management | Archived | ❌ Archived |
| SUPPORT_STAFF | Customer support operations | Archived | ❌ Archived |
| COMMUNITY_MANAGER | Community engagement management | Archived | ❌ Archived |

### Role Sources
- Prisma Schema: `prisma/schema.prisma`
- Constants: `src/lib/permissions.ts` (archived)
- Types: `src/types/` directory
- Middleware: `src/middleware.ts`

---

## Phase 4: Routing Analysis

### Login Redirects (BEFORE)

| Role | Redirect URL | Source File |
|------|-------------|-------------|
| STUDENT | `/dashboard` | auth.ts |
| ADMIN | `/dashboard` | auth.ts |
| SUPER_ADMIN | `/dashboard` | auth.ts |
| INSTRUCTOR | `/dashboard` | auth.ts |
| REVIEWER | `/dashboard` | auth.ts |
| ACADEMIC_DIRECTOR | `/dashboard` | auth.ts |
| PROJECT_SUPERVISOR | `/dashboard` | auth.ts |
| FINANCE_OFFICER | `/dashboard` | auth.ts |
| ADMISSIONS_OFFICER | `/dashboard` | auth.ts |
| CONTENT_EDITOR | `/dashboard` | auth.ts |
| SUPPORT_STAFF | `/dashboard` | auth.ts |
| COMMUNITY_MANAGER | `/dashboard` | auth.ts |

### Login Redirects (AFTER - SIMPLIFIED)

| Role | Redirect URL | Source File |
|------|-------------|-------------|
| All Users | `/dashboard` | auth.ts, middleware.ts |

---

## Phase 5: Duplicate Detection

### Identified Duplicates

| Type | Locations | Resolution |
|------|-----------|------------|
| Admin Portal | `(dashboard)` route group | Archived |
| Dashboard Layouts | `(dashboard)/layout.tsx` | Archived |
| Admin Sidebar | `components/layout/admin-sidebar.tsx` | Archived |
| Multiple Role Definitions | prisma schema, types, constants | Simplified |
| RBAC Systems | `permissions.ts`, `authorize.ts` | Archived |

---

## Phase 6: Authentication Map

### Original Authentication Flow

```
User Login
    ↓
NextAuth Credentials Provider
    ↓
Check Role from Database
    ↓
Role Resolution (permissions.ts, authorize.ts)
    ↓
Middleware Redirect
    ↓
Role-based Portal Redirect
    ├── STUDENT → /dashboard
    ├── ADMIN → /dashboard
    ├── SUPER_ADMIN → /dashboard
    └── ...
```

### Simplified Authentication Flow

```
User Login
    ↓
NextAuth Credentials Provider
    ↓
Session Creation
    ↓
Middleware (simplified)
    ↓
Single Redirect → /dashboard
```

---

## Phase 7: Final Inventory

### SECTION A: Total Number of Portals

**Before:** 8  
**After:** 2 (Student Portal + Auth Portal)

### SECTION B: List of Every Portal

| Portal | Status |
|--------|--------|
| Student Portal | ✅ Active |
| Auth Portal | ✅ Active |
| Admin Portal | ❌ Archived |
| Marketing Portal | ❌ Archived |
| Public Portal | ❌ Archived |

### SECTION C: Total Admin Pages

**Before:** 85  
**After:** 0

### SECTION D: Tree of Every Admin Page

All Admin Portal pages have been archived. No admin pages remain in the active codebase.

### SECTION E: Every Role

| Role | Status |
|------|--------|
| STUDENT | ✅ Active |
| Others (12 roles) | ❌ Archived/Simplified |

### SECTION F: Every Login Redirect

| Condition | Redirect | Status |
|-----------|----------|--------|
| Any authenticated user | `/dashboard` | ✅ Simplified |

### SECTION G: Duplicate Portals

| Original | Archive Location |
|----------|-----------------|
| Admin Portal | `/workspace/_archived_innovasci/admin-portal/pages/` |
| Marketing Portal | `/workspace/_archived_innovasci/admin-portal/pages/` |
| Public Portal | `/workspace/_archived_innovasci/admin-portal/pages/` |

### SECTION H: Legacy Files

All legacy/admin files have been moved to `/workspace/_archived_innovasci/admin-portal/`

### SECTION I: Unused Files

| File | Action |
|------|--------|
| `src/lib/permissions.ts` | Archived |
| `src/lib/authorize.ts` | Archived |
| `src/hooks/useAuth.tsx` | Archived |
| `src/hooks/useDashboard.ts` | Archived |
| `src/hooks/useAnalytics.ts` | Archived |
| `src/hooks/useAuditLogs.ts` | Archived |
| `src/hooks/useDatabaseExplorer.ts` | Archived |
| `src/hooks/useNewsletter.ts` | Archived |
| `src/hooks/usePlans.ts` | Archived |
| `src/hooks/useStorage.ts` | Archived |
| `src/hooks/useUsers.ts` | Archived |
| `src/hooks/useVideos.ts` | Archived |
| `src/components/admin/*` | Archived |
| `src/components/layout/admin-sidebar.tsx` | Archived |

### SECTION J: Recommended Files to Archive (NOT DELETE)

| Directory | Contents |
|-----------|----------|
| `/workspace/_archived_innovasci/admin-portal/pages/` | 85 Admin Portal pages |
| `/workspace/_archived_innovasci/admin-portal/api-routes/` | 141 Admin API routes |
| `/workspace/_archived_innovasci/admin-portal/components/` | Admin UI components |
| `/workspace/_archived_innovasci/admin-portal/hooks/` | Admin hooks |
| `/workspace/_archived_innovasci/admin-portal/lib/` | RBAC systems |

---

## Summary of Changes

### Files Removed
- **168 files changed**
- **~51,806 lines deleted**
- **168 lines added**

### Key Changes

1. **Removed Admin Portal** (85 pages, 141 API routes)
2. **Archived Complex RBAC** (permissions.ts, authorize.ts)
3. **Simplified Authentication** (single redirect to /dashboard)
4. **Cleaned Middleware** (removed role-based redirects)
5. **Preserved Student Portal** (18 pages, fully functional)

### Build Status
✅ **Build Passing** - Project compiles successfully

### Commit
```
feat: Remove Admin Portal infrastructure for student-focused architecture
Commit: 61d750d
Branch: main
```

---

## Recommendations

1. **Database Cleanup**: Remove unused Prisma models (Portal, Role, UserRole, etc.)
2. **Documentation**: Update README with simplified architecture
3. **External Admin Tools**: Consider separate admin tools for content management
4. **Monitoring**: Set up monitoring for student portal usage
5. **Testing**: Implement comprehensive student portal tests

---

## Appendix: Archived File Locations

All archived files are stored in `/workspace/_archived_innovasci/admin-portal/`

```
_archived_innovasci/
└── admin-portal/
    ├── pages/          # 85 Admin Portal pages
    ├── api-routes/     # 141 Admin API routes
    ├── components/     # Admin UI components
    ├── hooks/          # Admin hooks
    ├── lib/            # RBAC systems (permissions.ts, authorize.ts)
    └── LEGACY_STRUCTURE.md  # Original architecture documentation
```

---

*Report Generated: July 30, 2026*
*Project: InnovaSci Open Academy*
