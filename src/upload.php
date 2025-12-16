<?php
if (!empty($_POST["post"])) {
    
    $photoid = null;
    
    if (!empty($_FILES['photo']['name']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $photoid = uniqid('img_', true);
        $extension = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
        if (!empty($extension)) {
            $photoid .= '.' . strtolower($extension);
        }
        
        $destination = '/var/www/html/uploads/' . $photoid;
        
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $destination)) {
            chmod($destination, 0644);
        } else {
            $photoid = null;
        }
    }
    
    $db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");
    
    if (!$db->connect_error) {
        $stmt = $db->prepare("INSERT INTO posts (post, photourl) VALUES (?, ?)");
        if ($stmt) {
            $stmt->bind_param("ss", $_POST["post"], $photoid);
            $stmt->execute();
            $stmt->close();
        }
        $db->close();
    }
}

header("Location: /extagram.php");
exit();
?>
