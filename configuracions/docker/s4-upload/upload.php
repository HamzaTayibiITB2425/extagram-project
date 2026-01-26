<?php
if (!empty($_POST["caption"])) {
    $image_path = null;
    $image_blob = null;
    
    if (!empty($_FILES['photo']['name']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $image_path = uniqid('img_', true);
        $extension = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
        if (!empty($extension)) {
            $image_path .= '.' . strtolower($extension);
        }
        
        $destination = '/var/www/html/uploads/' . $image_path;
        
        // Guardar en disco
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $destination)) {
            chmod($destination, 0644);
            
            // Leer el archivo para guardarlo en BLOB
            $image_blob = file_get_contents($destination);
        } else {
            error_log("Failed to move uploaded file to: " . $destination);
            $image_path = null;
        }
    }
    
    $db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");
    
    if (!$db->connect_error) {
        // Insertar con BLOB
        $stmt = $db->prepare("INSERT INTO posts (caption, image_path, image_blob) VALUES (?, ?, ?)");
        if ($stmt) {
            $stmt->bind_param("ssb", $_POST["caption"], $image_path, $image_blob);
            $stmt->send_long_data(2, $image_blob); // Enviar BLOB
            $stmt->execute();
            $stmt->close();
        }
        $db->close();
    }
}

header("Location: /extagram.php");
exit();
?>
