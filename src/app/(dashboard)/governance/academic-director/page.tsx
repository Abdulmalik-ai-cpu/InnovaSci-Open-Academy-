/**
 * Academic Director Dashboard
 * 
 * Academic governance dashboard for the Academic Director role.
 * This role has authority over all academic activities and staff.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export const metadata = {
  title: 'Academic Director Dashboard - InnovaSci Open Academy',
  description: 'Academic governance and management',
}

export default async function AcademicDirectorDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // Get user with staff profile
  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
    include: {
      staffProfile: true,
    },
  })

  // Verify role
  if (user?.staffProfile?.governanceRole !== Role.ACADEMIC_DIRECTOR && 
      user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Get academic statistics
  const [
    domainCount,
    categoryCount,
    courseCount,
    instructorCount,
    studentCount,
    enrollmentCount,
    certificateCount,
    pendingApprovals,
  ] = await Promise.all([
    prisma.domain.count(),
    prisma.category.count(),
    prisma.course.count(),
    prisma.staffProfile.count({ where: { governanceRole: Role.INSTRUCTOR } }),
    prisma.user.count({ where: { role: Role.STUDENT } }),
    prisma.enrollment.count(),
    prisma.issuedCertificate.count(),
    prisma.course.count({ where: { status: 'draft' } }), // Pending approval
  ])

  // Get recent capstone projects needing review
  const pendingCapstones = await prisma.projectSubmission.count({
    where: {
      projectType: { in: ['DIFFICULTY_CAPSTONE', 'PROFESSIONAL_CAPSTONE'] },
      status: 'SUBMITTED',
    },
  })

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h1 className="text-2xl font-bold text-gray-900">Academic Director Dashboard</h1>
        <p className="mt-1 text-gray-600">Governance overview for academic operations</p>
      </div>

      {/* Pending Approvals Alert */}
      {(pendingApprovals > 0 || pendingCapstones > 0) && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <div className="flex items-center">
            <span className="text-2xl mr-3">⚠️</span>
            <div>
              <h3 className="font-semibold text-yellow-800">Pending Approvals</h3>
              <p className="text-sm text-yellow-700">
                You have {pendingApprovals + pendingCapstones} items requiring your approval
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Academic Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          title="Domains"
          value={domainCount}
          icon="globe"
          color="blue"
          href="/governance/academic-director/domains"
        />
        <StatCard
          title="Categories"
          value={categoryCount}
          icon="folder"
          color="green"
          href="/governance/academic-director/categories"
        />
        <StatCard
          title="Courses"
          value={courseCount}
          icon="book"
          color="purple"
          href="/governance/academic-director/courses"
        />
        <StatCard
          title="Instructors"
          value={instructorCount}
          icon="user"
          color="orange"
          href="/governance/academic-director/instructors"
        />
      </div>

      {/* Engagement Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <StatCard
          title="Students"
          value={studentCount}
          icon="users"
          color="teal"
          href="/governance/academic-director/students"
        />
        <StatCard
          title="Enrollments"
          value={enrollmentCount}
          icon="user-check"
          color="blue"
        />
        <StatCard
          title="Certificates"
          value={certificateCount}
          icon="award"
          color="gold"
          href="/governance/academic-director/certificates"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Academic Management</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction
            title="Review Domains"
            icon="globe"
            href="/governance/academic-director/domains"
            badge={domainCount > 0 ? 'Review' : undefined}
          />
          <QuickAction
            title="Review Categories"
            icon="folder"
            href="/governance/academic-director/categories"
          />
          <QuickAction
            title="Course Approvals"
            icon="check-circle"
            href="/governance/academic-director/course-approvals"
            badge={pendingApprovals > 0 ? `${pendingApprovals}` : undefined}
          />
          <QuickAction
            title="Capstone Review"
            icon="capstone"
            href="/governance/academic-director/capstones"
            badge={pendingCapstones > 0 ? `${pendingCapstones}` : undefined}
          />
          <QuickAction
            title="Manage Instructors"
            icon="users"
            href="/governance/academic-director/instructors"
          />
          <QuickAction
            title="Student Overview"
            icon="graduation"
            href="/governance/academic-director/students"
          />
          <QuickAction
            title="Learning Paths"
            icon="route"
            href="/governance/academic-director/learning-paths"
          />
          <QuickAction
            title="Analytics"
            icon="chart"
            href="/governance/academic-director/analytics"
          />
        </div>
      </div>

      {/* Academic Staff Overview */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Academic Staff</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <StaffCard
            title="Head of Domains"
            count={await prisma.staffProfile.count({ where: { governanceRole: Role.HEAD_OF_DOMAIN } })}
            href="/governance/academic-director/head-of-domains"
          />
          <StaffCard
            title="Category Leads"
            count={await prisma.staffProfile.count({ where: { governanceRole: Role.CATEGORY_LEAD } })}
            href="/governance/academic-director/category-leads"
          />
          <StaffCard
            title="Instructors"
            count={instructorCount}
            href="/governance/academic-director/instructors"
          />
        </div>
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

// Staff Card Component
function StaffCard({
  title,
  count,
  href,
}: {
  title: string
  count: number
  href: string
}) {
  return (
    <a
      href={href}
      className="bg-gray-50 rounded-lg p-4 hover:bg-gray-100 transition-colors"
    >
      <p className="text-sm text-gray-600">{title}</p>
      <p className="text-2xl font-bold text-gray-900 mt-1">{count}</p>
    </a>
  )
}
