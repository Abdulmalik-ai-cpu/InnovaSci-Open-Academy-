'use client'

import { useSession, signOut } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'
import Link from 'next/link'

export default function AcademicLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const { data: session, status } = useSession()
  const router = useRouter()

  useEffect(() => {
    if (status === 'unauthenticated') {
      router.push('/auth/login')
    } else if (status === 'authenticated' && session?.user?.portal !== 'ACADEMIC') {
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

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-8">
              <Link href="/academic" className="text-xl font-bold text-gray-900">
                InnovaSci Open Academy
              </Link>
              <span className="px-3 py-1 rounded-full text-sm font-medium bg-purple-100 text-purple-800">
                Academic Portal
              </span>
              <span className="px-2 py-1 rounded text-xs font-medium bg-blue-100 text-blue-800">
                {roleLabel}
              </span>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">{session.user?.name}</p>
                <p className="text-xs text-gray-500">{session.user?.email}</p>
              </div>
              <button
                onClick={() => signOut({ callbackUrl: '/auth/login' })}
                className="px-4 py-2 text-sm text-gray-700 hover:text-gray-900"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Sidebar */}
        <aside className="w-64 bg-white border-r border-gray-200 min-h-screen">
          <nav className="mt-6 px-4 space-y-1">
            <NavItem href="/academic" icon="📊" label="Dashboard" />
            
            {/* Domains Section */}
            <div className="pt-4 pb-2">
              <p className="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                Academic Structure
              </p>
            </div>
            <NavItem href="/academic/domains" icon="🌐" label="Domains" />
            <NavItem href="/academic/categories" icon="📁" label="Categories" />
            <NavItem href="/academic/courses" icon="📚" label="Courses" />
            
            {/* Content Section */}
            <div className="pt-4 pb-2">
              <p className="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                Content
              </p>
            </div>
            <NavItem href="/academic/certificates" icon="🏆" label="Certificates" />
            
            {/* Analytics Section */}
            <div className="pt-4 pb-2">
              <p className="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                Analytics
              </p>
            </div>
            <NavItem href="/academic/analytics" icon="📈" label="Analytics" />
            
            {/* Settings Section */}
            <div className="pt-4 pb-2">
              <p className="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                Settings
              </p>
            </div>
            <NavItem href="/academic/settings" icon="⚙️" label="Settings" />
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-8">
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
      className="flex items-center px-4 py-3 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
    >
      <span className="mr-3">{icon}</span>
      <span>{label}</span>
    </Link>
  )
}
