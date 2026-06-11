# 🏗️ PROJECT ARCHITECTURE — SewaIn

> **Dokumentasi Teknis Arsitektur Aplikasi Web SewaIn**
> Platform pencarian & manajemen properti sewa (Kost, Rumah, Kontrakan, Apartemen).
> Dibangun dengan Java Servlet (MVC), JSP, MySQL, dan Apache Tomcat.
> 
> **Dokumentasi Tambahan Pendamping:**
> * 👉 **[MODEL_CLASSES.md](MODEL_CLASSES.md)**: Analisis rinci UML, warisan, & deskripsi 15 kelas model di package `model`.
> * 👉 **[FILE_RELATIONSHIP.md](FILE_RELATIONSHIP.md)**: Analisis hubungan antar berkas, pemetaan alur fitur per role, audit kode mati, & evaluasi kesehatan OOP.

---

## Daftar Isi

1. [Konsep Dasar & Polimorfisme (STI)](#1-konsep-dasar--polimorfisme-single-table-inheritance)
2. [Mekanisme Manajemen Image & Cloudinary](#2-mekanisme-manajemen-image--cloudinary)
3. [Manajemen Database untuk Replikasi Tim](#3-manajemen-database-untuk-replikasi-tim-cloning)
4. [Refactoring, Cleanups, & Fitur Dashboard Owner](#4-refactoring-cleanups--fitur-dashboard-owner)
5. [Modul & Fitur Admin (Management, Verification, Flagging, Reports, Activity Logs)](#5-modul--fitur-admin-management-verification-flagging-reports-activity-logs)
6. [Temuan Analisis & Rekomendasi Perbaikan](#6-temuan-analisis--rekomendasi-perbaikan)
7. [Hasil Refactoring & Pembenahan Kode (Juni 2026)](#7-hasil-refactoring--pembenahan-kode-juni-2026)

---

## 1. Konsep Dasar & Polimorfisme (Single Table Inheritance)

### 1.1 Hierarki Kelas dalam Kode Java

Project SewaIn menerapkan **4 pilar OOP** secara penuh: Abstraction, Encapsulation, Inheritance, dan Polymorphism. Berikut peta hierarki kelasnya:

#### A. Hierarki `User`

```
┌──────────────────────────────────────────────┐
│         <<interface>> Reportable             │
│  ─────────────────────────────────────────── │
│  + report(): void                            │
│  + getReportStatus(): String                 │
│  + createReport(Report): void                │
└──────────────┬───────────────────────────────┘
               │ implements
┌──────────────▼───────────────────────────────┐
│       <<abstract>> User                      │
│  ─────────────────────────────────────────── │
│  # userId: String                            │
│  # name, email, password, phone, role        │
│  ─────────────────────────────────────────── │
│  + login(), logout(), getProfile()           │
│  + updateProfile()                           │
│  + report(), getReportStatus(), createReport │
└──────┬───────────────────────┬───────────────┴───────────────┐
       │ extends               │ extends                       │ extends
┌──────▼──────────┐    ┌───────▼──────────┐            ┌───────▼──────────┐
│     Tenant      │    │      Owner       │            │      Admin       │
│  ────────────── │    │  ────────────── │            │  ──────────────  │
│  + searchProp() │    │  + searchProp() │            │  + manageUser()  │
│  + addWishlist() │    │  + addWishlist() │            │  + verifyProp()  │
│  + viewProperty()│    │  + viewProperty()│            │  + monitorAct()  │
│  + reportProp()  │    │  + handleReport()│            │  + handleReport()│
└─────────────────┘    └──────────────────┘            └──────────────────┘
```

**Penjelasan:**
- `User` adalah kelas **abstrak** yang tidak bisa diinstansiasi langsung. Ia mengimplementasi interface `Reportable`.
- `Tenant`, `Owner`, dan `Admin` adalah kelas **konkret** yang mewarisi seluruh atribut dan method dari `User`.
- Subclass memiliki method yang berbeda sesuai perannya (contoh: `Tenant` bisa `reportProp()`, `Owner` bisa `handleReport()`, dan `Admin` bisa mengelola user, memverifikasi properti, menangani laporan, serta memonitor aktivitas).
- Di database, semua tipe disimpan dalam **satu tabel `users`** dengan kolom `role` sebagai pembeda (`'tenant'`, `'owner'`, atau `'admin'`).

**Referensi kode:**
- `src/java/model/User.java` — Kelas abstrak induk
- `src/java/model/Tenant.java` — Subclass penyewa
- `src/java/model/Owner.java` — Subclass pemilik
- `src/java/model/Admin.java` — Subclass administrator
- `src/java/model/Reportable.java` — Interface pelaporan

#### B. Hierarki `Property`

```
┌──────────────────────────────────────────────┐
│         <<interface>> Reportable             │
└──────────────┬───────────────────────────────┘
               │ implements
┌──────────────▼───────────────────────────────┐
│       <<abstract>> Property                  │
│  ─────────────────────────────────────────── │
│  # propertyId: int                           │
│  # name, location, propertyType: String      │
│  # price: double                             │
│  # availability: boolean                     │
│  # verificationStatus, flagStatus: String    │
│  # photos, description, facilities: String   │
│  # ownerName, ownerProfilePic: String        │
│  ─────────────────────────────────────────── │
│  + getDetail(), updateStatus()               │
│  + report(), getReportStatus(), createReport │
└──┬──────────┬──────────┬──────────┬──────────┘
   │          │          │          │ extends
 ┌─▼───┐   ┌──▼───┐   ┌──▼──────┐ ┌─▼──────────┐
 │Kost │   │Rumah │   │Kontrakan│ │ Apartement │
 │─────│   │──────│   │─────────│ │────────────│
 │-gend│   │-jmlK │   │-durMin  │ │-lantai     │
 │-rmTy│   │-luasT│   │-jmlKmr  │ │-nomorUnit  │
 │     │   │      │   │         │ │-tipeUnit   │
 └─────┘   └──────┘   └─────────┘ └────────────┘
```

**Atribut spesifik per subclass:**

| Subclass      | Atribut Khusus                                 |
|---------------|------------------------------------------------|
| `Kost`        | `gender` (Pria/Wanita/Campur), `roomType`      |
| `Rumah`       | `jumlahKamar` (int), `luasTanah` (double)       |
| `Kontrakan`   | `durasiMinimum` (int), `jumlahKamar` (int)      |
| `Apartement`  | `lantai` (int), `nomorUnit` (String), `tipeUnit` |

### 1.2 Implementasi STI (Single Table Inheritance)

**Prinsip:** Seluruh subclass `Property` dipetakan ke **satu tabel database tunggal** bernama `properties`. Kolom `propertyType` berfungsi sebagai **discriminator** yang menentukan tipe konkret dari setiap baris data.

**Struktur tabel `properties`:**

```sql
CREATE TABLE IF NOT EXISTS properties (
    propertyId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    propertyType VARCHAR(100) NOT NULL,        -- ← DISCRIMINATOR STI
    availability TINYINT NOT NULL DEFAULT 1,
    verificationStatus VARCHAR(50) DEFAULT 'Pending',
    flagStatus VARCHAR(50) DEFAULT 'None',
    photos TEXT,
    description TEXT,
    facilities TEXT,
    ownerId INT NOT NULL DEFAULT 1,
    -- Kolom khusus Kost
    gender VARCHAR(50),
    roomType VARCHAR(100),
    -- Kolom khusus Rumah & Kontrakan
    jumlahKamar INT,
    luasTanah DOUBLE,
    -- Kolom khusus Kontrakan
    durasiMinimum INT,
    -- Kolom khusus Apartement
    lantai INT,
    nomorUnit VARCHAR(50),
    tipeUnit VARCHAR(50)
);
```

**Cara kerja STI di DAO:**

Ketika data dibaca dari database, method `mapResultSetToProperty()` di `PropertyDAO.java` membaca kolom `propertyType` lalu menginstansiasi subclass yang tepat:

```java
// File: src/java/DAO/PropertyDAO.java — method mapResultSetToProperty()

private Property mapResultSetToProperty(ResultSet rs) throws SQLException {
    String pType = rs.getString("propertyType");
    Property prop;

    if ("apartemen".equalsIgnoreCase(pType) || "apartement".equalsIgnoreCase(pType)) {
        prop = new Apartement(/* ... lantai, nomorUnit, tipeUnit */);
    } else if ("kost".equalsIgnoreCase(pType)) {
        prop = new Kost(/* ... gender, roomType */);
    } else if ("kontrakan".equalsIgnoreCase(pType)) {
        prop = new Kontrakan(/* ... durasiMinimum, jumlahKamar */);
    } else {
        prop = new Rumah(/* ... jumlahKamar, luasTanah */);  // Default fallback
    }
    return prop;
}
```

Ketika data ditulis ke database, method `addProperty()` menggunakan `instanceof` untuk mengisi kolom yang relevan dan men-set kolom subclass lain ke `NULL`:

```java
// File: src/java/DAO/PropertyDAO.java — method addProperty()

// Set semua kolom subclass ke NULL dulu
pstmt.setNull(12, Types.VARCHAR); // gender
pstmt.setNull(13, Types.VARCHAR); // roomType
// ... dst

// Baru set kolom yang relevan berdasarkan tipe objek
if (p instanceof Kost) {
    Kost k = (Kost) p;
    pstmt.setString(12, k.getGenderType());
    pstmt.setString(13, k.getRoomType());
} else if (p instanceof Rumah) { /* ... */ }
```

### 1.3 Penanganan Konsistensi Data (`equalsIgnoreCase`)

Karena data `propertyType` bisa diinput dengan variasi huruf (misal: `"Kost"`, `"kost"`, `"KOST"`), aplikasi menggunakan **`equalsIgnoreCase()`** di semua titik perbandingan untuk mencegah visual bug:

- **Backend (Java):** `"Kost".equalsIgnoreCase(propertyType)` di `AddPropertyServlet.java` dan `PropertyDAO.java`
- **Frontend (JavaScript):** `(property.type || "").trim().toLowerCase()` di `dashboard.js` dan `detail.jsp` untuk normalisasi sebelum rendering UI

Ini memastikan card properti selalu menampilkan meta-data yang benar (gender/roomType untuk Kost, jumlahKamar/luasTanah untuk Rumah, dsb.) terlepas dari variasi kapitalisasi data di database.

### 1.4 Interface `Reportable` — Polimorfisme Kontrak

Baik `User` maupun `Property` mengimplementasi interface `Reportable`:

```java
public interface Reportable {
    void report();
    String getReportStatus();
    void createReport(Report report);
}
```

Ini memungkinkan kedua entitas berbeda diperlakukan secara **polimorfis** — sebuah method yang menerima parameter `Reportable` bisa memproses objek `Tenant`, `Owner`, `Kost`, atau `Rumah` tanpa perlu tahu tipe spesifiknya.

### 1.5 Berkas Dokumentasi Rinci Kelas Model

Untuk dokumentasi terperinci mengenai seluruh kelas model (atribut, metode, konstruktor, diagram Mermaid UML lengkap, serta implementasi PBO dari ke-15 file di package `model`), silakan merujuk ke berkas dokumentasi terpisah yang baru dibuat:
👉 **[MODEL_CLASSES.md](MODEL_CLASSES.md)**

### 1.6 Hubungan Antar Berkas & Analisis OOP (Tubes PBO)

Untuk dokumentasi lengkap yang memetakan hubungan antar berkas JSP, JS, Controller, DAO, database, serta audit fungsionalitas kelas model, daftar kode mati, dan analisis kesehatan OOP proyek, silakan merujuk ke berkas dokumentasi terpisah:
👉 **[FILE_RELATIONSHIP.md](FILE_RELATIONSHIP.md)**

---

## 2. Mekanisme Manajemen Image & Cloudinary

Manajemen gambar di SewaIn menggunakan integrasi **Cloudinary Cloud Storage** untuk penyimpanan asset yang handal, cepat, dan terdistribusi. File fisik gambar tidak lagi disimpan di filesystem lokal server Tomcat.

### 2.1 Level Kode Java — Cloudinary REST API Integration

**File:**
- `src/java/util/CloudinaryUploader.java`
- `src/java/config/AppConfig.java`

Java Servlet mengunggah gambar menggunakan utility helper `CloudinaryUploader` yang mengirimkan request POST multipart/form-data langsung ke endpoint REST API Cloudinary menggunakan `HttpURLConnection` bawaan Java (tanpa external SDK).

#### Alur Proses Upload:

```
┌─────────────────┐
│  Client Browser  │
│  (Form Upload)   │
└────────┬────────┘
         │ POST multipart/form-data
         ▼
┌─────────────────────────────────────────────────────────┐
│             AddPropertyServlet / EditProperty           │
│  ────────────────────────────────────────────────────── │
│                                                          │
│  1. Baca kredensial dari AppConfig:                      │
│     cloudName, apiKey, apiSecret                         │
│                                                          │
│  2. Generate public ID unik & hitung timestamp           │
│                                                          │
│  3. Buat SHA-1 Signature untuk autentikasi API           │
│                                                          │
│  4. Kirim request POST HTTP dengan data gambar (bytes)   │
│     ke endpoint API Cloudinary                           │
│                                                          │
│  5. Parse JSON response & ambil parameter "secure_url"   │
│                                                          │
└────────────────────────┬────────────────────────────────┘
                         │ secure_url (HTTPS)
                         ▼
             ┌──────────────────────┐
             │ Simpan ke Database   │
             │ (Kolom photos)       │
             └──────────────────────┘
```

#### Kredensial & Konfigurasi:
Kredensial disimpan secara terpusat di file konfigurasi classpath server:
`web/WEB-INF/cloudinary.properties`

```properties
cloudinary.cloud_name=dxffgd86l
cloudinary.api_key=428984953932786
cloudinary.api_secret=***************************
```

### 2.2 Level Database — Penyimpanan URL Cloudinary

URL gambar Cloudinary disimpan di kolom `photos` (tipe `TEXT`) pada tabel `properties` dengan format HTTPS langsung:

```
https://res.cloudinary.com/dxffgd86l/image/upload/v1717654321/sewain/abc123-uuid.jpg,https://res.cloudinary.com/dxffgd86l/image/upload/v1717654321/sewain/def456-uuid.jpg
```

**Aturan format:**
- Menggunakan skema URL HTTPS aman langsung dari CDN Cloudinary.
- Multiple foto dipisahkan dengan koma (`,`).
- Foto pertama adalah cover photo, sisanya galeri.

### 2.3 Level Frontend — Shared JavaScript Image Resolver

**File:** `web/assets/js/property-utils.js`

Fungsi `resolvePropertyImage()` dipisahkan menjadi shared utility module untuk menghindari duplikasi kode dan menangani fallback data legacy secara modular.

#### Kode Lengkap Resolver:

```javascript
function resolvePropertyImage(photoStr) {
    const ctxPath = window.contextPath || "";
    const defaultImg = ctxPath + "/assets/images/default-property.jpg";

    if (!photoStr || typeof photoStr !== 'string') return defaultImg;

    let trimmed = photoStr.trim();
    if (trimmed === "" || trimmed === "null" || trimmed === "[]") return defaultImg;

    let parts = trimmed.split(',');
    if (parts.length === 0 || !parts[0]) return defaultImg;

    let photo = parts[0].trim();
    if (photo === "" || photo === "null") return defaultImg;

    // 1. URL absolut (Cloudinary / Eksternal HTTPS) -> pakai langsung
    if (photo.startsWith("http://") || photo.startsWith("https://")) {
        return photo;
    }

    // 2. Path legacy relative -> tambahkan context path lokal
    if (photo.startsWith("/uploads/")) {
        return ctxPath + photo;
    }
    if (photo.startsWith("uploads/")) {
        return ctxPath + "/" + photo;
    }

    return ctxPath + "/uploads/" + photo;
}
```

#### Decision Tree Visual:

```
Input photoStr
    │
    ├─ null / kosong / "null" ──→ 🖼️ default-property.jpg
    │
    ├─ "http://..." atau "https://..." ──→ ✅ Pakai langsung (URL eksternal)
    │
    ├─ "/Sewain/uploads/foto.jpg" ──→ ✅ Pakai langsung (sudah lengkap)
    │
    ├─ "/uploads/foto.jpg" ──→ 🔧 Tambah ctxPath → "/Sewain/uploads/foto.jpg"
    │                              (Format standar dari database)
    │
    ├─ "/other/path.jpg" ──→ ✅ Pakai langsung (path absolut lain)
    │
    ├─ "uploads/foto.jpg" ──→ 🔧 Tambah ctxPath + "/" → "/Sewain/uploads/foto.jpg"
    │
    └─ "foto.jpg" ──→ 🔧 Buat lengkap → "/Sewain/uploads/foto.jpg"
```

#### Penggunaan di `detail.jsp`:

Di halaman detail, resolver digunakan dua kali:
1. **Cover Image:** `getCoverImage()` memanggil `resolvePropertyImage()` untuk mendapatkan gambar utama
2. **Gallery Grid:** Seluruh array foto di-map melalui resolver:
   ```javascript
   photosArr = photosArr.map(p => resolvePropertyImage(p));
   ```

---

## 3. Manajemen Database untuk Replikasi Tim (Cloning)

### 3.1 Informasi Koneksi Database

**File:** `src/java/database/DatabaseConnection.java`

```java
private static final String URL      = "jdbc:mysql://localhost:3306/sewain.db";
private static final String USER     = "root";
private static final String PASSWORD = "";
```

| Parameter | Nilai Default | Keterangan |
|-----------|---------------|------------|
| Host      | `localhost`   | MySQL lokal via XAMPP/Laragon |
| Port      | `3306`        | Port default MySQL |
| Database  | `sewain.db`   | Nama schema database |
| Username  | `root`        | User default XAMPP |
| Password  | *(kosong)*    | Password default XAMPP |

### 3.2 Cara Backup / Export Database

#### Melalui phpMyAdmin (GUI):

1. Buka **phpMyAdmin** di browser → `http://localhost/phpmyadmin`
2. Pilih database **`sewain.db`** di panel kiri
3. Klik tab **"Export"** di bagian atas
4. Pilih method: **"Quick"** (atau "Custom" untuk opsi lebih detail)
5. Format: **SQL**
6. Klik **"Go"** → file `sewain.db.sql` akan terunduh

#### Melalui Command Line:

```bash
# Export dengan mysqldump
mysqldump -u root -p sewain.db > sewain.sql

# Jika tanpa password (default XAMPP)
mysqldump -u root sewain.db > sewain.sql
```

> **Tips:** Simpan file `sewain.sql` ke **root directory project** agar ter-track oleh Git dan bisa diakses anggota tim saat clone.

### 3.3 Panduan Setup untuk Anggota Tim (Clone)

Berikut langkah-langkah yang harus dilakukan anggota tim setelah melakukan `git clone`:

#### Step 1: Clone Repository

```bash
git clone <URL_REPOSITORY>
```

#### Step 2: Install Prerequisites

Pastikan software berikut sudah terinstall:
- **JDK 8+** (Java Development Kit)
- **Apache Tomcat 9.x** (Web Server)
- **XAMPP / Laragon** (MySQL Server + phpMyAdmin)
- **NetBeans IDE** (opsional, tapi direkomendasikan karena project menggunakan format NetBeans)

#### Step 3: Buat Database di phpMyAdmin

1. Buka **phpMyAdmin** → `http://localhost/phpmyadmin`
2. Klik **"New"** di panel kiri
3. Masukkan nama database: **`sewain.db`**
4. Collation: **`utf8mb4_general_ci`**
5. Klik **"Create"**

#### Step 4: Import Data

1. Pilih database **`sewain.db`** yang baru dibuat
2. Klik tab **"Import"**
3. Klik **"Choose File"** → pilih file `sewain.sql` dari root project
4. Klik **"Go"** → tunggu hingga proses selesai

> **Catatan:** Jika file `sewain.sql` tidak ada di repository, tabel akan dibuat otomatis oleh `PropertyDAO.initializeDatabase()` saat aplikasi pertama kali dijalankan — namun tanpa data sample.

#### Step 5: Sesuaikan Credential Database (Jika Berbeda)

Jika konfigurasi MySQL lokal Anda berbeda dari default, edit file:

**`src/java/database/DatabaseConnection.java`**

```java
// Sesuaikan 3 konstanta ini:
private static final String URL      = "jdbc:mysql://localhost:3306/sewain.db";
private static final String USER     = "root";       // ← Ganti jika username berbeda
private static final String PASSWORD = "";           // ← Ganti jika ada password
```

**Contoh untuk Laragon dengan password:**
```java
private static final String URL      = "jdbc:mysql://localhost:3306/sewain.db";
private static final String USER     = "root";
private static final String PASSWORD = "laragon_password";
```

#### Step 6: Konfigurasi Tomcat di IDE

1. Buka project di **NetBeans**
2. Klik kanan project → **Properties** → **Run**
3. Pastikan Server diset ke **Apache Tomcat** yang sudah terinstall
4. Context Path harus bernilai: **`/Sewain`**

#### Step 7: Build & Run

1. **Clean & Build:** Klik kanan project → *Clean and Build*
2. **Run:** Tekan `F6` atau klik tombol ▶️
3. Buka browser → `http://localhost:8080/Sewain/`

### 3.4 Checklist Troubleshooting

| Masalah | Penyebab | Solusi |
|---------|----------|--------|
| `Koneksi gagal!` di console | MySQL belum jalan / nama DB salah | Nyalakan MySQL di XAMPP, pastikan DB `sewain.db` ada |
| Gambar gagal diupload | Kredensial Cloudinary salah / limit API tercapai | Periksa file `WEB-INF/cloudinary.properties` |
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | MySQL Connector JAR belum ada | Tambahkan `mysql-connector-j-8.x.x.jar` ke folder `web/WEB-INF/lib/` |
| Halaman blank / error 500 | Context path tidak cocok atau error servlet init | Pastikan context path = `/Sewain` di konfigurasi Tomcat |

---

## 4. Refactoring, Cleanups, & Fitur Dashboard Owner

Berikut adalah peningkatan kualitas kode (refactoring) dan fitur baru yang telah diimplementasikan:

### 4.1 Pemisahan CSS & JS (Separation of Concerns)
JSP dibersihkan dari tag `<style>` inline dan blok `<script>` javascript. Kode visual dipisahkan ke dalam folder asset agar mudah di-*cache* oleh browser dan mudah dimaintain.
- **CSS Baru:** `web/assets/css/detail_owner.css`, `web/assets/css/dashboard_owner.css`
- **JS Baru:** `web/assets/js/detail_owner.js`, `web/assets/js/dashboard_owner.js`
- **Shared Utils:**
  - `property-utils.js` (resolver URL foto)
  - `profile-dropdown.js` (logic menu avatar di navbar)

### 4.2 Edit Properti Tanpa Stepper (1-Page Scroll Form)
Halaman `edit_property.jsp` diubah dari 3-tahap (stepper wizard) menjadi satu halaman scroll biasa. Seluruh field di-render langsung untuk memudahkan owner mengedit data dengan cepat tanpa harus klik tombol Next/Back berulang kali, dengan visual modern yang konsisten.

### 4.3 Modal Konfirmasi Hapus di Dashboard Owner
Sebelumnya, menekan ikon sampah (delete) pada card properti langsung me-redirect owner ke detail page. Sekarang, aksi delete menggunakan modal konfirmasi custom berbasis AJAX/POST di halaman dashboard owner langsung (`dashboard_owner.jsp`), menghemat loading time dan mencegah aksi hapus yang tidak disengaja.

### 4.4 Redesain Halaman Laporan (Report Page)
Halaman laporan properti owner (`report_owner.jsp`) didesain ulang agar identik dengan layout riwayat laporan milik tenant:
- Navbar dihilangkan (fokus pada konten laporan).
- Logo SewaIn dihilangkan untuk minimalisme.
- Menggunakan skema warna hijau sage premium dengan gradient modern yang sesuai.
- Dilengkapi tombol "Kembali ke Dashboard" dengan transisi hover yang halus.

---

## 5. Modul & Fitur Admin (Management, Verification, Flagging, Reports, Activity Logs)

Modul Admin yang terintegrasi penuh dibangun untuk memberikan kontrol menyeluruh atas platform SewaIn, dengan antarmuka modern bernuansa sage premium dan interaksi real-time tanpa refresh halaman (AJAX).

### 5.1 Fungsionalitas Utama Admin
1. **Manage Users (`manageUser`)**:
   - Menampilkan semua user (tenant & owner) yang terdaftar.
   - Melakukan suspensi (suspend) dan re-aktivasi akun secara aman.
   - Proteksi diri (self-suspension prevention) agar admin tidak menangguhkan akunnya sendiri.
2. **Verify Property (`verifyProperty`)**:
   - Mereview detail properti baru yang didaftarkan oleh Owner (status `Pending`).
   - Memberikan persetujuan (*Approve*) atau penolakan (*Reject* dengan menyertakan alasan penolakan).
3. **Flag & Moderasi Properti (`handleReport`)**:
   - Menandai (*Flag*) properti yang terindikasi melanggar aturan platform (misal: spam, scam, harga tidak wajar).
   - Menghapus properti bermasalah secara permanen dengan validasi data relasional (cascade delete).
4. **Monitor Activity Log (`monitorActivity`)**:
   - Mencatat setiap tindakan krusial admin (misalnya: suspensi user, verifikasi properti, pemberian bendera/flag, dan penghapusan properti) secara kronologis ke dalam tabel `activity_logs`.
   - Menampilkan log aktivitas yang rapi dengan pencarian dinamis (real-time filtering).

### 5.2 Skema Tabel Tambahan untuk Admin

#### Tabel `activity_logs`
Mencatat detail kronologi log aktivitas platform.
```sql
CREATE TABLE IF NOT EXISTS activity_logs (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    action VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabel `reports`
Menyimpan data pelaporan properti oleh tenant.
```sql
CREATE TABLE IF NOT EXISTS reports (
    reportId INT AUTO_INCREMENT PRIMARY KEY,
    propertyId INT,
    tenantId INT,
    issueType ENUM('Harga Tidak Sesuai', 'Gambar Tidak Sesuai', 'Indikasi Penipuan/Scam', 'Fasilitas Rusak', 'Lainnya') NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Investigating', 'Resolved', 'Rejected') DEFAULT 'Pending',
    reportDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (propertyId) REFERENCES properties(propertyId) ON DELETE CASCADE
);
```

### 5.3 Implementasi AJAX & Modul JS Admin
Untuk menjamin performa premium, setiap perubahan status (Approve/Reject, Suspend/Activate, Flag/Delete) diproses via **Java Servlet (POST JSON)** dan diubah di sisi client secara dinamis dengan feedback micro-animations.
- **`dashboard_admin.js`**: Mengelola visualisasi statis counter dashboard admin.
- **`manage_user.js`**: Mengirim AJAX POST toggleStatus dan meng-update button badge secara real-time.
- **`verify_property.js`**: Memunculkan popup modal rejection reason dan mengirim data verifikasi.
- **`flag_property.js`**: Menangani pencabutan bendera (*unflag*) dan penghapusan properti.
- **`handle_report.js`**: Memvalidasi laporan pelanggaran masuk dari tenant.
- **`activity_log.js`**: Implementasi client-side search query parser untuk menyaring log secara instan tanpa fetch ulang server.

---

## Lampiran: Ringkasan Struktur Project

```
Sewain/
├── MODEL_CLASSES.md              # Dokumentasi lengkap seluruh kelas model
├── FILE_RELATIONSHIP.md          # Dokumentasi hubungan berkas, kelas model & OOP
├── PROJECT_ARCHITECTURE.md        # Dokumentasi arsitektur umum & panduan setup
├── src/java/
│   ├── config/
│   │   └── AppConfig.java        # Reader properti cloudinary
│   ├── model/                    # Domain Objects (OOP)
│   │   ├── User.java             # Abstract base class
│   │   ├── Tenant.java           # Subclass penyewa
│   │   ├── Owner.java            # Subclass pemilik
│   │   ├── Admin.java            # Subclass administrator
│   │   ├── Property.java         # Abstract base class
│   │   ├── Kost.java             # Subclass kost
│   │   ├── Rumah.java            # Subclass rumah
│   │   ├── Kontrakan.java        # Subclass kontrakan
│   │   ├── Apartement.java       # Subclass apartemen
│   │   ├── Report.java           # Model laporan
│   │   ├── Reportable.java       # Interface polimorfisme
│   │   ├── Wishlist.java         # Model wishlist
│   │   └── ActivityLog.java      # Model log aktivitas admin
│   ├── DAO/                      # Data Access Objects
│   │   ├── UserDAO.java          # Interface DAO user
│   │   ├── UserDAOImpl.java      # Implementasi DAO user (STI)
│   │   ├── PropertyDAO.java      # DAO properti (STI mapper)
│   │   ├── ReportDAO.java        # DAO laporan
│   │   └── ActivityLogDAO.java   # DAO log aktivitas admin
│   ├── controller/               # Servlet Controllers (MVC)
│   │   ├── admin/                # Controller peran admin
│   │   │   ├── AdminActivityServlet.java
│   │   │   ├── AdminDashboardServlet.java
│   │   │   ├── AdminFlagServlet.java
│   │   │   ├── AdminReportServlet.java
│   │   │   ├── AdminUserServlet.java
│   │   │   └── AdminVerifyServlet.java
│   │   ├── auth/                 # Controller autentikasi & profil
│   │   │   ├── LoginController.java
│   │   │   ├── LogoutController.java
│   │   │   ├── RegisterController.java
│   │   │   ├── SwitchRoleController.java
│   │   │   ├── UpdateProfileController.java
│   │   │   └── UpgradeController.java
│   │   ├── owner/                # Controller peran owner
│   │   │   ├── AddPropertyServlet.java
│   │   │   ├── DeletePropertyServlet.java
│   │   │   ├── DetailOwnerServlet.java
│   │   │   ├── EditPropertyServlet.java
│   │   │   ├── OwnerDashboardController.java
│   │   │   └── ReportOwnerServlet.java
│   │   └── tenant/               # Controller peran tenant
│   │       ├── DashboardTenantController.java
│   │       ├── DetailPropertyController.java
│   │       ├── GetLocationsServlet.java
│   │       ├── GetPropertyNamesServlet.java
│   │       ├── ReportHistoryController.java
│   │       ├── SearchPropertyController.java
│   │       ├── SubmitReportController.java
│   │       └── WishlistController.java
│   ├── util/
│   │   └── CloudinaryUploader.java    # Utility upload API Cloudinary
│   └── database/
│       └── DatabaseConnection.java    # Konfigurasi koneksi MySQL
├── web/
│   ├── META-INF/
│   │   └── context.xml           # Konfigurasi Tomcat context
│   ├── WEB-INF/
│   │   ├── cloudinary.properties  # File kredensial API Cloudinary
│   │   └── web.xml               # Web deployment descriptor
│   ├── index.jsp                 # Landing page utama
│   ├── assets/
│   │   ├── css/                  # Stylesheets terpisah per role/modul
│   │   │   ├── admin/
│   │   │   │   ├── activity_log.css
│   │   │   │   ├── admin.css
│   │   │   │   ├── dashboard_admin.css
│   │   │   │   ├── flag_property.css
│   │   │   │   ├── handle_report.css
│   │   │   │   ├── manage_user.css
│   │   │   │   └── verify_property.css
│   │   │   ├── auth/
│   │   │   │   ├── login.css
│   │   │   │   └── register.css
│   │   │   ├── landing/
│   │   │   │   └── landing.css
│   │   │   ├── owner/
│   │   │   │   ├── add_property.css
│   │   │   │   ├── add_property_loader.css
│   │   │   │   ├── dashboard_owner.css
│   │   │   │   ├── detail_owner.css
│   │   │   │   ├── edit_property.css
│   │   │   │   ├── owner.css
│   │   │   │   └── report_owner.css
│   │   │   ├── shared/
│   │   │   │   ├── components.css
│   │   │   │   └── global.css
│   │   │   └── tenant/
│   │   │       ├── dashboard.css
│   │   │       ├── detail.css
│   │   │       ├── profile.css
│   │   │       ├── report_history.css
│   │   │       ├── tenant.css
│   │   │       └── wishlist.css
│   │   └── js/                   # Javascript terpisah per halaman
│   │       ├── admin/
│   │       │   ├── activity_log.js
│   │       │   ├── dashboard_admin.js
│   │       │   ├── flag_property.js
│   │       │   ├── handle_report.js
│   │       │   ├── manage_user.js
│   │       │   └── verify_property.js
│   │       ├── auth/
│   │       │   ├── login.js
│   │       │   └── register.js
│   │       ├── landing/
│   │       │   └── landing.js
│   │       ├── owner/
│   │       │   ├── add_property.js
│   │       │   ├── dashboard_owner.js
│   │       │   ├── detail_owner.js
│   │       │   └── edit_property.js
│   │       ├── tenant/
│   │       │   ├── dashboard.js
│   │       │   ├── profile.js
│   │       │   └── wishlist.js
│   │       ├── profile-dropdown.js
│   │       └── property-utils.js
│   └── pages/
│       ├── auth/
│       │   ├── login.jsp
│       │   └── register.jsp
│       ├── components/
│       │   ├── footer.jsp        # Shared Layout Footer
│       │   ├── navbar.jsp        # Shared Layout Navbar
│       │   └── profile.jsp
│       ├── tenant/
│       │   ├── dashboard.jsp     # Dashboard penyewa
│       │   ├── detail.jsp        # Detail properti + image lightbox
│       │   ├── wishlist.jsp      # Halaman wishlist tenant
│       │   └── report_history.jsp # Riwayat pelaporan tenant
│       ├── owner/
│       │   ├── dashboard_owner.jsp # Dashboard owner
│       │   ├── add_property.jsp   # Form tambah properti owner
│       │   ├── edit_property.jsp   # Form edit 1-page scroll
│       │   ├── detail_owner.jsp    # Detail property view owner
│       │   └── report_owner.jsp    # Laporan/Report owner
│       └── admin/
│           ├── dashboard_admin.jsp # Dashboard pusat statistik admin
│           ├── manage_user.jsp     # Manajemen status suspensi user
│           ├── verify_property.jsp # Review & verifikasi properti baru
│           ├── flag_property.jsp   # Moderasi properti ditandai
│           ├── handle_report.jsp   # Pengelolaan pelaporan dari tenant
│           └── activity_log.jsp    # Monitoring riwayat log aktivitas
└── build/web/                    # Folder runtime Tomcat (auto-generated)
```

---

## 6. Temuan Analisis & Rekomendasi Perbaikan

### 6.1 Berkas Kosong, Yatim Piatu & Masalah Efisiensi File
| No | Nama Berkas / Path | Masalah yang Ditemukan | Rekomendasi Solusi |
|----|--------------------|------------------------|--------------------|
| 1  | `web/assets/css/admin/admin.css` | File CSS kosong boilerplate (~287 bytes) hasil generate NetBeans yang tidak pernah di-import atau digunakan. | Hapus file tersebut dari workspace untuk menjaga kebersihan aset. |
| 2  | `web/assets/css/tenant/tenant.css` | File CSS kosong boilerplate (~283 bytes) hasil generate NetBeans yang tidak pernah di-import atau digunakan. | Hapus file tersebut dari workspace untuk menjaga kebersihan aset. |
| 3  | `web/assets/css/owner/owner.css` | File CSS kosong boilerplate (~283 bytes) hasil generate NetBeans yang tidak pernah di-import atau digunakan. | Hapus file tersebut dari workspace untuk menjaga kebersihan aset. |
| 4  | `src/java/database/TestConnection.java` | File utility tes koneksi DB sementara (~615 bytes) yang sudah tidak dibutuhkan lagi di lingkungan runtime production. | Hapus file tersebut agar folder source controller/database bersih. |
| 5  | `nbproject/private/` | Folder berisi file-file konfigurasi personal editor (NetBeans user-specific settings) yang ter-commit. | Tambahkan folder private ini ke `.gitignore` dan hapus dari version control system (VCS). |

### 6.2 Pelanggaran Single Responsibility (CSS/JS Inline di JSP)
| No | Berkas JSP | Perkiraan Jumlah Baris & Deskripsi Inline | Rekomendasi Lokasi Pemisahan File |
|----|------------|-------------------------------------------|-----------------------------------|
| 1  | `web/pages/tenant/detail.jsp` | ~1010 baris JavaScript inline (baris 134–1144) mengurus lightbox gallery, fetch API, penambahan wishlist, handling pelaporan modal, interaksi DOM, dan date picker logic. | Ekstrak seluruh JavaScript inline ini ke berkas eksternal `web/assets/js/tenant/detail.js` dan hubungkan menggunakan tag `<script src="...">`. |
| 2  | `web/pages/tenant/wishlist.jsp` | ~62 baris JavaScript inline (baris 107–168) yang membajak fetch API global (fetch hijacking) dan membersihkan data `localStorage` secara langsung di JSP. | Satukan atau pindahkan kode ini ke dalam file aset utama `web/assets/js/tenant/wishlist.js`. |
| 3  | `web/pages/owner/dashboard_owner.jsp` | ~7 baris JavaScript inline (baris 238–244) untuk mengelola penyiapan data dynamic modal delete properti. | Pindahkan fungsi JavaScript tersebut ke `web/assets/js/owner/dashboard_owner.js`. |
| 4  | `web/pages/owner/edit_property.jsp` | ~4 baris JavaScript inline (baris 347–350) berisi set data inisiasi variabel original photos dan facilities. | Pindahkan variabel ke data attributes di DOM element (misal `<form data-photos="..." data-facilities="...">`) lalu baca dari file eksternal `edit_property.js`. |

### 6.3 Pelanggaran Prinsip OOP & MVC Architecture
| No | Berkas / Kelas | Komponen Pelanggaran | Deskripsi Detail Masalah | Rekomendasi Refaktor |
|----|----------------|----------------------|--------------------------|----------------------|
| 1  | `web/pages/owner/edit_property.jsp` | Polymorphism / Open-Closed Principle | Scriptlet JSP menggunakan blok `instanceof` secara berantai (Kost, Rumah, Kontrakan, Apartement) untuk merender elemen input spesifik subclass. | Pindahkan logika penentuan form input ke dynamic client-side JS (`edit_property.js`) atau buat partial JSP pages per subtype properti and include secara dinamis. |
| 2  | `web/pages/owner/detail_owner.jsp` | Polymorphism / Encapsulation | JSP melakukan casting manual dengan pengecekan `instanceof` berantai untuk memproses data subclass (seperti `gender`, `luasTanah`, dll.) sebelum dikonversi ke format JSON. | Tambahkan polymorphic method (contoh `getDetailsList()`) di superclass `Property` agar detail spesifik subclass tersembunyikan dan diakses secara polimorfik. |
| 3  | `src/java/controller/tenant/DashboardTenantController.java` | Abstraction & Polymorphism | Method `convertToJson` menggunakan pengecekan `instanceof` berantai secara manual untuk menambahkan atribut spesifik subclass ke JSON response. | Delegasikan serialization ke tingkat model (`Property.toJson()`), atau gunakan library parser JSON seperti Gson/Jackson dengan custom serializer polimorfik. |
| 4  | `src/java/DAO/PropertyDAO.java` | Polymorphism / Single Table Inheritance | Query mapping di layer DAO memisahkan attribute subclass dengan block `instanceof` berantai yang panjang untuk SQL `INSERT`/`UPDATE` manual. | Gunakan framework ORM (seperti Hibernate/JPA) dengan anotasi `@Inheritance(strategy=InheritanceType.SINGLE_TABLE)` guna menangani polymorphism database secara otomatis. |

### 6.4 Inkonsistensi Penamaan & Duplikasi Kode
| No | Lokasi Kode | Bentuk Inkonsistensi / Duplikasi | Rekomendasi Standardisasi |
|----|-------------|----------------------------------|---------------------------|
| 1  | Model Subclass & DB Schema | Bahasa campuran (Indonesian-English Mix) pada atribut data seperti `jumlahKamar`, `luasTanah`, `durasiMinimum` berdampingan dengan `propertyId`, `name`, `price`. | Standardisasi penuh dengan menerjemahkan field ke bahasa Inggris: `roomCount` (jumlahKamar), `landArea` (luasTanah), `minimumDuration` (durasiMinimum), `floor` (lantai), `unitNumber` (nomorUnit). |
| 2  | Kelas `model.Apartement` | Nama kelas menggunakan ejaan campuran (bahasa Prancis/Indonesia "Apartement", bahasa Inggris "Apartment", bahasa Indonesia "Apartemen"). | Ganti nama berkas dan kelas model menjadi `Apartment` (Bahasa Inggris baku) atau `Apartemen` (Bahasa Indonesia baku) untuk konsistensi penamaan. |
| 3  | `web/pages/tenant/dashboard.jsp` | Duplikasi markup/HTML navbar secara lokal alih-alih menggunakan layout bersama secara konsisten. | Gunakan `<jsp:include page="../components/navbar.jsp" />` seperti pada halaman landing index utama untuk meminimalkan redundansi visual. |

### 6.5 Ringkasan Prioritas Rencana Eksekusi
1. **[KRITIS]** → Refaktor blok `instanceof` cascade pada `detail_owner.jsp` dan `edit_property.jsp` ke model-level polymorphic methods atau dynamic script generation di browser untuk memperkuat prinsip OO Open/Closed Principle.
2. **[KRITIS]** → Desentralisasi serialisasi JSON manual di `DashboardTenantController.java` dengan memindahkan formatting data ke method `toJson()` yang di-override oleh masing-masing subclass properti.
3. **[SEDANG]** → Ekstrak JavaScript inline raksasa (~1010 baris) di `web/pages/tenant/detail.jsp` ke berkas terpisah `web/assets/js/tenant/detail.js` untuk mengaktifkan browser caching dan mempercepat load time halaman.
4. **[SEDANG]** → Bersihkan logic patch fetch inline di `web/pages/tenant/wishlist.jsp` ke dalam file external JS `web/assets/js/tenant/wishlist.js`.
5. **[MINOR]** → Hapus berkas stylesheet kosong boilerplate (`admin.css`, `tenant.css`, `owner.css`) yang membebani workspace proyek.
6. **[MINOR]** → Standardisasi schema properties dan model Java agar 100% menggunakan Bahasa Inggris penuh, dan ganti ejaan kelas `Apartement` menjadi `Apartment`.

### 6.4 Analisis Konsistensi Ikon Platform (Font Awesome & SVG)
| No | Entitas / Fitur | Lokasi File | Ikon yang Digunakan saat Ini | Status Konsistensi | Rekomendasi Perbaikan |
|----|-----------------|-------------|------------------------------|--------------------|-----------------------|
| 1  | Tipe: Rumah     | `dashboard.js`, `detail.js`, `detail_owner.js`, `dashboard_owner.jsp`, `add_property.jsp`, `edit_property.jsp` | - Form Selector: `fa-solid fa-house`<br>- Tenant Dashboard: `.png` images (`kamar.png`, `luas.png`) untuk spesifikasi.<br>- Tenant/Owner Detail: SVG Bedroom & Area.<br>- Owner Dashboard: `fa-door-closed` & `fa-maximize`. | MISMATCH | Standardisasikan penggolongan tipe utama menggunakan `fa-solid fa-house`, serta ikon meta-data kamar memakai `fa-solid fa-bed` dan luas tanah menggunakan `fa-solid fa-maximize`. |
| 2  | Tipe: Kost      | `dashboard.js`, `detail.js`, `detail_owner.js`, `dashboard_owner.jsp`, `add_property.jsp`, `edit_property.jsp` | - Form Selector: `fa-solid fa-bed`<br>- Tenant Dashboard & Detail: SVG Venus/Mars & SVG Room Layout.<br>- Owner Dashboard: `fa-solid fa-venus-mars` & `fa-solid fa-bed`. | MISMATCH | Standardisasikan penggolongan tipe utama menggunakan `fa-solid fa-bed`, serta ikon meta-data gender memakai `fa-solid fa-venus-mars` dan tipe kamar menggunakan `fa-solid fa-door-closed`. |
| 3  | Tipe: Apartement| `dashboard.js`, `detail.js`, `detail_owner.js`, `dashboard_owner.jsp`, `add_property.jsp`, `edit_property.jsp` | - Form Selector: `fa-solid fa-building`<br>- Tenant Dashboard & Detail: SVG Building, SVG Unit, SVG Unit Type.<br>- Owner Dashboard: `fa-solid fa-building` (Lantai), `fa-solid fa-door-open` (Unit), `fa-solid fa-expand` (Tipe Unit). | MISMATCH | Standardisasikan penggolongan tipe utama menggunakan `fa-solid fa-building`, serta ikon meta-data lantai memakai `fa-solid fa-layer-group`, nomor unit menggunakan `fa-solid fa-door-closed`, dan tipe unit menggunakan `fa-solid fa-shapes`. |
| 4  | Tipe: Kontrakan | `dashboard.js`, `detail.js`, `detail_owner.js`, `dashboard_owner.jsp`, `add_property.jsp`, `edit_property.jsp` | - Form Selector: `fa-solid fa-door-open`<br>- Tenant Dashboard: `kamar.png` image & SVG Clock.<br>- Tenant/Owner Detail: SVG Bedroom & SVG Calendar.<br>- Owner Dashboard: `fa-solid fa-calendar-days` & `fa-solid fa-door-closed`. | MISMATCH | Standardisasikan penggolongan tipe utama menggunakan `fa-solid fa-door-open`, serta ikon meta-data kamar memakai `fa-solid fa-bed` dan durasi minimum menggunakan `fa-solid fa-calendar-days`. |
| 5  | Menu: Laporan   | `navbar.jsp`, `report_history.jsp`, `report_owner.jsp`, `handle_report.jsp` | - `navbar.jsp`: SVG Warning (Owner), `fa-file-lines` (Tenant).<br>- `report_history.jsp`: SVG Document.<br>- `report_owner.jsp`: `fa-bell-slash` (Empty), `fa-solid fa-circle-check` dkk. (Status).<br>- Admin Sidebar: `fa-solid fa-triangle-exclamation`. | MISMATCH | Standardisasikan semua ikon menu Laporan menjadi `fa-solid fa-triangle-exclamation` dan gunakan Font Awesome terpadu untuk semua status badge laporan. |
| 6  | Menu: Wishlist  | `navbar.jsp`, `dashboard.js`, `detail.js`, `wishlist.jsp`, `wishlist.js` | - Global: SVG Heart (`path d="M20.84 4.61..."`).<br>- Empty state `wishlist.jsp`: SVG Broken Heart. | KONSISTEN | Pertahankan penggunaan visual SVG Heart yang sudah seragam dan beranimasi responsif. |
| 7  | Menu: Profil    | `navbar.jsp`, `verify_property.jsp` (Admin pages) | - `navbar.jsp`: SVG User Circle.<br>- Admin: `fa-solid fa-user-shield`. | MISMATCH | Seragamkan ikon profil di seluruh peran menggunakan `fa-solid fa-circle-user` atau `fa-solid fa-user` Font Awesome. |
| 8  | Menu: Logout    | `navbar.jsp`, `verify_property.jsp` (Admin) | - `navbar.jsp`: SVG Exit Arrow.<br>- Admin: `fa-solid fa-right-from-bracket`. | MISMATCH | Seragamkan ikon keluar di seluruh halaman menggunakan `fa-solid fa-right-from-bracket`. |
| 9  | Menu: Dashboard | `navbar.jsp`, `verify_property.jsp` (Admin) | - `navbar.jsp` (Admin): `fa-solid fa-gauge`.<br>- Admin Sidebar: `fa-solid fa-chart-line`. | MISMATCH | Seragamkan ikon Dashboard menggunakan `fa-solid fa-chart-line` or `fa-solid fa-gauge` di seluruh menu navigasi. |

### 6.5 Ringkasan Dampak Visual Audit
Ketidaksesuaian visual antara berkas halaman tenant (yang didominasi oleh ikon SVG inline dan aset gambar `.png` lokal) dengan berkas halaman owner & admin (yang didominasi oleh pustaka kelas Font Awesome `fa-solid`) menciptakan inkonsistensi estetika saat platform didemokan. 
File-file utama yang memiliki prioritas tinggi untuk segera disinkronkan ikonnya meliputi:
1. `web/assets/js/tenant/dashboard.js` dan `web/assets/js/tenant/detail.js`: Mengganti aset gambar PNG legacy (`kamar.png`, `luas.png`) dan visualisasi spesifikasi SVG inline dengan ikon Font Awesome modern agar selaras dengan dasbor owner.
2. `web/pages/components/navbar.jsp`: Menyeimbangkan dropdown profil dengan mengganti visual SVG mentah menjadi kelas Font Awesome (seperti `fa-circle-user`, `fa-right-from-bracket`, dll.) agar identik dengan visual menu admin.
3. `web/pages/tenant/report_history.jsp` & `web/pages/owner/report_owner.jsp`: Sinkronisasi ikon status pelaporan (Resolved, Investigating, Rejected, Pending) antara sisi tenant dan owner agar memiliki gaya visual/ikon yang sama persis.

---

## 7. Hasil Refactoring & Pembenahan Kode (Juni 2026)

Berdasarkan temuan technical debt di atas, pembenahan total telah berhasil dilaksanakan dengan rincian berikut:

### 7.1 Hasil Perbaikan MVC & Re-Routing (Prioritas Kritis)
- **UpdateProfileController & UserDAOImpl**: Logika kueri SQL mentah (`UPDATE users SET name = ?, phone = ? WHERE userId = ?`) dan pengelolaan objek `Connection` / `PreparedStatement` telah berhasil didelegasikan sepenuhnya ke kelas `UserDAOImpl.java` melalui metode baru `public boolean updateProfile(User user)`. Kelas servlet controller kini murni mengatur alur request/response.
- **Hapus Instansiasi DAO Langsung di JSP**: Pola bypass routing (`new DAO.PropertyDAOImpl()`) di halaman JSP Admin (`verify_property.jsp`, `manage_user.jsp`, `handle_report.jsp`, `flag_property.jsp`, `dashboard_admin.jsp`, `activity_log.jsp`) dan Dashboard Owner (`dashboard_owner.jsp`) telah dihapus secara menyeluruh. Pengambilan data sekarang sepenuhnya melewati Controller Servlet yang relevan, yang menyuplai data ke model request attributes sebelum diteruskan ke JSP.
- **Pembersihan instanceof Berantai di detail.jsp**: Logika `instanceof` berantai yang digunakan untuk membedakan detail visual antar tipe properti di `web/pages/tenant/detail.jsp` telah dihapus. Semua digantikan oleh metode polimorfik `getDetailsList()` pada kelas abstrak `Property` yang secara elegan diimplementasikan secara spesifik di masing-masing subclass (`Kost`, `Rumah`, `Kontrakan`, `Apartement`).
- **Fitur Switch Role (SwitchRoleController)**: Implementasi servlet `SwitchRoleController` untuk memproses perpindahan peran aktif pengguna secara dinamis (Tenant <-> Owner) dalam sesi. Servlet ini melakukan *redirect* langsung ke controller resmi (`/owner/dashboard` dan `/landing`) alih-alih file JSP fisik, guna menjaga kepatuhan arsitektur MVC dan memuat data properti dengan benar. Halaman navigasi `navbar.jsp` juga direfaktor untuk merujuk ke `/switch-role` secara dinamis menggunakan parameter `roleSession` guna mengatasi bug navigasi peran.

### 7.2 Perbaikan Enkapsulasi OOP & Hierarki Model (Prioritas Sedang)
- **Enkapsulasi Kelas Model**: Variabel anggota pada kelas `Flag`, `Verification`, dan `Wishlist` yang sebelumnya bersifat publik atau tidak terproteksi dengan baik kini telah diprivatisasi dengan getter dan setter standar (POJO encapsulation).
- **Hierarki Kelas Pengguna**: Struktur pewarisan kelas `User` serta subclass-nya (`Tenant`, `Owner`, `Admin`) telah dirapikan. Duplikasi kode untuk fungsi-fungsi umum dinaikkan ke level superclass `User` untuk meminimalkan redundansi.

### 7.3 Pemisahan Aset & De-Boilerplate JSP (Prioritas Sedang)
- **Pembersihan CSS/JS Inline**:
  - CSS inline pada `report_owner.jsp` dipindahkan ke `web/assets/css/owner/report_owner.css`.
  - JS inline pada `report_owner.jsp` dipindahkan ke `web/assets/js/owner/report_owner.js`.
  - CSS inline pada `edit_property.jsp` dipindahkan ke `web/assets/css/owner/edit_property.css`.
  - JS inline pada `edit_property.jsp` dipindahkan ke `web/assets/js/owner/edit_property.js`.
  - JS inline pada `profile.jsp` dipindahkan ke `web/assets/js/tenant/profile.js`.
  - JS inline pada `index.jsp` dipindahkan ke `web/assets/js/landing/landing.js`.
- **Komponen Shared Layout**: Komponen navigasi (`navbar.jsp`) dan kaki halaman (`footer.jsp`) yang reusable telah dibuat di folder `web/pages/components/` dan diintegrasikan secara seragam di `index.jsp`, `dashboard.jsp`, dan `dashboard_owner.jsp` untuk menghilangkan boilerplate duplikasi HTML.

---

> **Dokumen ini terakhir diperbarui:** 11 Juni 2026
> **Project:** SewaIn — Tubes PBO Semester 4, Telkom University

