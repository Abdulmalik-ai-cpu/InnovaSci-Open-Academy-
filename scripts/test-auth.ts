import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

async function main() {
  console.log("🔍 Testing database connection...\n")
  
  try {
    // Test connection
    await prisma.$queryRaw`SELECT 1`
    console.log("✅ Database connection successful!")
    
    // Check users
    const users = await prisma.user.findMany({
      select: { id: true, email: true, role: true, status: true }
    })
    console.log(`\n👥 Found ${users.length} users:`)
    users.forEach(u => console.log(`  - ${u.email} (${u.role}) - ${u.status}`))
    
    // Check roles
    const roles = await prisma.role.findMany()
    console.log(`\n🎭 Found ${roles.length} roles:`)
    roles.forEach(r => console.log(`  - ${r.name} (${r.displayName})`))
    
    // Check user roles
    const userRoles = await prisma.userRole.findMany({
      include: { user: true, role: true }
    })
    console.log(`\n🔐 Found ${userRoles.length} user-role assignments:`)
    userRoles.forEach(ur => console.log(`  - ${ur.user.email} -> ${ur.role.name}`))
    
  } catch (error) {
    console.error("❌ Error:", error)
  } finally {
    await prisma.$disconnect()
  }
}

main()
