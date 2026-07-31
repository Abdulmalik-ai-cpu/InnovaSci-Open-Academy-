/**
 * Instructor Dashboard
 * 
 * Course-specific dashboard for the Instructor role.
 * This role manages ONLY the assigned courses and enrolled students.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export const metadata = {
  title: 'Instructor Dashboard - InnovaSci Open Academy',
  description: 'Course and student management',
}

export default async function InstructorDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // Get user with staff profile and course assignments
  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
    include: {
      staffProfile: {
        include: {
          courseAssignments: {
            where: { status: 'ACTIVE' },
            include: { course: true },
          },
        },
      },
    },
  })

  // Verify role
  if (user?.staffProfile?.governanceRole !== Role.INSTRUCTOR && 
      user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN &&
      user?.staffProfile?.governanceRole !== Role.ACADEMIC_DIRECTOR &&
      user?.staffProfile?.governanceRole !== Role.HEAD_OF_DOMAIN &&
      user?.staffProfile?.governanceRole !== Role.CATEGORY_LEAD) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Get assigned courses
  const assignedCourses = user?.staffProfile?.courseAssignments?.map(a => a.course) || []
  const assignedCourseIds = assignedCourses.map(c => c.id)

  if (assignedCourses.length === 0) {
    return (
      <div className="space-y-6">
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <p className="text-yellow-800">
            ⚠️ No courses assigned. Please contact a Category Lead or administrator to assign courses to your profile.
          </p>
        </div>
      </div>
    )
  }

  // Get course-specific statistics
  const [
    totalStudents,
    totalEnrollments,
    pendingMiniProjects,
    pendingGrades,
    totalLessons,
    recentSubmissions,
  ] = await Promise.all([
    // Count unique students enrolled in assigned courses
    prisma.enrollment.groupBy({
      by: ['userId'],
      where: {
        courseId: { in: assignedCourseIds },
      },
    }),
    prisma.enrollment.count({
      where: {
        courseId: { in: assignedCourseIds },
      },
    }),
    // Mini projects submitted and pending review
    prisma.projectSubmission.count({
      where: {
        courseId: { in: assignedCourseIds },
        projectType: 'MINI_PROJECT',
        status: 'SUBMITTED',
      },
    }),
    // Projects needing grading
    prisma.projectSubmission.count({
      where: {
        courseId: { in: assignedCourseIds },
        grade: null,
        status: { in: ['SUBMITTED', 'APPROVED'] },
      },
    }),
    // Total lessons in assigned courses
    prisma.lesson.count({
      where: {
        courseId: { in: assignedCourseIds },
      },
    }),
    // Recent submissions
    prisma.projectSubmission.findMany({
      where: {
        courseId: { in: assignedCourseIds },
        status: 'SUBMITTED',
      },
      take: 5,
      orderBy: { submittedAt: 'desc' },
      include: {
        user: {
          include: {
            profile: true,
          },
        },
        course: true,
      },
    }),
  ])

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h1 className="text-2xl font-bold text-gray-900">Instructor Dashboard</h1>
        <p className="mt-1 text-gray-600">
          Teaching: <span className="font-semibold text-green-600">{assignedCourses.length} course(s)</span>
        </p>
      </div>

      {/* Pending Actions Alert */}
      {(pendingMiniProjects > 0 || pendingGrades > 0) && (
        <div className="bg-orange-50 border border-orange-200 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <span className="text-2xl mr-3">📝</span>
              <div>
                <h3 className="font-semibold text-orange-800">Pending Actions</h3>
                <p className="text-sm text-orange-700">
                  {pendingMiniProjects} mini projects to review • {pendingGrades} submissions to grade
                </p>
              </div>
            </div>
            <a
              href="/governance/instructor/submissions"
              className="px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700"
            >
              Review Now
            </a>
          </div>
        </div>
      )}

      {/* Teaching Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          title="My Courses"
          value={assignedCourses.length}
          icon="book"
          color="blue"
          href="/governance/instructor/courses"
        />
        <StatCard
          title="Unique Students"
          value={totalStudents.length}
          icon="users"
          color="green"
          href="/governance/instructor/students"
        />
        <StatCard
          title="Total Enrollments"
          value={totalEnrollments}
          icon="user-check"
          color="purple"
        />
        <StatCard
          title="Total Lessons"
          value={totalLessons}
          icon="file"
          color="teal"
          href="/governance/instructor/lessons"
        />
      </div>

      {/* Assessment Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <StatCard
          title="Pending Reviews"
          value={pendingMiniProjects}
          icon="folder"
          color="orange"
          href="/governance/instructor/mini-projects"
        />
        <StatCard
          title="Pending Grades"
          value={pendingGrades}
          icon="check-circle"
          color="red"
          href="/governance/instructor/grades"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Teaching Tools</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction
            title="My Courses"
            icon="book"
            href="/governance/instructor/courses"
          />
          <QuickAction
            title="Curriculum"
            icon="list"
            href="/governance/instructor/curriculum"
          />
          <QuickAction
            title="Lessons"
            icon="file"
            href="/governance/instructor/lessons"
          />
          <QuickAction
            title="Mini Projects"
            icon="folder"
            href="/governance/instructor/mini-projects"
            badge={pendingMiniProjects > 0 ? `${pendingMiniProjects}` : undefined}
          />
          <QuickAction
            title="Submissions"
            icon="upload"
            href="/governance/instructor/submissions"
            badge={pendingGrades > 0 ? `${pendingGrades}` : undefined}
          />
          <QuickAction
            title="My Students"
            icon="users"
            href="/governance/instructor/students"
          />
          <QuickAction
            title="Grades"
            icon="check-circle"
            href="/governance/instructor/grades"
          />
          <QuickAction
            title="Discussions"
            icon="message"
            href="/governance/instructor/discussions"
          />
        </div>
      </div>

      {/* Recent Submissions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Recent Submissions</h2>
          <a
            href="/governance/instructor/submissions"
            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
          >
            View All →
          </a>
        </div>
        <RecentSubmissions submissions={recentSubmissions.filter(s => s.course !== null) as any} />
      </div>

      {/* Assigned Courses */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Assigned Courses</h2>
          <a
            href="/governance/instructor/courses"
            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
          >
            View All →
          </a>
        </div>
        <AssignedCourses courses={assignedCourses as any} />
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
    red: 'bg-red-100 text-red-600',
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

// Recent Submissions Component
function RecentSubmissions({ 
  submissions 
}: { 
  submissions: Array<{
    id: string
    title: string
    user: { profile: { fullName: string | null } | null }
    course: { title: string }
    submittedAt: Date | null
  }>
}) {
  if (submissions.length === 0) {
    return <p className="text-gray-500 text-center py-4">No recent submissions</p>
  }

  return (
    <div className="space-y-3">
      {submissions.map((submission) => (
        <div
          key={submission.id}
          className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div>
            <p className="font-medium text-gray-900">{submission.title}</p>
            <p className="text-sm text-gray-500">
              {submission.user.profile?.fullName || 'Unknown'} • {submission.course.title}
            </p>
          </div>
          <span className="text-xs text-gray-400">
            {submission.submittedAt ? new Date(submission.submittedAt).toLocaleDateString() : 'N/A'}
          </span>
        </div>
      ))}
    </div>
  )
}

// Assigned Courses Component
function AssignedCourses({ 
  courses 
}: { 
  courses: Array<{
    id: string
    title: string
    slug: string
    status: string
    _count: { enrollments: number; modules: number }
  }>
}) {
  if (courses.length === 0) {
    return <p className="text-gray-500 text-center py-4">No courses assigned</p>
  }

  return (
    <div className="space-y-3">
      {courses.slice(0, 5).map((course) => (
        <div
          key={course.id}
          className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div>
            <p className="font-medium text-gray-900">{course.title}</p>
            <p className="text-sm text-gray-500">
              {course._count.modules} modules • {course._count.enrollments} students
            </p>
          </div>
          <span
            className={`px-2 py-1 rounded text-xs font-medium ${
              course.status === 'published'
                ? 'bg-green-100 text-green-800'
                : 'bg-yellow-100 text-yellow-800'
            }`}
          >
            {course.status}
          </span>
        </div>
      ))}
    </div>
  )
}
