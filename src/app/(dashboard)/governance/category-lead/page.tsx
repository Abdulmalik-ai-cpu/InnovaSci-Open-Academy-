/**
 * Category Lead Dashboard
 * 
 * Category-specific dashboard for the Category Lead role.
 * This role manages ONLY the assigned category and its courses.
 */

import { NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'
import { prisma } from '@/lib/prisma'
import { Role } from '@/lib/rbac/roles'

export const metadata = {
  title: 'Category Lead Dashboard - InnovaSci Open Academy',
  description: 'Category-specific academic management',
}

export default async function CategoryLeadDashboard() {
  const session = await getServerSession(authOptions)
  
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // Get user with staff profile and category assignment
  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
    include: {
      staffProfile: {
        include: {
          categoryAssignments: {
            where: { status: 'ACTIVE' },
            include: { category: true },
          },
        },
      },
    },
  })

  // Verify role
  if (user?.staffProfile?.governanceRole !== Role.CATEGORY_LEAD && 
      user?.staffProfile?.governanceRole !== Role.SUPER_ADMIN &&
      user?.staffProfile?.governanceRole !== Role.ACADEMIC_DIRECTOR &&
      user?.staffProfile?.governanceRole !== Role.HEAD_OF_DOMAIN) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Get assigned category
  const assignedCategory = user?.staffProfile?.categoryAssignments?.[0]?.category

  if (!assignedCategory) {
    return (
      <div className="space-y-6">
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <p className="text-yellow-800">
            ⚠️ No category assigned. Please contact an administrator to assign a category to your profile.
          </p>
        </div>
      </div>
    )
  }

  // Get category-specific statistics
  const [
    courseCount,
    instructorCount,
    studentCount,
    enrollmentCount,
    pendingCapstones,
    miniProjectCount,
  ] = await Promise.all([
    prisma.course.count({ where: { categoryId: assignedCategory.id } }),
    prisma.staffProfile.count({ 
      where: { 
        governanceRole: Role.INSTRUCTOR,
        courseAssignments: {
          some: {
            course: { categoryId: assignedCategory.id },
            status: 'ACTIVE',
          },
        },
      },
    }),
    prisma.enrollment.groupBy({
      by: ['userId'],
      where: {
        course: { categoryId: assignedCategory.id },
      },
    }),
    prisma.enrollment.count({
      where: {
        course: { categoryId: assignedCategory.id },
      },
    }),
    // Category capstone projects (difficulty level)
    prisma.projectSubmission.count({
      where: {
        capstoneType: 'difficulty',
        course: { categoryId: assignedCategory.id },
        status: 'SUBMITTED',
      },
    }),
    prisma.miniProject.count({
      where: {
        course: { categoryId: assignedCategory.id },
      },
    }),
  ])

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Category Lead Dashboard</h1>
            <p className="mt-1 text-gray-600">
              Managing: <span className="font-semibold text-purple-600">{assignedCategory.name}</span>
            </p>
          </div>
          <span className="px-3 py-1 rounded-full text-sm font-medium bg-purple-100 text-purple-800">
            {assignedCategory.status}
          </span>
        </div>
      </div>

      {/* Pending Review Alert */}
      {pendingCapstones > 0 && (
        <div className="bg-indigo-50 border border-indigo-200 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <span className="text-2xl mr-3">📋</span>
              <div>
                <h3 className="font-semibold text-indigo-800">Category Capstone Projects</h3>
                <p className="text-sm text-indigo-700">
                  {pendingCapstones} capstone project(s) awaiting your review
                </p>
              </div>
            </div>
            <a
              href="/governance/category-lead/category-capstone"
              className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
            >
              Review Now
            </a>
          </div>
        </div>
      )}

      {/* Category Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          title="Courses"
          value={courseCount}
          icon="book"
          color="blue"
          href="/governance/category-lead/courses"
        />
        <StatCard
          title="Mini Projects"
          value={miniProjectCount}
          icon="folder"
          color="green"
          href="/governance/category-lead/mini-projects"
        />
        <StatCard
          title="Instructors"
          value={instructorCount}
          icon="user"
          color="orange"
          href="/governance/category-lead/instructors"
        />
        <StatCard
          title="Unique Students"
          value={studentCount.length}
          icon="users"
          color="teal"
          href="/governance/category-lead/students"
        />
      </div>

      {/* Engagement Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <StatCard
          title="Total Enrollments"
          value={enrollmentCount}
          icon="user-check"
          color="blue"
        />
        <StatCard
          title="Pending Capstones"
          value={pendingCapstones}
          icon="capstone"
          color="purple"
          href="/governance/category-lead/category-capstone"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Category Management</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <QuickAction
            title="My Category"
            icon="folder"
            href="/governance/category-lead/my-category"
          />
          <QuickAction
            title="Courses"
            icon="book"
            href="/governance/category-lead/courses"
          />
          <QuickAction
            title="Mini Projects"
            icon="folder"
            href="/governance/category-lead/mini-projects"
          />
          <QuickAction
            title="Category Capstone"
            icon="capstone"
            href="/governance/category-lead/category-capstone"
            badge={pendingCapstones > 0 ? `${pendingCapstones}` : undefined}
          />
          <QuickAction
            title="Instructors"
            icon="user"
            href="/governance/category-lead/instructors"
          />
          <QuickAction
            title="Students"
            icon="users"
            href="/governance/category-lead/students"
          />
          <QuickAction
            title="Lessons"
            icon="file"
            href="/governance/category-lead/lessons"
          />
          <QuickAction
            title="Analytics"
            icon="chart"
            href="/governance/category-lead/analytics"
          />
        </div>
      </div>

      {/* Category Courses */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Category Courses</h2>
          <a
            href="/governance/category-lead/courses"
            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
          >
            View All →
          </a>
        </div>
        <CategoryCourses categoryId={assignedCategory.id} />
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

// Category Courses Component
async function CategoryCourses({ categoryId }: { categoryId: string }) {
  const courses = await prisma.course.findMany({
    where: { categoryId },
    take: 5,
    include: {
      _count: {
        select: { enrollments: true, modules: true },
      },
    },
    orderBy: { createdAt: 'desc' },
  })

  if (courses.length === 0) {
    return <p className="text-gray-500 text-center py-4">No courses in this category</p>
  }

  return (
    <div className="space-y-3">
      {courses.map((course) => (
        <div
          key={course.id}
          className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div>
            <p className="font-medium text-gray-900">{course.title}</p>
            <p className="text-sm text-gray-500">
              {course._count.modules} modules • {course._count.enrollments} enrollments
            </p>
          </div>
          <span
            className={`px-2 py-1 rounded text-xs font-medium ${
              course.status === 'published'
                ? 'bg-green-100 text-green-800'
                : course.status === 'draft'
                ? 'bg-yellow-100 text-yellow-800'
                : 'bg-gray-100 text-gray-800'
            }`}
          >
            {course.status}
          </span>
        </div>
      ))}
    </div>
  )
}
