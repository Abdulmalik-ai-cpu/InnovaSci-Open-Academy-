import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { ROLES } from '@/lib/rbac/roles'

export default async function InstructorDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    redirect('/auth/login')
  }

  // Verify user is in Instructor portal
  if (session.user.portal !== 'INSTRUCTOR') {
    redirect('/forbidden')
  }

  // Get instructor's assigned courses
  const courseAssignments = await prisma.courseAssignment.findMany({
    where: {
      userId: session.user.id,
      status: 'ACTIVE',
      role: 'INSTRUCTOR',
    },
    include: {
      course: {
        select: {
          id: true,
          title: true,
          slug: true,
          status: true,
          thumbnailUrl: true,
          _count: {
            select: {
              enrollments: true,
              modules: true,
            },
          },
        },
      },
    },
  })

  // Get pending submissions
  const pendingSubmissions = await prisma.projectSubmission.count({
    where: {
      courseId: { in: courseAssignments.map(ca => ca.courseId) },
      status: 'SUBMITTED',
    },
  })

  // Get recent submissions
  const recentSubmissions = await prisma.projectSubmission.findMany({
    where: {
      courseId: { in: courseAssignments.map(ca => ca.courseId) },
    },
    take: 5,
    orderBy: { createdAt: 'desc' },
    include: {
      user: {
        include: {
          profile: true,
        },
      },
      course: {
        select: {
          title: true,
        },
      },
    },
  })

  const assignedCourses = courseAssignments.map(ca => ca.course)

  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Instructor Dashboard</h1>
        <p className="mt-1 text-gray-600">Welcome back, {session.user.name}</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          title="Assigned Courses"
          value={assignedCourses.length}
          icon="📚"
          color="blue"
        />
        <StatCard
          title="Total Students"
          value={assignedCourses.reduce((acc, c) => acc + c._count.enrollments, 0)}
          icon="👥"
          color="green"
        />
        <StatCard
          title="Pending Reviews"
          value={pendingSubmissions}
          icon="📝"
          color="orange"
        />
        <StatCard
          title="Total Modules"
          value={assignedCourses.reduce((acc, c) => acc + c._count.modules, 0)}
          icon="📋"
          color="purple"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction href="/instructor/courses" icon="📚" label="View Courses" />
          <QuickAction href="/instructor/submissions" icon="📝" label="Review Submissions" />
          <QuickAction href="/instructor/grades" icon="✅" label="Manage Grades" />
          <QuickAction href="/instructor/students" icon="👥" label="View Students" />
        </div>
      </div>

      {/* My Courses */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">My Courses</h2>
          <a href="/instructor/courses" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
            View All →
          </a>
        </div>
        {assignedCourses.length === 0 ? (
          <p className="text-gray-500 text-center py-8">No courses assigned yet.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {assignedCourses.slice(0, 6).map((course) => (
              <div key={course.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center mb-2">
                  <span className="text-2xl mr-2">📚</span>
                  <h3 className="font-medium text-gray-900 truncate">{course.title}</h3>
                </div>
                <div className="text-sm text-gray-500 space-y-1">
                  <p>{course._count.modules} modules</p>
                  <p>{course._count.enrollments} students enrolled</p>
                </div>
                <span className={`inline-block mt-2 px-2 py-1 text-xs font-medium rounded ${
                  course.status === 'published' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                }`}>
                  {course.status}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Recent Submissions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Recent Submissions</h2>
          <a href="/instructor/submissions" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
            View All →
          </a>
        </div>
        {recentSubmissions.length === 0 ? (
          <p className="text-gray-500 text-center py-8">No recent submissions.</p>
        ) : (
          <div className="space-y-3">
            {recentSubmissions.map((submission) => (
              <div key={submission.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{submission.title}</p>
                  <p className="text-sm text-gray-500">
                    {submission.user.profile?.fullName || 'Unknown'} • {submission.course?.title || 'Unknown Course'}
                  </p>
                </div>
                <span className={`px-2 py-1 text-xs font-medium rounded ${
                  submission.status === 'SUBMITTED' ? 'bg-orange-100 text-orange-800' :
                  submission.status === 'APPROVED' ? 'bg-green-100 text-green-800' :
                  'bg-gray-100 text-gray-800'
                }`}>
                  {submission.status}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

function StatCard({ title, value, icon, color }: { title: string; value: number; icon: string; color: string }) {
  const colorClasses: Record<string, string> = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    orange: 'bg-orange-100 text-orange-600',
    purple: 'bg-purple-100 text-purple-600',
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
