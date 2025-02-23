#!/bin/bash
# Script ini untuk menginstal Docker Engine di Ubuntu.
# Referensi: https://docs.docker.com/engine/install/ubuntu/
# Berikan hak eksekusi pada file tersebut: chmod +x install.sh
# Jalankan script sebagai root atau dengan sudo: sudo ./install.sh

set -e

# Pastikan script dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Script ini harus dijalankan sebagai root. Gunakan sudo."
  exit 1
fi

# Hapus versi lama Docker (jika ada)
echo "Menghapus versi lama Docker (jika ada)..."
apt-get remove -y docker docker-engine docker.io containerd runc || true

# Perbarui index paket apt
echo "Memperbarui index paket apt..."
apt-get update

# Instal dependensi yang diperlukan
echo "Menginstal dependensi yang diperlukan..."
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Tambahkan GPG key resmi Docker
echo "Menambahkan GPG key resmi Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Atur repository Docker
echo "Mengatur repository Docker..."
ARCH=$(dpkg --print-architecture)
CODENAME=$(lsb_release -cs)
echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Perbarui index paket apt lagi
echo "Memperbarui index paket apt lagi..."
apt-get update

# Instal Docker Engine, CLI, containerd, dan plugin terkait
echo "Menginstal Docker Engine, CLI, containerd, dan plugin terkait..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Opsional: Tambahkan user non-root ke grup docker agar tidak perlu menggunakan sudo saat menjalankan Docker
if [ "$SUDO_USER" ]; then
  echo "Menambahkan user $SUDO_USER ke grup docker..."
  usermod -aG docker "$SUDO_USER"
  echo "User $SUDO_USER telah ditambahkan ke grup docker. Harap logout dan login kembali agar perubahan berlaku."
fi

echo "Instalasi Docker selesai dengan sukses."
