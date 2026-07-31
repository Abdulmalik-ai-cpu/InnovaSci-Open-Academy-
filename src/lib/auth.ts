import NextAuth, { NextAuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { prisma } from "@/lib/prisma"
import bcrypt from "bcryptjs"
import { Role } from "@/lib/rbac/roles"

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
              staffProfile: true 
            }
          })

          if (prismaUser && prismaUser.passwordHash) {
            const isValid = await bcrypt.compare(credentials.password, prismaUser.passwordHash)
            if (isValid) {
              // Determine effective role (governance role takes precedence)
              const effectiveRole = prismaUser.staffProfile?.governanceRole || prismaUser.role
              
              return {
                id: prismaUser.id,
                email: prismaUser.email,
                name: prismaUser.profile?.fullName || prismaUser.email.split("@")[0],
                role: effectiveRole,
                isGovernanceStaff: !!prismaUser.staffProfile,
                governanceRole: prismaUser.staffProfile?.governanceRole || null,
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
        token.role = (user as any).role || "STUDENT"
        token.isGovernanceStaff = (user as any).isGovernanceStaff || false
        token.governanceRole = (user as any).governanceRole || null
      }
      return token
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string
        session.user.role = token.role as string
        ;(session.user as any).isGovernanceStaff = token.isGovernanceStaff || false
        ;(session.user as any).governanceRole = token.governanceRole || null
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

// Extend the built-in types
declare module "next-auth" {
  interface Session {
    user: {
      id: string
      email: string
      name?: string | null
      role: string
      isGovernanceStaff?: boolean
      governanceRole?: string | null
    }
  }
}