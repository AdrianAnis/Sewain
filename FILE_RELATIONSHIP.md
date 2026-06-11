# Hubungan Antar File, Kegunaan Kelas, & Analisis OOP — SewaIn

Dokumentasi ini menyajikan analisis mendalam mengenai struktur kode, alur komunikasi antar-komponen, audit kegunaan kelas-kelas model, pemetaan fitur per peran (*role*), temuan kode yang tidak digunakan atau menyimpang dari arsitektur MVC, serta evaluasi kesehatan prinsip Pemrograman Berorientasi Objek (OOP) pada proyek **SewaIn**.

---

## DAFTAR ISI
1. [SECTION 1: Pendahuluan & Gambaran Umum Sistem](#section-1-pendahuluan--gambaran-umum-sistem)
2. [SECTION 2: Peta Hubungan Antar Berkas (File Relationship Map)](#section-2-peta-hubungan-antar-berkas-file-relationship-map)
3. [SECTION 3: Analisis Keberadaan & Penggunaan Kelas Model (Model Audit)](#section-3-analisis-keberadaan--penggunaan-kelas-model-model-audit)
4. [SECTION 4: Fitur per Peran & Alur Kerja (Feature Mapping)](#section-4-fitur-per-peran--alur-kerja-feature-mapping)
5. [SECTION 5: Kode Bermasalah, Tidak Digunakan & MVC Bypass (Issues & Dead Code)](#section-5-kode-bermasalah-tidak-digunakan--mvc-bypass-issues--dead-code)
6. [SECTION 6: Analisis Kesehatan Prinsip OOP & Kesimpulan (OOP Health Audit)](#section-6-analisis-kesehatan-prinsip-oop--kesimpulan-oop-health-audit)

---

## SECTION 1: Pendahuluan & Gambaran Umum Sistem

**SewaIn** adalah platform berbasis web untuk menyewa properti (Kost, Rumah, Kontrakan, dan Apartemen) yang dirancang menggunakan arsitektur **Model-View-Controller (MVC)** dengan **Java Servlet (Controller)**, **JSP (View)**, **MySQL (Database)**, dan **DAO (Data Access Object / Model Helper)**.

Proyek ini bertujuan memisahkan logika bisnis (*backend*), interaksi basis data, dan tampilan pengguna (*frontend*). Namun, dalam implementasinya terdapat perpaduan antara rendering server-side (JSP standard) dan dynamic client-side (AJAX & LocalStorage) yang mempengaruhi bagaimana kelas-kelas model digunakan.

---

## SECTION 2: Peta Hubungan Antar Berkas (File Relationship Map)

Sistem berkomunikasi secara berjenjang dari **Client-Side (JSP + JS)** $\rightarrow$ **Controller (Servlet)** $\rightarrow$ **Data Access Object (DAO)** $\rightarrow$ **Database (MySQL)**.

### 2.1 Diagram Alur Komunikasi Umum

```mermaid
graph TD
    subgraph View (Client-Side)
        JSP[JSP Files]
        JS[JavaScript Files / AJAX]
    end

    subgraph Controller (Server-Side)
        Servlet[Java Servlets]
        Cloudinary[CloudinaryUploader]
    end

    subgraph Model & Data Access
        DAO[DAO Classes: UserDAO, PropertyDAO, ReportDAO, ActivityLogDAO]
        Model[Model Classes: User, Property, Report, ActivityLog, etc.]
        DB[(Database MySQL)]
    end

    JSP -->|Submit Form / Link| Servlet
    JS -->|AJAX Request JSON| Servlet
    Servlet -->|Instantiate / Fill| Model
    Servlet -->|Upload File| Cloudinary
    Servlet -->|Invoke CRUD| DAO
    DAO -->|Query / Update| DB
    DAO -->|Map ResultSet| Model
    Servlet -->|Forward Attribute / JSON| JSP
```

### 2.2 Hubungan Pemanggilan (Call Registry)

| Berkas Pengirim (Caller) | Berkas Penerima (Callee) | Tujuan & Metode Transmisi Data |
| :--- | :--- | :--- |
| **`login.jsp`** | `LoginController` | Mengirim data login (email & password) via POST. |
| **`register.jsp`** | `RegisterController` | Mengirim data registrasi pengguna baru via POST. |
| **`profile.jsp`** | `UpdateProfileController` | Mengirim data edit profil (nama & telepon) via AJAX POST. |
| **`dashboard.jsp`** | `DashboardTenantController` | Menampilkan dashboard utama. Memanggil `/landing` untuk memuat data. |
| **`dashboard.jsp`** | `SearchPropertyController` | Mengirim parameter pencarian/filter via GET ke `/search`. |
| **`dashboard.js`** | `GetLocationsServlet` / `GetPropertyNamesServlet` | AJAX GET untuk mendapatkan daftar autolengkap lokasi dan nama. |
| **`dashboard.js` / `wishlist.js`** | `DetailPropertyController` | Mengarahkan ke rute `/property/detail?id=...` yang memverifikasi sesi, memicu `Tenant.viewProperty()`, memuat properti dari `PropertyDAO`, dan meneruskannya ke `detail.jsp`. |
| **`detail.js`** | `SubmitReportController` | Mengirimkan laporan pelanggaran properti via AJAX POST ke `/submit-report`. |
| **`wishlist.jsp`** | `WishlistController` | Membuka halaman wishlist di `/wishlist`. |
| **`wishlist.js`** | `WishlistController` | AJAX GET ke `/wishlist-properties?ids=...` mengirimkan ID dari LocalStorage. |
| **`dashboard_owner.jsp`** | `OwnerDashboardController` | Memuat data properti dan jumlah laporan tertunda milik pemilik ke `/owner/dashboard`. |
| **`add_property.jsp`** | `AddPropertyServlet` | Mengirim form data properti baru (Multipart) ke `/addProperty`. |
| **`edit_property.jsp`** | `EditPropertyServlet` | Memuat data properti lama via GET ke `/owner/edit` dan mengupdate via POST. |
| **`detail_owner.jsp`** | `DeletePropertyServlet` | Mengirimkan permintaan hapus properti via POST ke `/owner/delete`. |
| **`dashboard_admin.jsp`** | `AdminDashboardServlet` | Mengambil metrik total user, total properti, dll. |
| **`admin_properties.jsp`** | `AdminVerifyServlet` / `AdminFlagServlet` | Mengirim aksi persetujuan properti atau penandaan pelanggaran (Flag). |

---

## SECTION 3: Analisis Keberadaan & Penggunaan Kelas Model (Model Audit)

Di dalam package `model`, terdapat 15 kelas model. Berikut adalah hasil audit riil mengenai penggunaan kelas-kelas tersebut di dalam codebase SewaIn:

### 3.1 Ringkasan Penggunaan Kelas Model

| Kelas Model | Tipe | Status Penggunaan Riil | Keterangan & Analisis Detail |
| :--- | :--- | :--- | :--- |
| **`User`** | `Abstract Class` | **AKTIF** | Mewakili pengguna sistem. Diwarisi oleh `Tenant`, `Owner`, dan `Admin`. Digunakan secara luas dalam otentikasi session. |
| **`Tenant`** | `Concrete Class` | **AKTIF** | Diinstansiasi secara eksplisit oleh `RegisterController` saat pendaftaran (`new Tenant()`) dan `UserDAOImpl` jika kolom `role` bernilai `'Tenant'`. Memiliki metode operasional (`viewProperty()`, `addToWishlist()`, `reportProperty()`) yang dipanggil secara polimorfis oleh controller masing-masing untuk logging aktivitas. |
| **`Owner`** | `Concrete Class` | **AKTIF (Terbatas)** | Diinstansiasi oleh `UserDAOImpl` jika kolom `role` bernilai `'Owner'`. Merupakan kelas kosong (hanya memanggil constructor `super`). |
| **`Admin`** | `Concrete Class` | **AKTIF (Terbatas)** | Diinstansiasi oleh `UserDAOImpl` jika kolom `role` bernilai `'Admin'`. Memiliki metode dummy logging yang tidak pernah dipanggil secara operasional. |
| **`Property`** | `Abstract Class` | **AKTIF** | Kelas dasar untuk semua jenis properti. Diwarisi oleh `Kost`, `Rumah`, `Kontrakan`, dan `Apartement`. Digunakan dalam mapping DAO dan serialisasi JSON. |
| **`Kost`** | `Concrete Class` | **AKTIF** | Diinstansiasi oleh `PropertyDAO` ketika `propertyType` bernilai `'Kost'`. Memuat properti khusus `gender` dan `roomType`. |
| **`Rumah`** | `Concrete Class` | **AKTIF** | Diinstansiasi oleh `PropertyDAO` ketika `propertyType` bernilai `'Rumah'`. Memuat properti khusus `jumlahKamar` dan `luasTanah`. |
| **`Kontrakan`** | `Concrete Class` | **AKTIF** | Diinstansiasi oleh `PropertyDAO` ketika `propertyType` bernilai `'Kontrakan'`. Memuat properti khusus `jumlahKamar` dan `durasiMinimum`. |
| **`Apartement`** | `Concrete Class` | **AKTIF** | Diinstansiasi oleh `PropertyDAO` ketika `propertyType` bernilai `'Apartement'`. Memuat properti khusus `lantai`, `nomorUnit`, dan `tipeUnit`. |
| **`Reportable`**| `Interface` | **AKTIF** | Mengatur implementasi kemampuan objek untuk dilaporkan (`report()`, `getReportStatus()`, dan `createReport()`). Diimplementasikan oleh `User` dan `Property`. |
| **`Report`** | `Concrete Class` | **AKTIF** | Menyimpan data pelaporan properti/penipuan. Diinstansiasi oleh `SubmitReportController` (`new Report()`) dan dibaca oleh `ReportDAO`. |
| **`ActivityLog`**| `Concrete Class` | **AKTIF** | Digunakan saat membaca log aktivitas admin di `AdminActivityServlet` melalui `ActivityLogDAO.getLogs()`. |
| **`Wishlist`** | `Concrete Class` | **TIDAK AKTIF** | **Sama sekali tidak pernah diinstansiasi (`new Wishlist()`)**. Logika penyimpanan wishlist dilakukan secara eksklusif di sisi klien (*localStorage*) dan dimuat ke basis data melalui kueri properti berdasarkan ID. |
| **`Flag`** | `Concrete Class` | **TIDAK AKTIF** | **Sama sekali tidak pernah diinstansiasi**. Status flag properti (apakah properti diblokir/diberi peringatan) diproses sebagai atribut `String` (`flagStatus` & `flagReason`) langsung di tabel `properties`. |
| **`Verification`**| `Concrete Class` | **TIDAK AKTIF** | **Sama sekali tidak pernah diinstansiasi**. Status verifikasi properti (`Pending`, `Approved`, `Rejected`) disimpan sebagai atribut `String` (`verificationStatus`) langsung di tabel `properties`. |

---

## SECTION 4: Fitur per Peran & Alur Kerja (Feature Mapping)

Proyek SewaIn membagi fitur berdasarkan tiga peran pengguna (*role*). Di bawah ini adalah rincian berkas yang terlibat dalam setiap alur kerja fitur:

### 4.1 Fitur Tenant (Penyewa)
*   **Registrasi Akun**:
    *   *Route*: `/register` (POST)
    *   *Berkas Terlibat*: `register.jsp`, `RegisterController.java`, `UserDAOImpl.java` (metode `registerUser()`), model `Tenant.java`.
*   **Pencarian & Penyaringan Hunian**:
    *   *Route*: `/landing` (GET) & `/search` (GET)
    *   *Berkas Terlibat*: `dashboard.jsp`, `dashboard.js`, `DashboardTenantController.java`, `SearchPropertyController.java`, `PropertyDAO.java` (metode `searchProperties()`).
*   **Manajemen Wishlist (Favorit)**:
    *   *Route*: `/wishlist` (GET) & `/wishlist-properties` (GET)
    *   *Berkas Terlibat*: `wishlist.jsp`, `wishlist.js`, `WishlistController.java`, `PropertyDAO.java` (metode `getPropertiesByIds()`). *Catatan: Data disimpan di browser's LocalStorage.*
*   **Pelaporan Pelanggaran / Penipuan Properti**:
    *   *Route*: `/submit-report` (POST)
    *   *Berkas Terlibat*: `detail.jsp` (Report Modal), `detail.js` (`submitReportForm()`), `SubmitReportController.java`, `ReportDAO.java` (metode `insertReport()`), model `Report.java`.
*   **Riwayat Laporan Tenant**:
    *   *Route*: `/report-history` (GET)
    *   *Berkas Terlibat*: `report_history.jsp`, `ReportHistoryController.java`, `ReportDAO.java` (metode `getReportRowsByTenantId()`).

### 4.2 Fitur Owner (Pemilik Properti)
*   **Upgrade Akun ke Owner**:
    *   *Route*: `/upgrade` (POST)
    *   *Berkas Terlibat*: `upgrade.jsp`, `UpgradeController.java`, `UserDAOImpl.java` (metode `upgradeToOwner()`).
*   **Dashboard Properti Pemilik**:
    *   *Route*: `/owner/dashboard` (GET)
    *   *Berkas Terlibat*: `dashboard_owner.jsp`, `OwnerDashboardController.java`, `PropertyDAO.java` (metode `getPropertiesByOwnerId()`), `ReportDAO.java` (metode `getReportsByOwnerId()`).
*   **Menambah Properti Baru**:
    *   *Route*: `/addProperty` (POST)
    *   *Berkas Terlibat*: `add_property.jsp`, `AddPropertyServlet.java`, `CloudinaryUploader.java` (untuk upload gambar), `PropertyDAO.java` (metode `addProperty()`), model properti konkret (`Kost`, `Rumah`, dsb.).
*   **Mengedit & Mengupdate Properti**:
    *   *Route*: `/owner/edit` (GET & POST)
    *   *Berkas Terlibat*: `edit_property.jsp`, `EditPropertyServlet.java`, `CloudinaryUploader.java`, `PropertyDAO.java` (metode `getPropertyById()` & `updateProperty()`).
*   **Menghapus Properti**:
    *   *Route*: `/owner/delete` (POST)
    *   *Berkas Terlibat*: `detail_owner.jsp` (Modal konfirmasi), `DeletePropertyServlet.java`, `PropertyDAO.java` (metode `deleteProperty()`).

### 4.3 Fitur Admin (Pengelola Sistem)
*   **Dashboard & Statistik Admin**:
    *   *Route*: `/admin/dashboard` (GET)
    *   *Berkas Terlibat*: `dashboard_admin.jsp`, `AdminDashboardServlet.java`, `PropertyDAO.java`, `UserDAOImpl.java`, `ReportDAO.java`.
*   **Verifikasi & Persetujuan Properti**:
    *   *Route*: `/admin/verify` (POST)
    *   *Berkas Terlibat*: `admin_properties.jsp`, `AdminVerifyServlet.java`, `PropertyDAO.java` (metode `updateVerificationStatus()`), `ActivityLogDAO.java` (pencatatan aktivitas admin).
*   **Manajemen Flagging (Penandaan Pelanggaran)**:
    *   *Route*: `/admin/flag` (POST)
    *   *Berkas Terlibat*: `admin_properties.jsp`, `AdminFlagServlet.java`, `PropertyDAO.java` (metode `updateFlagStatus()`), `ActivityLogDAO.java`.
*   **Monitoring Aktivitas & Log Admin**:
    *   *Route*: `/admin/logs` (GET)
    *   *Berkas Terlibat*: `admin_logs.jsp`, `AdminActivityServlet.java`, `ActivityLogDAO.java` (metode `getLogs()`), model `ActivityLog.java`.

---

## SECTION 5: Kode Bermasalah, Tidak Digunakan & MVC Bypass (Issues & Dead Code)

Dalam audit kode ini, ditemukan beberapa bagian kode yang menyimpang dari struktur MVC bersih, metode mati, serta ketidaksesuaian fungsional model.

### 5.1 Penyimpangan Pola MVC (Bypass MVC)
*   **Penyelesaian Bypass pada `detail.jsp` (Halaman Detail Properti)**:
    *   *Status*: **Telah Diperbaiki (Juni 2026)**.
    *   *Detail Perbaikan*: Dibuat kelas kontroler baru **`DetailPropertyController.java`** yang memetakan URL `/property/detail`. Kontroler ini bertindak sebagai perantara yang memverifikasi sesi pengguna, memanggil metode `Tenant.viewProperty()` secara polimorfis, mengambil daftar properti dari `PropertyDAO`, menetapkannya sebagai atribut request (`propertiesList`), kemudian meneruskan (*forward*) request ke `detail.jsp`.
    *   *Dampak Positif*: Menghilangkan ketergantungan langsung View (`detail.jsp`) terhadap instansiasi DAO, menjaga kepatuhan pola MVC, serta memastikan bahwa metode model `Tenant.viewProperty()` terpanggil secara tepat waktu saat pengguna mengakses detail properti.

### 5.2 Kode Mati & Kelas Model Tidak Digunakan (Dead Code & Ghost Models)
1.  **Ghost Models (`Wishlist`, `Flag`, `Verification`)**:
    *   Kelas-kelas ini didefinisikan secara formal dalam package `model` untuk memenuhi tugas diagram kelas PBO.
    *   Namun, di dalam kode operasional, objek ini **tidak pernah dibuat** (`new Flag()`, `new Verification()`, `new Wishlist()`). 
    *   Status verifikasi dan flag dikelola sebagai atribut basis data bertipe `String` yang dipetakan ke dalam properti kelas `Property.java`.
    *   Wishlist dikelola secara client-side menggunakan browser `localStorage` dengan penarikan data berbasis kueri `IN (...)` pada `PropertyDAO.java`.
2.  **Metode Dummy Console Log**:
    *   Banyak metode di kelas `User.java` (seperti `login()`, `logout()`, `getProfile()`, `updateProfile()`, `searchProperty()`, `handleReport()`) hanya melakukan perintah cetak konsol (`System.out.println()`) dan tidak dipanggil secara fungsional.
    *   Namun, untuk kelas `Tenant.java` dan `Owner.java`, metode-metode utama seperti `viewProperty()`, `addToWishlist()`, dan `reportProperty()` (pada Tenant) serta `viewProperty()`, `viewReport()`, `addProperty()`, `editProperty()`, dan `deleteProperty()` (pada Owner) telah diimplementasikan secara aktif dan dipanggil secara langsung di controller masing-masing dengan melakukan pengecekan tipe objek (`instanceof`) pada sesi pengguna. Hal serupa berlaku untuk metode dummy di `Admin.java` (`manageUser()`, `verifyProperty()`, dll.) yang masih bersifat pasif.

---

## SECTION 6: Analisis Kesehatan Prinsip OOP & Kesimpulan (OOP Health Audit)

Meskipun terdapat beberapa bagian kode mati, arsitektur OOP dasar dari SewaIn dikategorikan cukup baik dan memenuhi standar proyek PBO semester 4.

### 6.1 Penerapan Empat Pilar OOP
1.  **Inheritance (Pewarisan)**:
    *   Berjalan dengan sangat baik pada kelas pengguna (`User` $\rightarrow$ `Tenant`, `Owner`, `Admin`) dan kelas hunian (`Property` $\rightarrow$ `Kost`, `Rumah`, `Kontrakan`, `Apartement`).
    *   Pewarisan ini menyederhanakan kode dasar dan menjaga konsistensi data yang dibagi bersama.
2.  **Polymorphism (Polimorfisme)**:
    *   **Polimorfisme Dinamis**: Berjalan pada method `toJson()` dan `getSpecificDetails()` di setiap subclass properti. Ketika `PropertyDAO` memanggil `toJson()` pada objek `Property`, sistem secara runtime memanggil implementasi khusus milik subclass terkait (`Kost.toJson()`, `Rumah.toJson()`, dsb.).
    *   **Interface**: Antarmuka `Reportable` berhasil diimplementasikan baik oleh `User` maupun `Property` untuk menyamakan kontrak penanganan pelaporan pelanggaran.
3.  **Encapsulation (Enkapsulasi)**:
    *   Seluruh atribut pada kelas model dideklarasikan dengan akses kontrol `private` atau `protected` dan diakses melalui metode *getter* dan *setter*.
4.  **Abstraction (Abstraksi)**:
    *   Kelas `User` dan `Property` dideklarasikan sebagai kelas abstrak (`abstract class`) untuk mencegah instansiasi langsung secara ilegal tanpa spesifikasi tipe konkret.

### 6.2 Implementasi Single Table Inheritance (STI)
Di sisi basis data, pengembang tidak memisahkan tabel untuk kost, rumah, apartemen, dan kontrakan. Sebaliknya, seluruh hunian disimpan dalam satu tabel tunggal yaitu `properties`.
*   `PropertyDAO.java` bertindak sebagai mapper STI. Saat data ditarik dari basis data, DAO memeriksa nilai kolom discriminator `propertyType`.
*   Berdasarkan nilai tersebut, subclass yang sesuai akan diinstansiasi (`Kost`, `Rumah`, dsb.).
*   Prinsip ini sangat efisien untuk menghindari kueri gabungan (*JOIN*) yang kompleks pada basis data relasional.

### Kesimpulan
Secara keseluruhan, proyek SewaIn menunjukkan desain OOP yang sehat dan terstruktur dengan implementasi STI yang cerdas. Temuan bypass MVC pada `detail.jsp` dan keberadaan kelas-kelas model *ghost* seperti `Flag`, `Verification`, dan `Wishlist` kemungkinan besar merupakan hasil kompromi antara pemenuhan spesifikasi tugas besar (diagram kelas formal) dengan kepraktisan implementasi web servlet berbasis *stateless session* dan efisiensi kueri database.

---
*Dokumen ini dibuat secara otomatis sebagai bagian dari dokumentasi arsitektur SewaIn.*
