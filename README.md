# KosFinder - Aplikasi Pencari & Pengelola Kos Mahasiswa

> **Project Ujian Tengah Semester (UTS) - Pemrograman Berbasis Mobile**  
> Program Studi Pendidikan Teknik Informatika (PTI)  
> Jurusan Teknik Informatika — Fakultas Teknik dan Kejuruan  
> Universitas Pendidikan Ganesha (Undiksha)

---

## 👤 Identitas Pengembang

| Data Mahasiswa | Keterangan |
| :--- | :--- |
| **Nama** | Paulus Yoseph Sina |
| **NIM** | 2415051077 |
| **Kelas** | PTI 5C |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Repositori GitHub** | [https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus](https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus) |

---

## 📱 Deskripsi Project

**KosFinder** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu mahasiswa mencari, memfilter, dan menyimpan informasi kos-kosan di sekitar kampus (khususnya wilayah Singaraja / Kampus Undiksha). 

Aplikasi ini mengintegrasikan seluruh kompetensi dari Worksheet 1 hingga 7:
1. **Git & GitHub Workflow**: Pengembangan bertahap dengan >16 meaningful commits dan milestone terstruktur.
2. **Dart Fundamentals**: Model data berstruktur, null safety, collections, async/await, error & exception handling.
3. **Flutter UI & Reusable Components**: Widget modular, styling modern Material 3, clean widget tree.
4. **Responsive Layout**: Adaptif terhadap 2 kondisi layar (Compact `< 600px` dan Wide `≥ 600px`) menggunakan `LayoutBuilder` dan `NavigationRail`.
5. **Navigation & Passing Data**: Multi-screen navigation (7 screen), passing data model objek antar layar.
6. **State Management & Clean Architecture**: Implementasi `Provider` + `ChangeNotifier` dengan arsitektur berjenjang (*UI → Provider → Repository → Service → REST API / Database*).
7. **REST API Integration**: Pengambilan data katalog kos via HTTP GET dengan JSON parsing, loading state, error state, dan offline fallback dataset.
8. **Backend & Database CRUD**: Integrasi database SQLite (`saved_kos`) dengan operasi CRUD lengkap (*Create, Read, Update, Delete*) serta dialog konfirmasi hapus.

---

## 🚀 Fitur Utama Aplikasi

- [x] **Home / Dashboard**: Banner selamat datang dengan info profil mahasiswa, kartu statistik ringkasan data API dan Database, filter cepat kategori kos, serta daftar rekomendasi kos unggulan.
- [x] **Katalog Kos Responsif (REST API)**:
  - Tampilan otomatis berubah: **1 Kolom List** pada layar smartphone (Compact) dan **2/3 Kolom Grid** pada layar tablet/desktop (Wide).
  - Search bar interaktif berdasarkan nama kos, alamat, atau fasilitas.
  - Filter chip kategori: *Semua*, *Putra*, *Putri*, dan *Campur*.
  - Menangani 4 kondisi UI: *Loading state*, *Error state* (dengan tombol retry), *Empty state* (dengan tombol reset), dan *Data state*.
- [x] **Detail Kos Lengkap**:
  - Banner foto kos dengan gradasi dan status ketersediaan (*Tersedia* / *Penuh*).
  - Informasi harga sewa terformat (`Rp xxx.xxx/bln`) dan rating bintang.
  - Alamat lengkap dan daftar fasilitas kos (*Chips*).
  - Dialog interaksi langsung untuk menghubungi pemilik kos via WhatsApp / Telepon.
  - Tombol simpan ke favorit database melalui BottomSheet interaktif (dilengkapi form rating bintang & catatan survey).
- [x] **Manajemen Favorit (Database SQLite CRUD)**:
  - **Create**: Menambahkan kos favorit baru atau catatan kos mandiri ke database.
  - **Read**: Menampilkan daftar seluruh kos tersimpan beserta rating dan catatan pribadi.
  - **Update**: Mengedit nama kos, harga, tipe, rating bintang, dan catatan survey pada database.
  - **Delete**: Menghapus data tersimpan dengan **AlertDialog konfirmasi** (*Batal* / *Hapus*).
- [x] **Profil & Informasi UTS**: Rincian profil pengembang, info dosen pengampu, checklist spesifikasi UTS, dan diagram arsitektur aplikasi.
- [x] **User Feedback & Validation**:
  - `Form` dengan validasi `GlobalKey<FormState>` (validasi wajib diisi, format angka harga, dan batas minimal karakter).
  - Notifikasi visual menggunakan `SnackBar` untuk setiap operasi simpan, update, dan hapus.

---

## 🛠️ Tech Stack & Dependensi

| Kategori | Teknologi / Package | Fungsi |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.47.3 / Dart 3.13.3 | Framework cross-platform utama |
| **Design System** | Material Design 3 | Komponen UI, ColorScheme Indigo & Teal |
| **State Management** | `provider: ^6.1.1` | Pengelolaan state global (ChangeNotifier) |
| **HTTP / REST API** | `http: ^1.2.0` | Request HTTP GET dan pengambilan data JSON |
| **Database Lokal** | `sqflite: ^2.4.5` & `sqflite_common_ffi: ^2.4.5` | Engine database SQLite untuk Android dan Desktop |
| **Path Utility** | `path: ^1.9.1` | Manajemen lokasi direktori database |
| **Formatting** | `intl: ^0.20.3` | Format angka dan mata uang |
| **Icons** | `cupertino_icons: ^1.0.8` & Material Icons | Kumpulan icon antarmuka aplikasi |

---

## 🌐 Sumber Data & Integrasi

### 1. REST API (Katalog Kos)
- **Metode**: HTTP GET
- **Endpoint**: Hosted JSON pada repositori GitHub KosFinder
- **Model**: `KosModel` (id, name, type, price, address, facilities, imageUrl, rating, isAvailable, description, phoneContact)
- **Karakteristik**: Memiliki mekanisme *Offline Fallback Dataset* via local assets `assets/data/kos_api.json` agar aplikasi tetap dapat dijalankan tanpa kendala saat jaringan offline.

### 2. Database Backend (Saved Kos)
- **Engine**: SQLite Database (`kosfinder_database.db`)
- **Tabel**: `saved_kos`
- **Skema Kolom**:
  1. `id`: `INTEGER PRIMARY KEY AUTOINCREMENT`
  2. `student_id`: `TEXT NOT NULL` (NIM: 2415051077)
  3. `kos_id`: `INTEGER NOT NULL`
  4. `kos_name`: `TEXT NOT NULL`
  5. `address`: `TEXT NOT NULL`
  6. `price`: `INTEGER NOT NULL`
  7. `type`: `TEXT NOT NULL`
  8. `note`: `TEXT NOT NULL`
  9. `rating`: `REAL NOT NULL`
  10. `created_at`: `TEXT NOT NULL`

---

## 🏗️ Struktur Arsitektur Aplikasi

Proyek ini menerapkan prinsip **Clean Architecture & Separation of Concerns**:

```
UI / Screens / Widgets
       ↓ (Consumer / Provider.of)
Providers (State Management - ChangeNotifier)
       ↓ (Dependency Injection)
Repositories (Data Abstraction Layer)
       ↓ (Service Invocation)
Services / Data Sources (REST API & SQLite Database)
```

### Struktur Direktori:

```text
lib/
├── models/
│   ├── kos_model.dart            # Dart model untuk data REST API katalog
│   └── saved_kos_model.dart      # Dart model untuk tabel database SQLite
├── services/
│   ├── api_service.dart          # HTTP client & parsing JSON dengan offline fallback
│   └── database_service.dart     # SQLite Database helper (OpenDB, Create, Query, CRUD)
├── repositories/
│   ├── kos_repository.dart       # Abstraksi repositori katalog kos
│   └── saved_kos_repository.dart # Abstraksi repositori database kos tersimpan
├── providers/
│   ├── kos_provider.dart         # State management katalog (search, filter, loading, error)
│   └── saved_kos_provider.dart   # State management CRUD database tersimpan
├── screens/
│   ├── home_screen.dart          # Navigation shell (BottomNavigationBar & NavigationRail)
│   ├── dashboard_screen.dart     # Dashboard statistik & rekomendasi
│   ├── kos_list_screen.dart      # Katalog kos responsif (list/grid)
│   ├── kos_detail_screen.dart    # Detail kos & interaksi kontak/bookmark
│   ├── favorites_screen.dart     # Daftar kos tersimpan (CRUD Read & Delete)
│   ├── add_saved_kos_screen.dart # Form tambah kos/catatan baru (CRUD Create)
│   ├── edit_saved_kos_screen.dart# Form edit catatan & rating (CRUD Update)
│   └── profile_screen.dart       # Profil mahasiswa & informasi UTS
├── widgets/
│   ├── kos_card_widget.dart      # Reusable card katalog kos
│   ├── saved_kos_card_widget.dart# Reusable card kos tersimpan
│   ├── status_badge_widget.dart  # Reusable badge status ketersediaan & gender
│   ├── rating_stars_widget.dart  # Reusable rating bintang (display & interactive)
│   └── custom_button_widget.dart # Reusable button dengan loading state
└── main.dart                     # Entry point & MultiProvider registration
```

---

## 📐 Responsive Layout Implementation

Aplikasi secara dinamis beradaptasi berdasarkan lebar layar:
- **Compact Screen (`< 600px` - Smartphone)**:
  - Navigasi utama menggunakan `BottomNavigationBar` di bagian bawah layar.
  - Katalog kos dirender dalam bentuk `ListView.builder` (1 kolom vertikal).
- **Wide Screen (`≥ 600px` - Tablet / Layar Lebar / Landscape)**:
  - Navigasi utama berpindah ke sisi samping kiri menggunakan `NavigationRail`.
  - Katalog kos secara otomatis beralih menjadi `GridView.builder` (2 atau 3 kolom) dengan proporsi kartu yang pas dan terhindar dari RenderFlex overflow.

---

## 📋 Daftar Screen (7 Screen Fungsional)

1. **Dashboard / Home Screen**: Menampilkan sambutan, profil singkat mahasiswa, statistik API vs Database, filter kategori cepat, dan rekomendasi kos.
2. **Kos List Screen**: Katalog kos responsif dengan search, filter gender, dan 4 state (loading, error, empty, data).
3. **Kos Detail Screen**: Tampilan lengkap fasilitas, alamat, foto, kontak pemilik, dan bottom sheet untuk menyimpan kos.
4. **Favorites Screen**: Daftar kos yang tersimpan pada database lokal SQLite dengan fitur hapus berkonfirmasi dialog.
5. **Add Saved Kos Screen**: Form validasi untuk membuat entri kos dan catatan baru ke database (Create).
6. **Edit Saved Kos Screen**: Form validasi untuk memperbarui data catatan dan rating di database (Update).
7. **Profile Screen**: Kartu identitas mahasiswa, info dosen pengampu, ringkasan arsitektur, dan tautan repositori.

---

## 📌 Riwayat Git Commit Milestone

| No | Hash Commit | Pesan Commit | Milestone |
| :---: | :---: | :--- | :--- |
| 1 | `c50936c` | Initial commit | Project Initialization |
| 2 | `efabfa7` | Initialize Flutter UTS project and setup architecture folders | Architecture Setup |
| 3 | `3068953` | Resolve merge conflict and sync with remote | Git Workflow |
| 4 | `e0597e4` | Build initial application UI and implement responsive layouts | Basic UI & Responsive |
| 5 | `b02a91c` | Implement application state management and integrate REST API | REST API & State |
| 6 | `3dee85b` | Fix syntax errors in responsive catalog screen | Bug Fixing |
| 7 | `1e4afdc` | Add CRUD form screens for Add and Edit features | Initial Forms |
| 8 | `6505c8b` | Add BottomNavigationBar, DetailScreen passing data, and custom reusable widgets | Navigation & Widgets |
| 9 | `fe2ebce` | Add KosFinder models and local REST API JSON data source | KosFinder Models & Data |
| 10 | `ebedb26` | Implement services and repositories for REST API and database integration | Service & Repository Pattern |
| 11 | `61a471d` | Implement state management for Kos catalog and saved database with Provider | Provider State Management |
| 12 | `87aadeb` | Add modular reusable widgets for KosFinder UI components | Reusable Custom Widgets |
| 13 | `286dc95` | Implement Kos catalog, detail, and database CRUD screens with form validation | Screen & CRUD Implementation |
| 14 | `16e3ea6` | Add responsive MainNavigation with NavigationRail and user Profile screen | Responsive NavRail & Profile |
| 15 | `e9a05ba` | Configure MultiProvider injection and application entry point | MultiProvider Injection |
| 16 | `6020018` | Refactor codebase to remove legacy templates and enhance UI responsiveness | Code Refinement & Lint Fix |
| 17 | *(Final)* | Finalize UTS mobile application and complete comprehensive README documentation | Finalization & README |

---

## 🚀 Cara Menjalankan Project

### Prasyarat
- Flutter SDK (≥ 3.13.0)
- Android Studio / VS Code dengan Flutter Extension
- Perangkat Android (Emulator atau HP Fisik dengan USB Debugging aktif)

### Langkah-langkah:
1. **Clone Repositori**:
   ```bash
   git clone https://github.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus.git
   cd UTS_2415051077_Paulus
   ```

2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Analisis Kode (Linter)**:
   ```bash
   flutter analyze
   ```

4. **Jalankan Pengujian Otomatis**:
   ```bash
   flutter test
   ```

5. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

6. **Build APK Release**:
   ```bash
   flutter build apk --release
   ```
   File APK hasil build akan berlokasi di:  
   `build/app/outputs/flutter-apk/app-release.apk`  
   (Dapat diganti nama menjadi `UTS_2415051077_Paulus.apk` untuk pengumpulan).

---

*Selamat menggunakan aplikasi KosFinder!*
