#!/bin/bash

set -e  # Останавливаем скрипт при ошибке

# Устанавливаем Docker
curl -fsSL https://releases.rancher.com/install-docker/26.1.4.sh | sh

# Запускаем Docker, если он не запущен
sudo systemctl enable docker
sudo systemctl start docker

# Создаем директорию для проекта
mkdir -p ~/win && cd ~/win

# Создаем docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "2019"
      RAM_SIZE: "112G"
      CPU_CORES: "32"
      USERNAME: "bill"
      PASSWORD: "DoRiTYPslImpLIAntATiCTOR"
      LANGUAGE: "English"
      DISK_SIZE: "512G"
    volumes:
      - ./data:/storage
    devices:
      - /dev/kvm
    cap_add:
      - NET_ADMIN
    ports:
      - 8888:3389/tcp
      - 8888:3389/udp
    stop_grace_period: 2m
EOF

# Создаем директорию для данных
mkdir -p data

# Запускаем контейнер
sudo docker compose up --build -d

# Вывод сообщения о завершении установки
echo "Windows контейнер успешно запущен! Подключиться можно по RDP: IP-сервера:8888"
