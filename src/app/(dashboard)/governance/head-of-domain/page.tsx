/**
 * Head of Domain Dashboard
 * 
 * Domain-specific dashboard for the Head of Domain role.
 * This role manages ONLY the assigned domain and its categories.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export const metadata = {
  title: 'Head of Domain Dashboard - InnovaSci Open Academy',
  description: 'Domain-specific academic management',
}

export default async function HeadOfDomainDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // Get user with staff profile and domain assignment
  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
    include: {
      staffProfile: {
        include: {
          domainAssignments: {
            where: { status: 'ACTIVE' },
            include: { domain: true },
          },
        },
      },
    },
  })

  // Verify role
  if (user?.staffProfile?.governanceRole !== Role.HEAD_OF_DOMAIN && 
      user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN &&
      user?.staffProfile?.governanceRole !== Role.ACADEMIC_DIRECTOR) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Get assigned domain
  const assignedDomain = user?.staffProfile?.domainAssignments?.[0]?.domain

  if (!assignedDomain) {
    return (
      <div className="space-y-6">
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <p className="text-yellow-800">
            ⚠️ No domain assigned. Please contact an administrator to assign a domain to your profile.
          </p>
        </div>
      </div>
    )
  }

  // Get domain-specific statistics
  const [
    categoryCount,
    courseCount,
    categoryLeadCount,
    instructorCount,
    enrollmentCount,
    capstoneCount,
  ] = await Promise.all([
    prisma.category.count({ where: { domainId: assignedDomain.id } }),
    prisma.course.count({ 
      where: { category: { domainId: assignedDomain.id } } 
    }),
    prisma.staffProfile.count({ 
      where: { 
        governanceRole: Role.CATEGORY_LEAD,
        categoryAssignments: {
          some: {
            category: { domainId: assignedDomain.id },
            status: 'ACTIVE',
          },
        },
      },
    }),
    prisma.staffProfile.count({ 
      where: { 
        governanceRole: Role.INSTRUCTOR,
        courseAssignments: {
          some: {
            course: { category: { domainId: assignedDomain.id } },
            status: 'ACTIVE',
          },
        },
      },
    }),
    prisma.enrollment.count({
      where: {
        course: { category: { domainId: assignedDomain.id } },
      },
    }),
    prisma.projectSubmission.count({
      where: {
        capstoneType: 'professional',
        course: { category: { domainId: assignedDomain.id } },
        status: 'SUBMITTED',
      },
    }),
  ])

  // Get unique student count
  const studentGroups = await prisma.enrollment.groupBy({
    by: ['userId'],
    where: {
      course: { category: { domainId: assignedDomain.id } },
    },
  })
  const studentCount = studentGroups.length

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Head of Domain Dashboard</h1>
            <p className="mt-1 text-gray-600">
              Managing: <span className="font-semibold text-blue-600">{assignedDomain.name}</span>
            </p>
          </div>
          <span className="px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
            {assignedDomain.status}
          </span>
        </div>
      </div>

      {/* Pending Capstone Review Alert */}
      {capstoneCount > 0 && (
        <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <span className="text-2xl mr-3">🎓</span>
              <div>
                <h3 className="font-semibold text-purple-800">Professional Capstone Projects</h3>
                <p className="text-sm text-purple-700">
                  {capstoneCount} capstone project(s) awaiting your review
                </p>
              </div>
            </div>
            <a
              href="/governance/head-of-domain/capstones"
              className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700"
            >
              Review Now
            </a>
          </div>
        </div>
      )}

      {/* Domain Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          title="Categories"
          value={categoryCount}
          icon="folder"
          color="blue"
          href="/governance/head-of-domain/categories"
        />
        <StatCard
          title="Courses"
          value={courseCount}
          icon="book"
          color="green"
          href="/governance/head-of-domain/courses"
        />
        <StatCard
          title="Category Leads"
          value={categoryLeadCount}
          icon="user"
          color="purple"
          href="/governance/head-of-domain/category-leads"
        />
        <StatCard
          title="Instructors"
          value={instructorCount}
          icon="users"
          color="orange"
          href="/governance/head-of-domain/instructors"
        />
      </div>

      {/* Engagement Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <StatCard
          title="Active Students"
          value={studentCount}
          icon="graduation"
          color="teal"
          href="/governance/head-of-domain/students"
        />
        <StatCard
          title="Total Enrollments"
          value={enrollmentCount}
          icon="user-check"
          color="blue"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Domain Management</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction
            title="My Domain"
            icon="globe"
            href="/governance/head-of-domain/my-domain"
          />
          <QuickAction
            title="Categories"
            icon="folder"
            href="/governance/head-of-domain/categories"
          />
          <QuickAction
            title="Courses"
            icon="book"
            href="/governance/head-of-domain/courses"
          />
          <QuickAction
            title="Capstone Review"
            icon="capstone"
            href="/governance/head-of-domain/capstones"
            badge={capstoneCount > 0 ? `${capstoneCount}` : undefined}
          />
          <QuickAction
            title="Category Leads"
            icon="users"
            href="/governance/head-of-domain/category-leads"
          />
          <QuickAction
            title="Instructors"
            icon="user"
            href="/governance/head-of-domain/instructors"
          />
          <QuickAction
            title="Students"
            icon="graduation"
            href="/governance/head-of-domain/students"
          />
          <QuickAction
            title="Analytics"
            icon="chart"
            href="/governance/head-of-domain/analytics"
          />
        </div>
      </div>

      {/* Domain Categories */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Domain Categories</h2>
          <a
            href="/governance/head-of-domain/categories"
            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
          >
            View All →
          </a>
        </div>
        <DomainCategories domainId={assignedDomain.id} />
      </div>
    </div>
  )
}

// Stat Card Component
function StatCard({
  title,
  value,
  icon,
  color,
  href,
}: {
  title: string
  value: number
  icon: string
  color: string
  href?: string
}) {
  const colorClasses: Record<string, string> = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
    teal: 'bg-teal-100 text-teal-600',
    gold: 'bg-yellow-100 text-yellow-600',
  }

  const content = (
    <div className="bg-white rounded-lg shadow-sm p-6 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{value.toLocaleString()}</p>
        </div>
        <div className={`p-3 rounded-full ${colorClasses[color]}`}>
          <span className="text-xl">📊</span>
        </div>
      </div>
    </div>
  )

  if (href) {
    return <a href={href}>{content}</a>
  }

  return content
}

// Quick Action Component
function QuickAction({
  title,
  icon,
  href,
  badge,
}: {
  title: string
  icon: string
  href: string
  badge?: string
}) {
  return (
    <a
      href={href}
      className="relative flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
    >
      {badge && (
        <span className="absolute top-2 right-2 px-2 py-0.5 text-xs font-medium bg-red-500 text-white rounded-full">
          {badge}
        </span>
      )}
      <span className="text-2xl mb-2">⚡</span>
      <span className="text-sm font-medium text-gray-900 text-center">{title}</span>
    </a>
  )
}

// Domain Categories Component
async function DomainCategories({ domainId }: { domainId: string }) {
  const categories = await prisma.category.findMany({
    where: { domainId },
    take: 5,
    include: {
      _count: {
        select: { courses: true },
      },
    },
    orderBy: { orderIndex: 'asc' },
  })

  if (categories.length === 0) {
    return <p className="text-gray-500 text-center py-4">No categories in this domain</p>
  }

  return (
    <div className="space-y-3">
      {categories.map((category) => (
        <div
          key={category.id}
          className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div className="flex items-center">
            <span className="text-2xl mr-3">{category.icon || '📁'}</span>
            <div>
              <p className="font-medium text-gray-900">{category.name}</p>
              <p className="text-sm text-gray-500">{category._count.courses} courses</p>
            </div>
          </div>
          <span
            className={`px-2 py-1 rounded text-xs font-medium ${
              category.isActive
                ? 'bg-green-100 text-green-800'
                : 'bg-gray-100 text-gray-800'
            }`}
          >
            {category.isActive ? 'Active' : 'Inactive'}
          </span>
        </div>
      ))}
    </div>
  )
}
