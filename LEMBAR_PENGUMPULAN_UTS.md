# PROJECT UJIAN TENGAH SEMESTER
## PEMROGRAMAN MOBILE
### Mobile Application Mini Project
**Implementasi Git, Dart, Flutter UI, Responsive Layout, Navigation, State Management, Architecture, REST API, Backend, dan Database**

| Identitas | Keterangan |
| :--- | :--- |
| **Nama** | Paulus Yoseph Sina |
| **NIM** | 2415051077 |
| **Kelas** | PTI 5C |
| **Tema Project** | KosFinder |
| **URL GitHub** | [https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus](https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus) |

**Sifat:** Individual | **Durasi:** 2 Minggu | **Tema:** Bebas  
**Dosen:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom  
**Teaching Assistant:** Made Yuda Sadewa, S.Pd.  

---

### A. Deskripsi Penugasan
Project UTS merupakan tugas individual untuk membangun satu aplikasi mobile Flutter yang mengintegrasikan kompetensi dari Worksheet 1–7. Mahasiswa bebas menentukan tema aplikasi, tetapi aplikasi harus memenuhi spesifikasi minimum teknis dan menunjukkan proses pengembangan yang nyata melalui Git/GitHub.

> **Fokus penilaian:** Project tidak dinilai hanya dari banyaknya fitur, tetapi juga dari kualitas UI, struktur kode, state management, arsitektur aplikasi, integrasi API/database, error handling, serta konsistensi proses pengembangan pada Git.

---

### B. Cakupan Materi yang Wajib Terintegrasi

| Materi | Implementasi pada Project |
| :--- | :--- |
| **Git & GitHub** | Repository `UTS_2415051077_Paulus`, branch `main`, push bertahap 19 commit terstruktur, README lengkap, riwayat pengembangan milestone. |
| **Dart Fundamentals** | Class/model (`KosModel`, `SavedKosModel`), collection, functions, null safety, Future, async/await, exception handling. |
| **Flutter UI Fundamentals** | Widget tree, layout (Scaffold, AppBar, Row, Column, Card, Padding, Expanded), ListView.builder, GridView.builder, custom widgets, styling Material 3. |
| **Responsive Layout** | LayoutBuilder & MediaQuery adaptif: Compact (`< 600px`, 1 kolom List, BottomNav) & Wide (`≥ 600px`, 2/3 kolom Grid, NavigationRail). |
| **Navigation & User Interaction** | Multi-screen (7 screen), passing data objek model, form input, validasi `GlobalKey<FormState>`, feedback SnackBar & Dialog. |
| **State Management & Architecture** | Provider (`ChangeNotifierProvider`, `Consumer`), Clean Architecture (*UI → Provider → Repository → Service → REST API / Database*). |
| **REST API & Database Integration** | GET API JSON parsing via HTTP, backend database SQLite (`saved_kos`), operasi CRUD lengkap, loading, error, empty state. |

---

### C. Spesifikasi Minimum Project

#### 1. Screen dan Navigasi
- [x] Minimal 6 screen fungsional. Splash screen tidak dihitung. *(Aplikasi memiliki 7 screen fungsional)*.
- [x] Harus terdapat Home/Dashboard, List/Catalog, Detail, Create/Add, Edit, dan minimal satu screen tambahan.
- [x] Terdapat navigasi list → detail.
- [x] Terdapat passing data antar-screen (`KosModel` & `SavedKosModel`).
- [x] Menggunakan NavigationBar/BottomNavigationBar, Drawer, atau NavigationRail sebagai navigasi utama. *(Responsif: BottomNavigationBar pada layar HP dan NavigationRail pada layar lebar/tablet)*.

> **Implementasi 7 Screen:**
> 1. `DashboardScreen`: Ringkasan profil mahasiswa, banner rekomendasi, quick category, dan kartu statistik API & DB.
> 2. `KosListScreen`: Katalog kos responsif dari REST API dengan pencarian (search) dan filter chip.
> 3. `KosDetailScreen`: Tampilan detail foto, fasilitas, alamat, status ketersediaan, kontak pemilik, dan bookmark DB.
> 4. `FavoritesScreen`: Menampilkan data kos tersimpan dari database SQLite dengan dialog konfirmasi hapus.
> 5. `AddSavedKosScreen`: Form validasi input data kos & review baru ke database (Create).
> 6. `EditSavedKosScreen`: Form validasi untuk memperbarui catatan & rating di database (Update).
> 7. `ProfileScreen`: Identitas mahasiswa, dosen pengampu, diagram arsitektur aplikasi, dan panduan.

#### 2. Flutter UI dan Reusable Components
- [x] Menggunakan widget dasar secara tepat: Scaffold, AppBar, Text, Image/Icon, Card/Container, Row, Column, Padding, SizedBox, Expanded/Flexible.
- [x] Menggunakan ListView dan/atau GridView untuk menampilkan data.
- [x] Minimal 3 reusable/custom widgets. *(Menggunakan 5 reusable widgets: `KosCardWidget`, `SavedKosCardWidget`, `StatusBadgeWidget`, `RatingStarsWidget`, dan `CustomButtonWidget`)*.
- [x] UI tidak dibuat seluruhnya dalam satu file/widget besar *(Terpisah rapi dalam folder `screens/` dan `widgets/`)*.

#### 3. Responsive Layout
- [x] Minimal memiliki 2 kondisi layout: compact dan wide/expanded.
- [x] Menggunakan MediaQuery, LayoutBuilder, atau pendekatan responsif ekuivalen.
- [x] Tidak terdapat RenderFlex overflow pada screen utama.
- [x] Minimal satu list/grid berubah susunannya berdasarkan lebar layar *(Katalog kos berubah dari 1 kolom ListView pada compact `< 600px` menjadi 2 atau 3 kolom GridView pada wide `≥ 600px`)*.

#### 4. REST API
- [x] Menggunakan minimal 1 REST API.
- [x] Operasi GET wajib *(Endpoint GET katalog kos via HTTP client)*.
- [x] Data API benar-benar ditampilkan pada UI, bukan hanya di console.
- [x] Response JSON dikonversi menjadi Dart Model (`KosModel`).
- [x] Memiliki loading state, error state (dengan retry button), dan empty state (dengan reset search).

#### 5. Backend & Database
- [x] Menggunakan minimal 1 backend database *(Database SQLite menggunakan package `sqflite` & `sqflite_common_ffi`)*.
- [x] Minimal 1 tabel utama dengan primary key + minimal 4 field data *(Tabel `saved_kos` memiliki 10 field: `id`, `student_id`, `kos_id`, `kos_name`, `address`, `price`, `type`, `note`, `rating`, `created_at`)*.
- [x] CRUD database wajib: Create, Read, Update, Delete.
- [x] Delete menggunakan confirmation dialog (`AlertDialog` konfirmasi hapus).
- [x] Aplikasi tidak menyimpan credential server sensitif seperti service_role key.

#### 6. State Management
- [x] Menggunakan Provider + ChangeNotifier (`KosProvider` & `SavedKosProvider`).
- [x] Shared application state tidak boleh seluruhnya menggunakan setState().
- [x] Minimal state yang dikelola: loading, data, error.
- [x] Minimal satu shared state: favorite/saved list kos dan filter kategori terintegrasi.

#### 7. Mobile Application Architecture
Minimal gunakan struktur:
```text
lib/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
├── widgets/
└── main.dart
```
> **Prinsip minimum:** UI → State/Provider → Repository → Service/Data Source → REST API / Database. Screen tidak melakukan query HTTP/database secara langsung. *(Telah diimplementasikan 100% konsisten)*.

#### 8. Form, Validation, dan User Feedback
- [x] Minimal 1 Form dengan validation *(Menggunakan `GlobalKey<FormState>` dengan validator input nama, alamat, harga angka, dan catatan)*.
- [x] Minimal 4 bentuk user interaction (Tap card, Search bar text input, Filter chips, Star rating touch, FloatingActionButton, Dialog konfirmasi).
- [x] Menggunakan SnackBar, Dialog, atau feedback lain untuk operasi penting.
- [x] Aplikasi menangani validation error, network/API error, dan database error.

---

### D. Ketentuan Git & GitHub - WAJIB
- [x] Repository digunakan sejak awal project dengan commit bertahap.
- [x] Minimal 16 meaningful commits *(Aplikasi ini memiliki **19 meaningful commits**)*.

#### Riwayat Milestone Commit:
1. `c50936c` — Initial commit
2. `efabfa7` — Initialize Flutter UTS project and setup architecture folders
3. `3068953` — Resolve merge conflict and sync with remote
4. `e0597e4` — Build initial application UI and implement responsive layouts
5. `b02a91c` — Implement application state management and integrate REST API
6. `3dee85b` — Fix syntax errors in responsive catalog screen
7. `1e4afdc` — Add CRUD form screens for Add and Edit features
8. `6505c8b` — Add BottomNavigationBar, DetailScreen passing data, and custom reusable widgets
9. `fe2ebce` — Add KosFinder models and local REST API JSON data source
10. `ebedb26` — Implement services and repositories for REST API and database integration
11. `61a471d` — Implement state management for Kos catalog and saved database with Provider
12. `87aadeb` — Add modular reusable widgets for KosFinder UI components
13. `286dc95` — Implement Kos catalog, detail, and database CRUD screens with form validation
14. `16e3ea6` — Add responsive MainNavigation with NavigationRail and user Profile screen
15. `e9a05ba` — Configure MultiProvider injection and application entry point
16. `6020018` — Refactor codebase to remove legacy templates and enhance UI responsiveness
17. `a84b73d` — Finalize UTS mobile application and complete comprehensive README documentation
18. `c547330` — Optimize Gradle build configurations and clean gitignore
19. `ebd5125` — Update commit history table in README.md

#### README GitHub - WAJIB
- [x] Nama project dan deskripsi singkat.
- [x] Nama, NIM, dan kelas.
- [x] Daftar fitur.
- [x] Tech stack.
- [x] REST API yang digunakan.
- [x] Backend/database yang digunakan.
- [x] Struktur arsitektur aplikasi.
- [x] Screenshot aplikasi / deskripsi antarmuka.
- [x] Cara menjalankan project.

---

### E. Tema Project dan Contoh Ruang Lingkup: KosFinder
- [x] Search kos berdasarkan nama/lokasi.
- [x] Filter sederhana berdasarkan harga atau fasilitas/kategori.
- [x] List/Grid kos yang responsif.
- [x] Detail kos dengan passing data.
- [x] Favorite / Saved Kos sebagai shared state.
- [x] Form tambah/edit catatan kos.
- [x] CRUD data saved/favorite pada database.
- [x] Loading, empty, dan error state.
- [x] SnackBar/AlertDialog untuk feedback.
- [x] **Fitur tambahan hasil kreativitas mahasiswa:**
  - Fitur dialog langsung untuk menghubungi pemilik kos via WhatsApp/Telepon.
  - Widget interaktif pemilihan rating bintang (1.0 - 5.0).
  - Mekanisme *Offline Fallback Dataset* jika server/koneksi internet mengalami gangguan.
  - Responsive NavigationRail pada orientasi tablet/desktop landscape.

---

### G. Deliverables
- [x] URL GitHub Repository: [https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus](https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus)
- [x] APK aplikasi: `UTS_2415051077_Paulus.apk` (Telah dibuild dalam mode release)
- [x] PDF dokumentasi singkat.
- [x] Screenshot screen: Home, List, Detail, Create, Edit, responsive layout, API data, database data.
- [x] Bukti `git log --oneline` (19 commits).
- [x] README.md lengkap pada repository.
- [x] Demo aplikasi dan penjelasan arsitektur.

**Format repository:** `UTS_NIM_Nama`  
**Format APK:** `UTS_2415051077_Paulus.apk`  
**Format dokumentasi:** `UTS_2415051077_Paulus.pdf`  

---

### I. Minimum Requirement Checklist

| Komponen | Minimum | Cek | Catatan Implementasi |
| :--- | :---: | :---: | :--- |
| Screen fungsional | $\ge 6$ | ☑ | **7 Screen**: Dashboard, List, Detail, Favorites, Add, Edit, Profile |
| Dart Model | $\ge 2$ | ☑ | `KosModel` (REST API) & `SavedKosModel` (SQLite) |
| Reusable Widget | $\ge 3$ | ☑ | `KosCard`, `SavedKosCard`, `StatusBadge`, `RatingStars`, `CustomButton` |
| Responsive condition | $\ge 2$ | ☑ | Compact (`<600px`, 1 Kolom List) & Wide (`≥600px`, 2/3 Kolom Grid) |
| REST API | $\ge 1$ | ☑ | GitHub Raw Hosted API Katalog Kos |
| REST GET | Wajib | ☑ | Operasi GET dengan HTTP client & offline fallback |
| Backend database | $\ge 1$ | ☑ | SQLite Database (`kosfinder_database.db`) |
| Tabel database | $\ge 1$ | ☑ | Tabel `saved_kos` |
| Field tabel | $\ge 4$ + ID | ☑ | **10 Field Kolom** (`id`, `student_id`, `kos_id`, `kos_name`, `address`, `price`, `type`, `note`, `rating`, `created_at`) |
| CRUD database | 4 operasi | ☑ | Create, Read, Update, Delete (lengkap) |
| State management | Provider/ekuivalen | ☑ | `MultiProvider` + `ChangeNotifier` (`KosProvider`, `SavedKosProvider`) |
| Multi-screen navigation | Wajib | ☑ | BottomNavigationBar, NavigationRail, & MaterialPageRoute |
| Passing data | Wajib | ☑ | Mengirim objek `KosModel` ke Detail & `SavedKosModel` ke Edit |
| Form + validation | Wajib | ☑ | `GlobalKey<FormState>` pada halaman Tambah & Edit Catatan |
| SnackBar/Dialog | Wajib | ☑ | `AlertDialog` konfirmasi hapus & `SnackBar` feedback simpan/edit |
| Loading state | Wajib | ☑ | Indikator loading saat fetch REST API & simpan database |
| Error state | Wajib | ☑ | Layar error informatif lengkap dengan tombol retry/coba lagi |
| Empty state | Wajib | ☑ | Layar kosong saat pencarian tidak ditemukan & favorit masih kosong |
| Meaningful Git commits | $\ge 16$ | ☑ | **19 Commits** bertahap |
| Push per milestone | Wajib | ☑ | Seluruh commit telah di-push ke remote GitHub |
| README | Wajib | ☑ | `README.md` terstruktur rapi tanpa konflik |
| GitHub URL | Wajib | ☑ | Repositori aktif dan dapat diakses publik |

---

### J. Identitas dan Bukti Pengumpulan

- **Nama Project:** KosFinder Singaraja Mobile App (`uts_2415051077_paulus`)
- **Tema:** KosFinder (Aplikasi Pencarian dan Penyimpanan Informasi Kos Mahasiswa)
- **URL GitHub Repository:** [https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus](https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus)
- **Nama Branch Utama:** `main`
- **REST API yang digunakan:** GitHub Raw Hosted REST API Endpoint (`https://raw.githubusercontent.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus/main/assets/data/kos_api.json`) dengan parsing JSON model Dart & Offline Fallback Dataset.
- **Backend/Database yang digunakan:** SQLite Database (`kosfinder_database.db`) via `sqflite` & `sqflite_common_ffi` dengan tabel `saved_kos` (10 field kolom, operasi CRUD lengkap).
- **Jumlah Screen:** 7 Screen Fungsional (`DashboardScreen`, `KosListScreen`, `KosDetailScreen`, `FavoritesScreen`, `AddSavedKosScreen`, `EditSavedKosScreen`, `ProfileScreen`).
- **Jumlah Meaningful Commit:** 20 Commit Terstruktur.
- **Hash Commit Final:** `b84e37c`
- **Link APK / File APK:** `UTS_2415051077_Paulus.apk` (Tersedia pada root folder proyek: `d:\KULIAH\SEMESTER 5\Pemrograman Berbasis Mobile\UTS dan UAS\uts_2415051077_paulus\UTS_2415051077_Paulus.apk` serta pada direktori build `build\app\outputs\flutter-apk\app-release.apk`).
- **Catatan kendala utama:**
  1. *Penanganan Cross-Drive Incremental Build pada Android Gradle*: Terjadi kendala pembacaan root file berbeda antara drive `C:\` (Pub Cache) dan `D:\` (Folder Proyek) pada kompilasi Kotlin, yang berhasil diselesaikan secara tuntas dengan menyetel `kotlin.incremental=false` pada file `android/gradle.properties`.
  2. *Kompatibilitas Multi-Platform SQLite Database*: Menyesuaikan engine SQLite agar dapat berjalan lancar di lingkungan pengujian desktop Windows maupun perangkat fisik Android dengan mengimplementasikan `sqflite_common_ffi` dan `sqflite`.
  3. *Penerapan Clean Architecture*: Memastikan alur data terisolasi secara disiplin sesuai materi Worksheet 6 (*Screen/UI $\rightarrow$ Provider $\rightarrow$ Repository $\rightarrow$ Service/Data Source*) tanpa adanya pemanggilan query database atau HTTP langsung dari widget UI.

---
*Status: Seluruh persyaratan UTS telah selesai 100% dan siap dinilai.*
