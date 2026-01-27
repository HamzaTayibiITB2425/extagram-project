<?php
if (!empty($_GET['id'])) {
    $id = intval($_GET['id']);
    
    $db = new mysqli(
    getenv('DB_HOST') ?: 's7-database',
    getenv('DB_USER') ?: 'extagram_admin',
    getenv('DB_PASSWORD') ?: 'pass123',
    getenv('DB_NAME') ?: 'extagram_db'
    );
    
    if ($db->connect_error) {
        http_response_code(500);
        die("Error de conexión: " . $db->connect_error);
    }
    
    $stmt = $db->prepare("SELECT image_blob, image_path FROM posts WHERE id = ?");
    if (!$stmt) {
        http_response_code(500);
        die("Error en prepare: " . $db->error);
    }
    
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    // Usar bind_result para BLOBs grandes
    $stmt->bind_result($image_blob, $image_path);
    
    if ($stmt->fetch()) {
        $stmt->close();
        $db->close();
        
        // Verificar que el BLOB tiene datos
        if ($image_blob !== null && strlen($image_blob) > 0) {
            // Detectar tipo MIME basado en los primeros bytes
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime = finfo_buffer($finfo, $image_blob);
            finfo_close($finfo);
            
            // Si no se puede detectar, usar el nombre del archivo
            if (!$mime || $mime === 'application/octet-stream') {
                $extension = strtolower(pathinfo($image_path, PATHINFO_EXTENSION));
                if ($extension === 'png') {
                    $mime = 'image/png';
                } elseif ($extension === 'jpg' || $extension === 'jpeg') {
                    $mime = 'image/jpeg';
                } elseif ($extension === 'gif') {
                    $mime = 'image/gif';
                } else {
                    $mime = 'image/png'; // Default
                }
            }
            
            header('Content-Type: ' . $mime);
            header('Content-Length: ' . strlen($image_blob));
            header('Content-Disposition: inline; filename="recovered_' . basename($image_path) . '"');
            header('Cache-Control: no-cache');
            
            echo $image_blob;
            exit;
        } else {
            http_response_code(404);
            echo "BLOB está vacío o es NULL (bytes: " . strlen($image_blob ?? '') . ")";
            exit;
        }
    } else {
        $stmt->close();
        $db->close();
        http_response_code(404);
        echo "Post con ID=$id no existe en la base de datos";
        exit;
    }
} else {
    http_response_code(400);
    echo "Falta parámetro ID en la URL";
    exit;
}
?>
