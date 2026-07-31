/**
 * Super Administrator Dashboard
 * 
 * Full platform access dashboard for the Super Administrator role.
 * This role has unrestricted access to all platform features.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export const metadata = {
  title: 'Super Administrator Dashboard - InnovaSci Open Academy',
  description: 'Complete platform management dashboard',
}

export default async function SuperAdminDashboard() {
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
  if (user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Get platform statistics
  const [
    userCount,
    domainCount,
    categoryCount,
    courseCount,
    enrollmentCount,
    certificateCount,
    paymentCount,
    scholarshipCount,
    supportTicketCount,
  ] = await Promise.all([
    prisma.user.count(),
    prisma.domain.count(),
    prisma.category.count(),
    prisma.course.count(),
    prisma.enrollment.count(),
    prisma.issuedCertificate.count(),
    prisma.payment.count(),
    prisma.scholarship.count(),
    prisma.supportTicket.count(),
  ])

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h1 className="text-2xl font-bold text-gray-900">Super Administrator Dashboard</h1>
        <p className="mt-1 text-gray-600">Complete platform overview and management</p>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Users"
          value={userCount}
          icon="users"
          color="blue"
          href="/governance/super-admin/users"
        />
        <StatCard
          title="Domains"
          value={domainCount}
          icon="globe"
          color="green"
          href="/governance/super-admin/domains"
        />
        <StatCard
          title="Categories"
          value={categoryCount}
          icon="folder"
          color="purple"
          href="/governance/super-admin/categories"
        />
        <StatCard
          title="Courses"
          value={courseCount}
          icon="book"
          color="orange"
          href="/governance/super-admin/courses"
        />
      </div>

      {/* Business Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <StatCard
          title="Enrollments"
          value={enrollmentCount}
          icon="user-check"
          color="teal"
        />
        <StatCard
          title="Certificates Issued"
          value={certificateCount}
          icon="award"
          color="gold"
        />
        <StatCard
          title="Payments"
          value={paymentCount}
          icon="credit-card"
          color="green"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction
            title="Add User"
            icon="user-plus"
            href="/governance/super-admin/users/create"
          />
          <QuickAction
            title="Create Domain"
            icon="globe"
            href="/governance/super-admin/domains/create"
          />
          <QuickAction
            title="Create Course"
            icon="book-open"
            href="/governance/super-admin/courses/create"
          />
          <QuickAction
            title="View Analytics"
            icon="chart"
            href="/governance/super-admin/analytics"
          />
          <QuickAction
            title="Manage Roles"
            icon="shield"
            href="/governance/super-admin/roles"
          />
          <QuickAction
            title="View Logs"
            icon="clipboard"
            href="/governance/super-admin/audit-logs"
          />
          <QuickAction
            title="System Settings"
            icon="settings"
            href="/governance/super-admin/settings"
          />
          <QuickAction
            title="Database"
            icon="database"
            href="/governance/super-admin/database"
          />
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Support Tickets</h2>
        <RecentTickets />
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
}: {
  title: string
  icon: string
  href: string
}) {
  return (
    <a
      href={href}
      className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
    >
      <span className="text-2xl mb-2">⚡</span>
      <span className="text-sm font-medium text-gray-900 text-center">{title}</span>
    </a>
  )
}

// Recent Tickets Component
async function RecentTickets() {
  const tickets = await prisma.supportTicket.findMany({
    take: 5,
    orderBy: { createdAt: 'desc' },
    include: {
      user: {
        include: {
          profile: true,
        },
      },
    },
  })

  if (tickets.length === 0) {
    return <p className="text-gray-500 text-center py-4">No recent support tickets</p>
  }

  return (
    <div className="space-y-3">
      {tickets.map((ticket) => (
        <div
          key={ticket.id}
          className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div>
            <p className="font-medium text-gray-900">{ticket.subject}</p>
            <p className="text-sm text-gray-500">
              {ticket.user?.profile?.fullName || ticket.user?.email}
            </p>
          </div>
          <span
            className={`px-2 py-1 rounded text-xs font-medium ${
              ticket.status === 'OPEN'
                ? 'bg-blue-100 text-blue-800'
                : ticket.status === 'RESOLVED'
                ? 'bg-green-100 text-green-800'
                : 'bg-gray-100 text-gray-800'
            }`}
          >
            {ticket.status}
          </span>
        </div>
      ))}
    </div>
  )
}
