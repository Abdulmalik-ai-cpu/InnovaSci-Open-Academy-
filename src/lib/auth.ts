import NextAuth, { NextAuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { prisma } from "@/lib/prisma"
import bcrypt from "bcryptjs"
import { ROLES, ROLE_PORTAL_MAP, ROLE_DEFAULT_REDIRECT } from "@/lib/rbac/roles"

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        const normalizedEmail = credentials.email.toLowerCase().trim()

        // Prisma database authentication with bcrypt
        try {
          const prismaUser = await prisma.user.findFirst({
            where: { email: normalizedEmail },
            include: { 
              profile: true,
              userRoles: {
                where: { isActive: true },
                include: {
                  role: {
                    include: {
                      permissions: {
                        include: { permission: true },
                      },
                    },
                  },
                },
                orderBy: { role: { level: 'desc' } },
                take: 1,
              },
              portalAssignment: true,
            }
          })

          if (prismaUser && prismaUser.passwordHash) {
            const isValid = await bcrypt.compare(credentials.password, prismaUser.passwordHash)
            if (isValid) {
              // Get primary role
              const primaryRole = prismaUser.userRoles[0]?.role?.name as string || ROLES.STUDENT
              const portal = prismaUser.portalAssignment?.portal || ROLE_PORTAL_MAP[primaryRole as keyof typeof ROLE_PORTAL_MAP] || 'STUDENT'
              
              // Get permissions
              const permissions = prismaUser.userRoles[0]?.role?.permissions?.map(
                rp => rp.permission.name
              ) || []

              return {
                id: prismaUser.id,
                email: prismaUser.email,
                name: prismaUser.profile?.fullName || prismaUser.email.split("@")[0],
                role: primaryRole,
                portal: portal,
                permissions: permissions,
              }
            }
          }
        } catch (prismaError) {
          console.error("[Auth] Prisma error:", prismaError)
        }

        return null
      }
    })
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id
        token.role = (user as any).role || ROLES.STUDENT
        token.portal = (user as any).portal || 'STUDENT'
        token.permissions = (user as any).permissions || []
      }
      return token
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string
        session.user.role = token.role as string
        session.user.portal = token.portal as string
        session.user.permissions = token.permissions as string[]
      }
      return session
    }
  },
  pages: {
    signIn: "/auth/login"
  },
  session: {
    strategy: "jwt"
  },
  secret: process.env.NEXTAUTH_SECRET
}

// Extend NextAuth types
declare module "next-auth" {
  interface Session {
    user: {
      id: string
      email: string
      name?: string | null
      role: string
      portal: string
      permissions: string[]
    }
  }
  
  interface User {
    id: string
    email: string
    name?: string | null
    role: string
    portal: string
    permissions: string[]
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    id: string
    role: string
    portal: string
    permissions: string[]
  }
}