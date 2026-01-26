<?php
if (!empty($_GET['id'])) {
    $id = intval($_GET['id']);
    
    $db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");
    
    if (!$db->connect_error) {
        $stmt = $db->prepare("SELECT image_blob, image_path FROM posts WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $post = $result->fetch_assoc();
        
        if ($post && !empty($post['image_blob'])) {
            header('Content-Type: image/png');
            header('Content-Disposition: inline; filename="recovered_' . $post['image_path'] . '"');
            echo $post['image_blob'];
            exit;
        } else {
            http_response_code(404);
            echo "Imagen no encontrada en BLOB";
        }
        
        $stmt->close();
        $db->close();
    } else {
        echo "Error de conexión a base de datos";
    }
} else {
    echo "Falta parámetro ID";
}
?>
