<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>Extagram</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>

<form method="POST" enctype="multipart/form-data" action="/upload.php">
    <input type="text" name="post" placeholder="Escriu alguna cosa...">
    <input id="file" type="file" name="photo" accept="image/*"
           onchange="document.getElementById('preview').src=window.URL.createObjectURL(event.target.files[0])">
    <label for="file">
        <img id="preview" src="/preview.svg" alt="Preview">
    </label>
    <input type="submit" value="Publicar">
</form>

<?php
$db = new mysqli("s7-database", "extagram_admin", "pass123", "extagram_db");

if ($db->connect_error) {
    die("Error de connexio: " . $db->connect_error);
}

$result = $db->query("SELECT * FROM posts ORDER BY id DESC");

if ($result) {
    while ($fila = $result->fetch_assoc()) {
        echo "<div class='post'>";
        echo "<p>" . htmlspecialchars($fila['post']) . "</p>";
        if (!empty($fila['photourl'])) {
            echo "<img src='/uploads/" . htmlspecialchars($fila['photourl']) . "'>";
        }
        echo "</div>";
    }
}

$db->close();
?>

</body>
</html>
