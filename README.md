# 📦 Laravel Docker Setup (PHP-FPM + Nginx + MySQL)

Struktur proyek ini menggunakan Docker untuk menjalankan aplikasi Laravel secara terisolasi dan terpisah antara service: PHP-FPM (Laravel), Nginx, dan MySQL.

## 📁 Struktur Direktori
```
.
├── Dockerfile
├── README.md
├── docker-compose.yml
├── init.sh
├── mysql
│   └── README.md
├── nginx
│   └── laravel.conf
└── src
    └── README.md

4 directories, 8 files
```

## 🧩 Penjelasan Setiap Bagian

| File/Folder        | Deskripsi Singkat                                                                 |
|--------------------|-----------------------------------------------------------------------------------|
| `Dockerfile`        | Membangun image untuk Laravel berbasis `php:8.2-fpm`, menginstal ekstensi dan Composer |
| `docker-compose.yml` | Menjalankan ketiga service utama (Laravel App, Nginx, MySQL) secara bersamaan     |
| `init.sh`           | Script entrypoint untuk menjalankan `composer install`, migrate, dan `php-fpm`    |
| `nginx/laravel.conf`| Konfigurasi server Nginx agar bisa meneruskan request ke container Laravel        |
| `mysql/`            | Direktori volume untuk penyimpanan data MySQL secara persisten                    |
| `src/`              | Direktori tempat source code Laravel berada                                       |

## ⚙️ Pengaturan Awal Sebelum Menjalankan Docker

Sebelum menjalankan proyek Laravel dengan Docker, pastikan beberapa hal berikut telah disiapkan dan disesuaikan:

1. **Folder `src/`**
   - Pastikan folder `src/` berisi source code Laravel.
   - Jika belum ada, Anda dapat melakukan clone dari repository GitHub menggunakan perintah:
     ```bash
     git clone <url-repo-laravel> src
     ```
   - copy .env-example ke .env
    ```bash
     cp .env-example $PWD/.env
    ```
   - sesuaiakn .env khususnya pada pengaturan database
    ```
    DB_CONNECTION=mysql
    DB_HOST=<nama-service dalam docker-compose.yml>
    DB_PORT=3306
    DB_DATABASE=<environment-dalam-service-db>
    DB_USERNAME=<environment-dalam-service-db>
    DB_PASSWORD=<environment-dalam-service-db>
    ```

2. **File `Dockerfile`**
   - Sesuaikan versi PHP yang dibutuhkan, misalnya `php:8.2-fpm` atau versi lainnya.
   - Tambahkan dependensi yang diperlukan sesuai kebutuhan proyek menggunakan `apt-get install ...`.

3. **File `docker-compose.yml`**
   - Ubah nama container agar sesuai dengan nama proyek (misalnya `ceklab_app`, `ceklab_db`, dll).
   - Atur environment pada service `db` seperti nama database, username, dan password.
   - Pastikan port pada service `nginx` tidak bentrok dengan container Docker lain (misal: gunakan `9002:80`, `9003:80`, dst.).

4. **File `nginx/laravel.conf`**
   - Sesuaikan konfigurasi `fastcgi_pass` dengan nama container Laravel yang digunakan pada `docker-compose.yml`.
   - Contoh:
     ```nginx
     fastcgi_pass ceklab_app:9000;
     ```

---

💡 **Tips Tambahan:**
- Gunakan perintah `docker-compose up --build` saat pertama kali menjalankan, agar perubahan pada Dockerfile ikut diterapkan.
- Simpan `.env` Laravel dan `.env.docker` (jika ada) agar konfigurasi tidak ikut ter-commit ke Git.


## ✅ Cara Menjalankan

```bash
docker-compose up -d --build
```

## ⚙️ Pengaturan Laravel

Setelah semua container berjalan, masuk ke dalam container Laravel menggunakan:

```bash
docker exec -it <nama-container> bash
```

contoh

``` bash
docker exec -it ceklab_app bash
```
📌 **Jalankan Perintah Laravel**

Setelah berada di dalam container, jalankan:

1. Migrate database (jika pertama kali):
``` bash
php artisan migrate
```

2. Seeder (jika ingin menambahkan data awal):
``` bash
php artisan db:seed
```


