#!/bin/bash

set -e  # Exit jika ada error
set -o pipefail

echo "🟡 [init.sh] Memulai setup container Laravel..."

cd /var/www/html || exit 1

echo "⏳ Menunggu koneksi ke database..."
until php artisan migrate:status > /dev/null 2>&1; do
  >&2 echo "🕐 Database belum siap... retry dalam 10 detik"
  sleep 10
done

# ====================================
# 3. Install composer dependencies
# ====================================
echo "📦 Menjalankan composer install..."
composer install --no-dev --optimize-autoloader

# ====================================
# 4. Set permission folder penting
# ====================================
echo "🔐 Mengatur permission folder storage dan cache..."
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# ====================================
# 5. Artisan commands (safe)
# ====================================
echo "⚙️ Artisan commands..."
php artisan key:generate --force || echo "❌ Gagal generate key"
php artisan config:clear || true
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true
php artisan migrate:fresh  || true
php artisan db:seed || true

echo "✅ Laravel siap diakses di http://localhost:9002 🚀"

# ====================================
# 6. Jalankan PHP-FPM foreground
# ====================================
exec php-fpm

