'use client'

import { useSession, signOut } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'
import Link from 'next/link'

export default function InstructorLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const { data: session, status } = useSession()
  const router = useRouter()

  useEffect(() => {
    if (status === 'unauthenticated') {
      router.push('/auth/login')
    } else if (status === 'authenticated' && session?.user?.portal !== 'INSTRUCTOR') {
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

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-8">
              <Link href="/instructor" className="text-xl font-bold text-gray-900">
                InnovaSci Open Academy
              </Link>
              <span className="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                Instructor Portal
              </span>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">{session.user?.name}</p>
                <p className="text-xs text-gray-500">{session.user?.role}</p>
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
            <NavItem href="/instructor" icon="📊" label="Dashboard" />
            <NavItem href="/instructor/courses" icon="📚" label="My Courses" />
            <NavItem href="/instructor/students" icon="👥" label="Students" />
            <NavItem href="/instructor/submissions" icon="📝" label="Submissions" />
            <NavItem href="/instructor/grades" icon="✅" label="Grades" />
            <NavItem href="/instructor/discussions" icon="💬" label="Discussions" />
            <NavItem href="/instructor/resources" icon="📁" label="Resources" />
            <NavItem href="/instructor/settings" icon="⚙️" label="Settings" />
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
