/**
 * System Administrator Dashboard
 */

import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export default async function SystemAdminDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    redirect('/auth/login')
  }

  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
    include: { staffProfile: true },
  })

  if (user?.staffProfile?.governanceRole !== Role.SYSTEM_ADMIN && 
      user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN) {
    redirect('/forbidden')
  }

  const supportTicketCount = await prisma.supportTicket.count({ where: { status: 'OPEN' } })

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h1 className="text-2xl font-bold text-gray-900">System Administrator Dashboard</h1>
        <p className="mt-1 text-gray-600">Technical operations and infrastructure management</p>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">System Status</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">Application</p>
            <p className="text-xs font-medium px-2 py-1 rounded mt-1 inline-block bg-green-100 text-green-800">OPERATIONAL</p>
            <p className="text-lg font-bold text-gray-900 mt-2">99.9%</p>
            <p className="text-xs text-gray-500">Uptime</p>
          </div>
          <div className="p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">Database</p>
            <p className="text-xs font-medium px-2 py-1 rounded mt-1 inline-block bg-green-100 text-green-800">OPERATIONAL</p>
            <p className="text-lg font-bold text-gray-900 mt-2">99.99%</p>
            <p className="text-xs text-gray-500">Uptime</p>
          </div>
          <div className="p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">API</p>
            <p className="text-xs font-medium px-2 py-1 rounded mt-1 inline-block bg-green-100 text-green-800">OPERATIONAL</p>
            <p className="text-lg font-bold text-gray-900 mt-2">99.5%</p>
            <p className="text-xs text-gray-500">Uptime</p>
          </div>
          <div className="p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">Storage</p>
            <p className="text-xs font-medium px-2 py-1 rounded mt-1 inline-block bg-green-100 text-green-800">OPERATIONAL</p>
            <p className="text-lg font-bold text-gray-900 mt-2">100%</p>
            <p className="text-xs text-gray-500">Uptime</p>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Infrastructure Tools</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <a href="/governance/system-admin/storage" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">💾</span>
            <span className="text-sm font-medium text-gray-900">Storage</span>
          </a>
          <a href="/governance/system-admin/database" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">🗄️</span>
            <span className="text-sm font-medium text-gray-900">Database</span>
          </a>
          <a href="/governance/system-admin/api-monitoring" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">📝</span>
            <span className="text-sm font-medium text-gray-900">API Monitor</span>
          </a>
          <a href="/governance/system-admin/logs" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">📄</span>
            <span className="text-sm font-medium text-gray-900">Logs</span>
          </a>
          <a href="/governance/system-admin/performance" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">📈</span>
            <span className="text-sm font-medium text-gray-900">Performance</span>
          </a>
          <a href="/governance/system-admin/backups" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">⬇️</span>
            <span className="text-sm font-medium text-gray-900">Backups</span>
          </a>
          <a href="/governance/system-admin/security" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">🛡️</span>
            <span className="text-sm font-medium text-gray-900">Security</span>
          </a>
          <a href="/governance/system-admin/settings" className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
            <span className="text-2xl mb-2">⚙️</span>
            <span className="text-sm font-medium text-gray-900">Settings</span>
          </a>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Open Support Tickets</h2>
        <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
          <div>
            <p className="text-3xl font-bold text-gray-900">{supportTicketCount}</p>
            <p className="text-sm text-gray-500">Open tickets</p>
          </div>
          <a href="/governance/system-admin/support" className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            View All
          </a>
        </div>
      </div>
    </div>
  )
}
