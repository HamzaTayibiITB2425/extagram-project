<?php
if (!empty($_GET['id'])) {
    $id = intval($_GET['id']);
    
    $db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");
    
    if (!$db->connect_error) {
        $stmt = $db->prepare("SELECT image_path FROM posts WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $post = $result->fetch_assoc();
        
        if ($post && !empty($post['image_path'])) {
            $filePath = '/var/www/html/uploads/' . $post['image_path'];
            if (file_exists($filePath)) {
                unlink($filePath);
            }
        }
        
        $stmt = $db->prepare("DELETE FROM posts WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $stmt->close();
        $db->close();
    }
}

header("Location: /extagram.php");
exit();
?>
