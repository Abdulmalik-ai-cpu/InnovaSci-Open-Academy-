import NextAuth, { NextAuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { prisma } from "@/lib/prisma"
import bcrypt from "bcryptjs"

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

        // Try Supabase Auth first (if configured)
        const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
        const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
        const isSupabaseConfigured = supabaseUrl && supabaseKey && 
          supabaseUrl !== "https://your-project.supabase.co" &&
          supabaseUrl.startsWith("https://")
        
        if (isSupabaseConfigured) {
          try {
            const { createClient } = await import("@supabase/supabase-js")
            const supabase = createClient(supabaseUrl, supabaseKey)

            const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
              email: normalizedEmail,
              password: credentials.password
            })

            if (!signInError && signInData.user) {
              const prismaUser = await prisma.user.findFirst({
                where: { email: normalizedEmail },
                include: { profile: true }
              })

              if (prismaUser) {
                return {
                  id: prismaUser.id,
                  email: prismaUser.email,
                  name: prismaUser.profile?.fullName || prismaUser.email.split("@")[0],
                  role: prismaUser.role
                }
              } else {
                // New user - create with STUDENT role
                const newPrismaUser = await prisma.user.create({
                  data: {
                    email: signInData.user.email!,
                    role: "STUDENT",
                    status: "ACTIVE",
                  },
                  include: { profile: true }
                })
                
                return {
                  id: newPrismaUser.id,
                  email: newPrismaUser.email,
                  name: newPrismaUser.email.split("@")[0],
                  role: newPrismaUser.role
                }
              }
            }
          } catch (supabaseError) {
            console.error("[Auth] Supabase error:", supabaseError)
          }
        }

        // Fallback: Prisma database with bcrypt
        try {
          const prismaUser = await prisma.user.findFirst({
            where: { email: normalizedEmail },
            include: { profile: true }
          })

          if (prismaUser && prismaUser.passwordHash) {
            const isValid = await bcrypt.compare(credentials.password, prismaUser.passwordHash)
            if (isValid) {
              return {
                id: prismaUser.id,
                email: prismaUser.email,
                name: prismaUser.profile?.fullName || prismaUser.email.split("@")[0],
                role: prismaUser.role
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
      }
      return token
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string
        session.user.role = token.role as string
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