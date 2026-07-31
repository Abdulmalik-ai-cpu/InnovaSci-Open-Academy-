'use client'

import { useSession, signOut } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'
import Link from 'next/link'

export default function AdministrationLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const { data: session, status } = useSession()
  const router = useRouter()

  useEffect(() => {
    if (status === 'unauthenticated') {
      router.push('/auth/login')
    } else if (status === 'authenticated' && session?.user?.portal !== 'ADMINISTRATION') {
      router.push('/forbidden')
    }
  }, [status, session, router])

  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </div>
    )
  }

  if (!session) {
    return null
  }

  const role = session.user?.role || ''
  const roleLabel = role.replace('_', ' ')
  const isSuperAdmin = role === 'SUPER_ADMIN'

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-slate-800 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-8">
              <Link href="/administration" className="text-xl font-bold">
                InnovaSci Open Academy
              </Link>
              <span className="px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                Administration Portal
              </span>
              <span className="px-2 py-1 rounded text-xs font-medium bg-blue-100 text-blue-800">
                {roleLabel}
              </span>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-right">
                <p className="text-sm font-medium">{session.user?.name}</p>
                <p className="text-xs text-gray-300">{session.user?.email}</p>
              </div>
              <button
                onClick={() => signOut({ callbackUrl: '/auth/login' })}
                className="px-4 py-2 text-sm bg-slate-700 hover:bg-slate-600 rounded transition-colors"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Sidebar */}
        <aside className="w-64 bg-slate-900 text-white min-h-screen">
          <nav className="mt-6 px-4 space-y-1">
            <NavItem href="/administration" icon="📊" label="Dashboard" />
            
            {isSuperAdmin && (
              <>
                {/* User Management */}
                <div className="pt-4 pb-2">
                  <p className="px-4 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                    User Management
                  </p>
                </div>
                <NavItem href="/administration/users" icon="👥" label="Users" />
                <NavItem href="/administration/portal" icon="🚪" label="Portal Management" />
              </>
            )}

            {/* System Administration */}
            <div className="pt-4 pb-2">
              <p className="px-4 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                System
              </p>
            </div>
            <NavItem href="/administration/storage" icon="💾" label="Storage" />
            <NavItem href="/administration/database" icon="🗄️" label="Database" />
            <NavItem href="/administration/support" icon="🎧" label="Support Center" />

            {isSuperAdmin && (
              <>
                {/* Platform Settings */}
                <div className="pt-4 pb-2">
                  <p className="px-4 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                    Platform
                  </p>
                </div>
                <NavItem href="/administration/settings" icon="⚙️" label="Settings" />
              </>
            )}
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-8 bg-gray-50">
          {children}
        </main>
      </div>
    </div>
  )
}

function NavItem({ href, icon, label }: { href: string; icon: string; label: string }) {
  return (
    <Link
      href={href}
      className="flex items-center px-4 py-3 text-gray-300 hover:bg-slate-800 hover:text-white rounded-lg transition-colors"
    >
      <span className="mr-3">{icon}</span>
      <span>{label}</span>
    </Link>
  )
}
