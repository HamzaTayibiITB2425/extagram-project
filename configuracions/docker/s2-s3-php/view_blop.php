<?php
// Configuración de conexión
$host = 's7-database';
$db   = 'extagram_db';
$user = 'root';          // Cambia a 'extagram_admin' si es el que usas
$pass = 'rootpass123';   // Cambia a 'pass123' si es el que usas

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    if (isset($_GET['id'])) {
        // Buscamos el contenido binario (BLOB)
        $stmt = $pdo->prepare("SELECT image_blob FROM posts WHERE id = ?");
        $stmt->execute([$_GET['id']]);
        $post = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($post && !empty($post['image_blob'])) {
            // Importante: Esto le dice al navegador que lo que viene NO es texto, es una imagen
            header("Content-Type: image/png"); 
            echo $post['image_blob'];
            exit;
        } else {
            echo "La imagen no existe en el campo BLOB de la base de datos.";
        }
    } else {
        echo "Falta el ID del post.";
    }
} catch (Exception $e) {
    echo "Error de conexión: " . $e->getMessage();
}
