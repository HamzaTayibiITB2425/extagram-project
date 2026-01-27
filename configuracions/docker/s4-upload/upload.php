<?php
if (!empty($_POST["caption"])) {
    $image_path = null;
    $image_blob = null;
    
    // Solo procesar imagen si se ha subido
    if (!empty($_FILES['photo']['name']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $image_path = uniqid('img_', true);
        $extension = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
        if (!empty($extension)) {
            $image_path .= '.' . strtolower($extension);
        }
        
        $destination = '/var/www/html/uploads/' . $image_path;
        
        // Guardar en DISCO
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $destination)) {
            chmod($destination, 0644);
            
            // Leer para BLOB
            $image_blob = file_get_contents($destination);
        } else {
            error_log("Failed to move uploaded file to: " . $destination);
            $image_path = null;
        }
    }
    
    // Conectar a base de datos
    $db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");
    
    if (!$db->connect_error) {
        // IMPORTANTE: Solo usar send_long_data si hay BLOB
        if ($image_blob !== null) {
            $stmt = $db->prepare("INSERT INTO posts (caption, image_path, image_blob) VALUES (?, ?, ?)");
            $stmt->bind_param("ssb", $_POST["caption"], $image_path, $image_blob);
            $stmt->send_long_data(2, $image_blob);
        } else {
            // Sin imagen, insertar solo caption
            $stmt = $db->prepare("INSERT INTO posts (caption, image_path, image_blob) VALUES (?, ?, ?)");
            $null_blob = null;
            $stmt->bind_param("sss", $_POST["caption"], $image_path, $null_blob);
        }
        
        $stmt->execute();
        $stmt->close();
        $db->close();
    }
}

header("Location: /extagram.php");
exit();
?>
