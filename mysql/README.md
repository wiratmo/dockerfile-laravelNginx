# 🐬 Folder `mysql/`

Folder ini digunakan untuk menyimpan **data volume MySQL** yang digunakan oleh container Docker MySQL. Semua file database (data, tabel, dan konfigurasi runtime MySQL) akan otomatis tersimpan di sini oleh Docker saat container dijalankan.

---

## 📌 Tujuan

Docker akan melakukan **mount volume** ke folder ini agar data MySQL tetap **tersimpan secara persisten** meskipun container dihapus atau dibuat ulang.

---

## ⚠️ Peringatan

- **Jangan hapus isi folder ini**, kecuali Anda memang ingin mereset database dari awal.
