# 🚀 دليل نشر تطبيق Maaref Haithem

## 📋 متطلبات التشغيل
- **Node.js** v18 أو أحدث (يفضل v22)
- **PostgreSQL** قاعدة بيانات (محلية أو سحابية)

---

## 🎯 الخيار 1: النشر على Railway (أنصح به - أسهل وأسرع)

**Railway** منصة سحابية تقدم PostgreSQL مجاني واستضافة مجانية (بطاقة 5$ كل شهر).

### خطوات النشر:

#### 1️⃣ إنشاء حساب على Railway
- اذهب إلى 👉 [railway.app](https://railway.app)
- سجل بحساب GitHub/Google

#### 2️⃣ إنشاء قاعدة بيانات PostgreSQL
- اضغط **"New Project"** → **"Provision PostgreSQL"**
- انتظر حتى يتم إنشاء قاعدة البيانات
- من تبويب **"Connect"** انسخ رابط **"Postgres Connection URL"**

#### 3️⃣ رفع التطبيق
- **الطريقة الأولى (GitHub):**
  - ارفع الكود إلى GitHub
  - في Railway: **"New Project"** → **"Deploy from GitHub repo"**
  - اختر المستودع

- **الطريقة الثانية (CLI):**
  ```bash
  npm i -g @railway/cli
  railway login
  railway init
  railway up
  ```

#### 4️⃣ إعداد المتغيرات
في تبويب **"Variables"** أضف:
```
DATABASE_URL=<رابط قاعدة البيانات الذي نسخته>
NEXT_PUBLIC_BASE_URL=https://maaref-haithem.up.railway.app
```

> ⚠️ **هام:** رابط `NEXT_PUBLIC_BASE_URL` يعتمد على الرابط الذي يعطيك إياه Railway

#### 5️⃣ تهيئة قاعدة البيانات
بعد أول نشر، افتح **Railway Console** وشغّل:
```bash
npx drizzle-kit push
```

#### 6️⃣ التطبيق جاهز! 🎉
افتح الرابط الذي وفره Railway. استخدم:
- **لوحة الإدارة:** `/admin/login`
- **حساب المسؤول:** `admin` / `admin123456`

---

## 🎯 الخيار 2: النشر على Vercel + Neon (مجاني بالكامل)

**Vercel** يستضيف التطبيق و **Neon** يستضيف قاعدة البيانات.

### خطوات النشر:

#### 1️⃣ إنشاء قاعدة بيانات على Neon
- اذهب إلى 👉 [neon.tech](https://neon.tech)
- سجل بحساب GitHub
- اضغط **"Create Project"** → اختر منطقة قريبة (مثلاً Frankfurt)
- من **"Connection Details"** انسخ **"Connection String"**

#### 2️⃣ رفع التطبيق على Vercel
- اذهب إلى 👉 [vercel.com](https://vercel.com)
- سجل بحساب GitHub
- اضغط **"Add New"** → **"Project"**
- استورد الكود من GitHub (أو ارفع كملف ZIP)
- أضف المتغيرات:
  ```
  DATABASE_URL=<رابط Neon>
  NEXT_PUBLIC_BASE_URL=https://maaref-haithem.vercel.app
  ```

#### 3️⃣ تهيئة قاعدة البيانات
في تبويب Vercel → **"Deployments"** → أحدث نشر → **"Console"**:
```bash
npx drizzle-kit push
```

إذا ما في Console، استخدم الأمر محلياً:
```bash
DATABASE_URL="<الرابط>" npx drizzle-kit push
```

#### 4️⃣ التطبيق جاهز! 🎉

---

## 🎯 الخيار 3: النشر على Render (مجاني)

- اذهب إلى 👉 [render.com](https://render.com)
- اختر **"New Web Service"** 
- اربط GitHub أو ارفع ZIP
- اختر runtime: **Node**
- Build Command: `npm install && npm run build`
- Start Command: `npx next start -p $PORT`
- أضف البيئة:
  - `DATABASE_URL` (أنشئ PostgreSQL من Render نفسه)
  - `NEXT_PUBLIC_BASE_URL`

---

## 🎯 الخيار 4: سيرفر خاص (VPS) مع Docker

### 1️⃣ إنشاء Dockerfile:

```dockerfile
# Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

### 2️⃣ إنشاء docker-compose.yml:

```yaml
# docker-compose.yml
version: "3.8"
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: app_db
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  app:
    build: .
    depends_on:
      - db
    environment:
      DATABASE_URL: postgresql://postgres:postgres@db:5432/app_db
      NEXT_PUBLIC_BASE_URL: https://example.com
    ports:
      - "3000:3000"
    command: sh -c "npx drizzle-kit push && npm start"

volumes:
  pgdata:
```

### 3️⃣ تشغيل:
```bash
docker-compose up -d
```

---

## 📱 بعد النشر: بدء الاستخدام

| الخطوة | الوصف | الرابط |
|--------|-------|--------|
| 1️⃣ | ادخل لوحة الإدارة | `/admin/login` (admin / admin123456) |
| 2️⃣ | أضف أطباء | `/dashboard/doctors` |
| 3️⃣ | أضف مرضى | `/dashboard/patients` |
| 4️⃣ | أنشئ حسابات للمرضى | من صفحة المرضى → زر "🔐 إنشاء حساب" |
| 5️⃣ | أضف تحاليل | `/dashboard/reports/new` |
| 6️⃣ | انشر التقرير للمريض | زر "📢 نشر" في تفاصيل التقرير |

### 🔗 روابط مهمة بعد النشر

| لمن | الرابط | طريقة الدخول |
|-----|--------|-------------|
| 🔐 **المسؤول** | `/admin/login` | admin / admin123456 |
| 🧬 **المرضى** | `/patient/login` | اسم المستخدم + كلمة مرور |
| 🩺 **الأطباء** | `/doctor/login` | بريد إلكتروني + كلمة مرور |
| 📝 **تسجيل مريض جديد** | `/patient/register` | ذاتي |
| 📝 **تسجيل طبيب جديد** | `/doctor/register` | ذاتي |

### 📤 إرسال الروابط للأطباء

من `/dashboard/doctors` → كل طبيب لديه زر **"نسخ رابط الدخول"**.
أرسل الرابط للطبيب وسيدخل مباشرة لحسابه!

### 🧬 إعطاء المرضى بياناتهم

من `/dashboard/patients` → اضغط **"🔐 إنشاء حساب"** بجانب المريض
ستظهر نافذة بها **اسم المستخدم** و **كلمة المرور** - أعطهما للمريض.

---

## 📝 دعم فني

لأي مشكلة أو استفسار:
- **البريد:** maarefhaithem@gmail.com
- **الهاتف:** 55142512 / 28142513
