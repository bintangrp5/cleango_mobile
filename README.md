# CleanGo Mobile 🧺✨

CleanGo Mobile adalah aplikasi layanan *laundry on-demand* yang dirancang dengan antarmuka modern, elegan, dan *user-friendly*. Aplikasi ini dibangun menggunakan **Flutter** dan **GetX** untuk manajemen *state* yang efisien, serta dirancang untuk siap terhubung dengan *backend* **Supabase**.

## Fitur Utama 🚀
- **Desain UI/UX Premium:** Antarmuka modern yang memanjakan mata dengan animasi yang halus dan desain responsif.
- **Sistem Navigasi Cerdas:** Menggunakan sistem *Dashboard* dengan *Bottom Navigation Bar* yang persisten (tetap) pada halaman utama (Beranda, Pesanan, Keranjang, Profil).
- **Manajemen Keranjang (Cart):** Pengguna dapat menambah layanan, mengatur perkiraan berat (kg), dan melihat ringkasan harga secara *real-time*.
- **Pelacakan Pesanan:** Memantau status pesanan (Penjemputan, Pencucian, Pengiriman) lengkap dengan estimasi waktu dan peta interaktif.
- **Profil Pengguna:** Halaman manajemen profil dan fitur simulasi ubah kata sandi.

## Teknologi yang Digunakan 🛠️
- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get)
- **Backend (BaaS):** [Supabase](https://supabase.com/) (Autentikasi & Database)
- **Environment Variables:** [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

## Cara Menjalankan Proyek Secara Lokal 💻

1. **Clone repository ini:**
   ```bash
   git clone https://github.com/bintangrp5/cleango_mobile.git
   ```

2. **Masuk ke direktori proyek:**
   ```bash
   cd cleango_mobile
   ```

3. **Install semua dependensi:**
   ```bash
   flutter pub get
   ```

4. **Siapkan Environment Variables:**
   - Salin file `.env.example` menjadi `.env`.
   - Buka file `.env` dan masukkan *URL* dan *Anon Key* Supabase Anda.
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

5. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

## Struktur Folder (Arsitektur) 📁
Aplikasi ini menggunakan pola arsitektur modular dari **GetX Pattern**:
- `lib/app/data`: Berisi *services*, *providers*, dan *models* (misal: `AuthService`).
- `lib/app/modules`: Berisi fitur-fitur utama. Setiap modul dipisahkan menjadi `bindings`, `controllers`, dan `views` (misal: Dashboard, Home, Cart, Profile).
- `lib/app/routes`: Konfigurasi rute navigasi aplikasi.

## Hak Cipta & Lisensi 📄
Dikembangkan untuk proyek Sertifikasi Kompetensi (SERKOM).
