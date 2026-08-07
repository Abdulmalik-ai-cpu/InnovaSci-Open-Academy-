import NextAuth, { NextAuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { createClient, SupabaseClient } from "@supabase/supabase-js"

let supabaseAdmin: SupabaseClient | null = null

function getSupabaseAdmin(): SupabaseClient {
  if (!supabaseAdmin) {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
    
    if (!supabaseUrl || !supabaseKey) {
      console.error("[Auth] Missing Supabase configuration:")
      console.error("[Auth] NEXT_PUBLIC_SUPABASE_URL:", supabaseUrl)
      console.error("[Auth] SUPABASE_SERVICE_ROLE_KEY:", supabaseKey ? "set" : "missing")
      throw new Error("Missing Supabase configuration. Please check environment variables.")
    }
    
    supabaseAdmin = createClient(supabaseUrl, supabaseKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
      },
    })
  }
  return supabaseAdmin
}

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

        try {
          // Use Supabase Auth for authentication (lazy initialization)
          const { data: authData, error: authError } = await getSupabaseAdmin().auth.signInWithPassword({
            email: normalizedEmail,
            password: credentials.password,
          })

          if (authError || !authData.user) {
            console.error("[Auth] Supabase auth error:", authError)
            return null
          }

          // Get user metadata
          const userMeta = authData.user.user_metadata || {}
          const role = (userMeta.role as string) || "STUDENT"
          const fullName = (userMeta.full_name as string) || authData.user.email?.split("@")[0] || "User"

          // Map role to portal
          const rolePortalMap: Record<string, string> = {
            "SUPER_ADMIN": "ADMINISTRATION",
            "SYSTEM_ADMIN": "ADMINISTRATION",
            "ACADEMIC_DIRECTOR": "ACADEMIC",
            "HEAD_OF_DOMAIN": "ACADEMIC",
            "CATEGORY_LEAD": "ACADEMIC",
            "INSTRUCTOR": "INSTRUCTOR",
            "STUDENT": "STUDENT",
          }
          const portal = rolePortalMap[role] || "STUDENT"

          return {
            id: authData.user.id,
            email: authData.user.email || normalizedEmail,
            name: fullName,
            role: role,
            portal: portal,
            permissions: [],
          }
        } catch (error) {
          console.error("[Auth] Error:", error)
          return null
        }
      }
    })
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id
        token.role = (user as any).role || "STUDENT"
        token.portal = (user as any).portal || "STUDENT"
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