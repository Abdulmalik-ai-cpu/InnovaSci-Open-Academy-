import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { ROLES } from '@/lib/rbac/roles'

export default async function AdministrationDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    redirect('/auth/login')
  }

  // Verify user is in Administration portal
  if (session.user.portal !== 'ADMINISTRATION') {
    redirect('/forbidden')
  }

  const userRole = session.user.role as string
  const isSuperAdmin = userRole === ROLES.SUPER_ADMIN

  // Get platform statistics
  const [
    totalUsers,
    totalDomains,
    totalCategories,
    totalCourses,
    totalEnrollments,
    totalPayments,
    supportTickets,
  ] = await Promise.all([
    prisma.user.count(),
    prisma.domain.count(),
    prisma.category.count(),
    prisma.course.count(),
    prisma.enrollment.count(),
    prisma.payment.count(),
    prisma.supportTicket.count({ where: { status: 'OPEN' } }),
  ])

  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Administration Dashboard</h1>
        <p className="mt-1 text-gray-600">
          Welcome back, {session.user.name} • {userRole.replace('_', ' ')}
        </p>
      </div>

      {/* System Status */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">System Status</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatusCard title="Application" status="operational" uptime="99.9%" />
          <StatusCard title="Database" status="operational" uptime="99.99%" />
          <StatusCard title="API" status="operational" uptime="99.5%" />
          <StatusCard title="Storage" status="operational" uptime="100%" />
        </div>
      </div>

      {/* Platform Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          title="Total Users"
          value={totalUsers}
          icon="👥"
          color="blue"
        />
        <StatCard
          title="Domains"
          value={totalDomains}
          icon="🌐"
          color="green"
        />
        <StatCard
          title="Categories"
          value={totalCategories}
          icon="📁"
          color="purple"
        />
        <StatCard
          title="Courses"
          value={totalCourses}
          icon="📚"
          color="orange"
        />
      </div>

      {/* Business Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard
          title="Enrollments"
          value={totalEnrollments}
          icon="✅"
          color="teal"
        />
        <StatCard
          title="Payments"
          value={totalPayments}
          icon="💳"
          color="green"
        />
        <StatCard
          title="Support Tickets"
          value={supportTickets}
          icon="🎧"
          color="red"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
          {isSuperAdmin && (
            <>
              <QuickAction href="/administration/users" icon="👥" label="Users" />
              <QuickAction href="/administration/portal" icon="🚪" label="Portal" />
            </>
          )}
          <QuickAction href="/administration/storage" icon="💾" label="Storage" />
          <QuickAction href="/administration/database" icon="🗄️" label="Database" />
          <QuickAction href="/administration/support" icon="🎧" label="Support" />
          {isSuperAdmin && (
            <QuickAction href="/administration/settings" icon="⚙️" label="Settings" />
          )}
        </div>
      </div>

      {/* System Tools */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">System Tools</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {isSuperAdmin ? (
            <>
              <ToolCard
                title="User Management"
                description="Manage all platform users, roles, and permissions"
                href="/administration/users"
                icon="👥"
              />
              <ToolCard
                title="Portal Management"
                description="Configure portal settings and access controls"
                href="/administration/portal"
                icon="🚪"
              />
              <ToolCard
                title="Storage Manager"
                description="Manage file storage and uploads"
                href="/administration/storage"
                icon="💾"
              />
              <ToolCard
                title="Database Explorer"
                description="View and manage database records"
                href="/administration/database"
                icon="🗄️"
              />
              <ToolCard
                title="Support Center"
                description="Manage support tickets and user requests"
                href="/administration/support"
                icon="🎧"
              />
              <ToolCard
                title="Platform Settings"
                description="Configure global platform settings"
                href="/administration/settings"
                icon="⚙️"
              />
            </>
          ) : (
            <>
              <ToolCard
                title="Storage Manager"
                description="Manage file storage and uploads"
                href="/administration/storage"
                icon="💾"
              />
              <ToolCard
                title="Database Explorer"
                description="View and manage database records"
                href="/administration/database"
                icon="🗄️"
              />
              <ToolCard
                title="Support Center"
                description="Manage support tickets and user requests"
                href="/administration/support"
                icon="🎧"
              />
            </>
          )}
        </div>
      </div>
    </div>
  )
}

function StatusCard({ title, status, uptime }: { title: string; status: string; uptime: string }) {
  const statusColors: Record<string, string> = {
    operational: 'bg-green-100 text-green-800',
    degraded: 'bg-yellow-100 text-yellow-800',
    outage: 'bg-red-100 text-red-800',
  }

  return (
    <div className="p-4 bg-gray-50 rounded-lg">
      <p className="text-sm text-gray-600">{title}</p>
      <p className={`text-xs font-medium px-2 py-1 rounded mt-1 inline-block ${statusColors[status]}`}>
        {status.toUpperCase()}
      </p>
      <p className="text-lg font-bold text-gray-900 mt-2">{uptime}</p>
      <p className="text-xs text-gray-500">Uptime</p>
    </div>
  )
}

function StatCard({ title, value, icon, color }: { title: string; value: number; icon: string; color: string }) {
  const colorClasses: Record<string, string> = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
    teal: 'bg-teal-100 text-teal-600',
    red: 'bg-red-100 text-red-600',
  }

  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{value.toLocaleString()}</p>
        </div>
        <div className={`p-3 rounded-full ${colorClasses[color]}`}>
          <span className="text-xl">{icon}</span>
        </div>
      </div>
    </div>
  )
}

function QuickAction({ href, icon, label }: { href: string; icon: string; label: string }) {
  return (
    <a
      href={href}
      className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
    >
      <span className="text-2xl mb-2">{icon}</span>
      <span className="text-sm font-medium text-gray-900">{label}</span>
    </a>
  )
}

function ToolCard({ title, description, href, icon }: { title: string; description: string; href: string; icon: string }) {
  return (
    <a
      href={href}
      className="block p-4 border border-gray-200 rounded-lg hover:shadow-md hover:border-blue-300 transition-all"
    >
      <div className="flex items-center mb-2">
        <span className="text-2xl mr-2">{icon}</span>
        <h3 className="font-medium text-gray-900">{title}</h3>
      </div>
      <p className="text-sm text-gray-500">{description}</p>
    </a>
  )
}
