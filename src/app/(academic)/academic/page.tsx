import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { ROLES } from '@/lib/rbac/roles'

export default async function AcademicDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    redirect('/auth/login')
  }

  // Verify user is in Academic portal
  if (session.user.portal !== 'ACADEMIC') {
    redirect('/forbidden')
  }

  const userRole = session.user.role as string

  // Get accessible data based on role
  let domains: any[] = []
  let categories: any[] = []
  let courses: any[] = []

  if (userRole === ROLES.ACADEMIC_DIRECTOR || userRole === ROLES.SUPER_ADMIN) {
    // Academic Director can see everything
    domains = await prisma.domain.findMany({
      where: { status: { not: 'ARCHIVED' } },
      orderBy: { orderIndex: 'asc' },
    })
    categories = await prisma.category.findMany({
      where: { isActive: true },
      orderBy: { orderIndex: 'asc' },
    })
    courses = await prisma.course.findMany({
      where: { status: { not: 'archived' } },
    })
  } else if (userRole === ROLES.HEAD_OF_DOMAIN) {
    // Head of Domain sees assigned domain
    const assignments = await prisma.domainAssignment.findMany({
      where: { userId: session.user.id, status: 'ACTIVE' },
      include: { domain: true },
    })
    const domainIds = assignments.map(a => a.domainId)
    domains = assignments.map(a => a.domain)
    categories = await prisma.category.findMany({
      where: { domainId: { in: domainIds }, isActive: true },
    })
    courses = await prisma.course.findMany({
      where: { category: { domainId: { in: domainIds } }, status: { not: 'archived' } },
    })
  } else if (userRole === ROLES.CATEGORY_LEAD) {
    // Category Lead sees assigned categories
    const assignments = await prisma.categoryAssignment.findMany({
      where: { userId: session.user.id, status: 'ACTIVE' },
      include: { category: true },
    })
    const categoryIds = assignments.map(a => a.categoryId)
    categories = assignments.map(a => a.category)
    const category = await prisma.category.findFirst({ where: { id: { in: categoryIds } } })
    if (category) {
      const domain = await prisma.domain.findUnique({ where: { id: category.domainId || '' } })
      if (domain) domains = [domain]
    }
    courses = await prisma.course.findMany({
      where: { categoryId: { in: categoryIds }, status: { not: 'archived' } },
    })
  }

  // Get statistics
  const [
    studentCount,
    instructorCount,
    pendingCapstones,
    certificateCount,
  ] = await Promise.all([
    prisma.user.count({ where: { role: ROLES.STUDENT } }),
    prisma.user.count({ where: { role: ROLES.INSTRUCTOR } }),
    prisma.projectSubmission.count({ where: { status: 'SUBMITTED', projectType: { in: ['DIFFICULTY_CAPSTONE', 'PROFESSIONAL_CAPSTONE'] } } }),
    prisma.issuedCertificate.count(),
  ])

  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Academic Dashboard</h1>
        <p className="mt-1 text-gray-600">
          Welcome back, {session.user.name} • {userRole.replace('_', ' ')}
        </p>
      </div>

      {/* Academic Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          title="Domains"
          value={domains.length}
          icon="🌐"
          color="blue"
        />
        <StatCard
          title="Categories"
          value={categories.length}
          icon="📁"
          color="green"
        />
        <StatCard
          title="Courses"
          value={courses.length}
          icon="📚"
          color="purple"
        />
        <StatCard
          title="Instructors"
          value={instructorCount}
          icon="👨‍🏫"
          color="orange"
        />
      </div>

      {/* More Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          title="Students"
          value={studentCount}
          icon="👥"
          color="teal"
        />
        <StatCard
          title="Pending Capstones"
          value={pendingCapstones}
          icon="🎓"
          color="red"
        />
        <StatCard
          title="Certificates"
          value={certificateCount}
          icon="🏆"
          color="gold"
        />
        <StatCard
          title="Total Enrollments"
          value={0}
          icon="✅"
          color="blue"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
          <QuickAction href="/academic/domains" icon="🌐" label="Domains" />
          <QuickAction href="/academic/categories" icon="📁" label="Categories" />
          <QuickAction href="/academic/courses" icon="📚" label="Courses" />
          <QuickAction href="/academic/certificates" icon="🏆" label="Certificates" />
          <QuickAction href="/academic/analytics" icon="📈" label="Analytics" />
        </div>
      </div>

      {/* Domains */}
      {domains.length > 0 && (
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-semibold text-gray-900">Domains</h2>
            <a href="/academic/domains" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              View All →
            </a>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {domains.slice(0, 6).map((domain) => (
              <div key={domain.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center mb-2">
                  <span className="text-2xl mr-2">{domain.icon || '🌐'}</span>
                  <h3 className="font-medium text-gray-900">{domain.name}</h3>
                </div>
                <p className="text-sm text-gray-500 line-clamp-2">{domain.shortDescription || domain.fullDescription || 'No description'}</p>
                <span className={`inline-block mt-2 px-2 py-1 text-xs font-medium rounded ${
                  domain.status === 'PUBLISHED' ? 'bg-green-100 text-green-800' :
                  domain.status === 'DRAFT' ? 'bg-yellow-100 text-yellow-800' :
                  'bg-gray-100 text-gray-800'
                }`}>
                  {domain.status}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Categories */}
      {categories.length > 0 && (
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-semibold text-gray-900">Categories</h2>
            <a href="/academic/categories" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              View All →
            </a>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {categories.slice(0, 8).map((category) => (
              <div key={category.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center mb-2">
                  <span className="text-xl mr-2">{category.icon || '📁'}</span>
                  <h3 className="font-medium text-gray-900 truncate">{category.name}</h3>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Courses */}
      {courses.length > 0 && (
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-semibold text-gray-900">Recent Courses</h2>
            <a href="/academic/courses" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              View All →
            </a>
          </div>
          <div className="space-y-3">
            {courses.slice(0, 5).map((course) => (
              <div key={course.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{course.title}</p>
                  <p className="text-sm text-gray-500">ID: {course.id.slice(0, 8)}...</p>
                </div>
                <span className={`px-2 py-1 text-xs font-medium rounded ${
                  course.status === 'published' ? 'bg-green-100 text-green-800' :
                  course.status === 'draft' ? 'bg-yellow-100 text-yellow-800' :
                  'bg-gray-100 text-gray-800'
                }`}>
                  {course.status}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
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
    gold: 'bg-yellow-100 text-yellow-600',
  }

  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{value}</p>
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
