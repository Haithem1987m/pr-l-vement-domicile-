#!/bin/bash
# =====================================================
# 🚀 سكريبت تشغيل التطبيق في بيئة الإنتاج
# Maaref Haithem - Résultats des analyses médicales
# =====================================================

set -e

echo "=========================================="
echo "  🚀 Maaref Haithem - Production Startup"
echo "=========================================="

# 1️⃣ التحقق من وجود Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js غير مثبت. يرجى تثبيت Node.js v18+"
    exit 1
fi

echo "✅ Node.js $(node -v)"

# 2️⃣ التحقق من متغيرات البيئة
if [ -z "$DATABASE_URL" ]; then
    if [ -f .env ]; then
        echo "📝 تحميل المتغيرات من ملف .env"
        export $(grep -v '^#' .env | xargs)
    else
        echo "❌ متغير DATABASE_URL غير موجود"
        echo "   إنشاء ملف .env أو تصدير المتغير:"
        echo "   export DATABASE_URL=postgresql://..."
        exit 1
    fi
fi

echo "✅ DATABASE_URL موجود"

# 3️⃣ تثبيت الحزم
echo "📦 تثبيت الحزم..."
npm install --production 2>/dev/null || npm install

# 4️⃣ بناء التطبيق
echo "🔨 بناء التطبيق..."
npm run build

# 5️⃣ تطبيق هيكل قاعدة البيانات
echo "🗄️  تطبيق هيكل قاعدة البيانات..."
npx drizzle-kit push --force 2>/dev/null || echo "⚠️  فشل تطبيق (قد يكون جاهزاً)"

# 6️⃣ تشغيل التطبيق
echo ""
echo "=========================================="
echo "  ✅ التطبيق جاهز!"
echo "  🌐 http://localhost:3000"
echo "  🔐 /admin/login (admin / admin123456)"
echo "=========================================="
echo ""

npm start
