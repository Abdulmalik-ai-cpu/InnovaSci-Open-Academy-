'use client'

/**
 * Governance Portal Layout
 * 
 * This layout handles the navigation and authentication for all governance dashboards.
 * The actual dashboard shown depends on the user's governance role.
 */

import { useEffect, useState } from 'react'
import { useRouter, usePathname } from 'next/navigation'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { Role, ROLE_DISPLAY_NAMES } from '@/lib/rbac/roles'
import { getNavigationByRole, getDashboardRouteByRole, DASHBOARD_ROUTES } from '@/lib/navigation'

interface GovernanceLayoutProps {
  children: React.ReactNode
}

export default function GovernanceLayout({ children }: GovernanceLayoutProps) {
  const router = useRouter()
  const pathname = usePathname()
  const [isLoading, setIsLoading] = useState(true)
  const [userRole, setUserRole] = useState<string | null>(null)
  const [userName, setUserName] = useState<string | null>(null)

  useEffect(() => {
    // Fetch user session and governance role
    async function checkAuth() {
      try {
        const response = await fetch('/api/auth/session')
        const data = await response.json()
        
        if (!data.user) {
          router.push('/auth/login')
          return
        }

        const role = data.user.role as string
        setUserRole(role)
        setUserName(data.user.name || data.user.email)

        // Get the correct dashboard path for this role
        const roleEnum = role as Role
        const correctRoute = getDashboardRouteByRole(roleEnum)

        // Check if we're on the correct dashboard for this role
        // If not, redirect to the correct dashboard
        if (!pathname.startsWith(correctRoute)) {
          // Check if current path is a valid sub-path of the correct route
          const expectedRoute = correctRoute
          const isValidPath = pathname.startsWith(expectedRoute) || 
                              (pathname === '/governance' && roleEnum === Role.STUDENT)
          
          if (!isValidPath) {
            router.push(expectedRoute)
            return
          }
        }

        setIsLoading(false)
      } catch (error) {
        console.error('Auth check failed:', error)
        router.push('/auth/login')
      }
    }

    checkAuth()
  }, [pathname, router])

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading governance portal...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Governance Portal Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            {/* Logo and Portal Name */}
            <div className="flex items-center space-x-4">
              <div className="flex-shrink-0">
                <h1 className="text-xl font-bold text-gray-900">InnovaSci Open Academy</h1>
              </div>
              <div className="hidden sm:block">
                <span className="px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                  {userRole ? ROLE_DISPLAY_NAMES[userRole as Role] || userRole : 'Loading...'}
                </span>
              </div>
            </div>

            {/* User Menu */}
            <div className="flex items-center space-x-4">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">{userName}</p>
                <p className="text-xs text-gray-500">{userRole}</p>
              </div>
              <div className="h-8 w-8 rounded-full bg-blue-600 flex items-center justify-center">
                <span className="text-white text-sm font-medium">
                  {userName?.charAt(0).toUpperCase() || 'U'}
                </span>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="py-6">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          {children}
        </div>
      </main>
    </div>
  )
}
