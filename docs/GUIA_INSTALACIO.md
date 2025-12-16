# Guia d'Installacio - Projecte Extagram

## 1. Requisits

- Ubuntu Server 22.04 LTS
- 4 GB RAM minim
- 20 GB disc

---

## 2. Sprint 1: Maquina Unica

### 2.1 Installar NGINX
```bash
sudo apt install -y nginx
sudo systemctl enable nginx
```

### 2.2 Installar PHP-FPM
```bash
sudo apt install -y php-fpm php-mysql php-gd php-curl
```

### 2.3 Installar MySQL
```bash
sudo apt install -y mysql-server
sudo mysql_secure_installation
```

### 2.4 Crear Base de Dades
```sql
CREATE DATABASE extagram_db;
CREATE USER 'extagram_admin'@'localhost' IDENTIFIED BY 'pass123';
GRANT ALL PRIVILEGES ON extagram_db.* TO 'extagram_admin'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE extagram_db.posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post TEXT NOT NULL,
    photourl VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2.5 Configurar NGINX
```bash
sudo nano /etc/nginx/sites-available/extagram
```

```nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/extagram;
    index extagram.php;
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
    
    location /uploads/ {
        alias /var/www/extagram/uploads/;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/extagram /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl restart nginx
```

### 2.6 Desplegar Aplicacio
```bash
sudo mkdir -p /var/www/extagram/uploads
sudo cp src/* /var/www/extagram/
sudo chown -R www-data:www-data /var/www/extagram
sudo chmod -R 755 /var/www/extagram
sudo chmod 775 /var/www/extagram/uploads
```

---

## 3. Sprint 2-3: Docker

### 3.1 Installar Docker
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

### 3.2 Desplegar
```bash
cd configuracions/docker
docker-compose up -d --build
docker-compose ps
```

---

## 4. Resolucio de Problemes

```bash
# Verificar serveis
docker-compose ps
sudo systemctl status nginx php8.1-fpm mysql

# Permisos
sudo chown -R www-data:www-data /var/www/extagram/uploads

# Logs
docker-compose logs -f
sudo tail -f /var/log/nginx/error.log
```

---

Document creat per: Equip Extagram
