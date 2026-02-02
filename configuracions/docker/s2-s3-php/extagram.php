<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Extagram</title>
    <link rel="stylesheet" href="/style.css">
    <style>
        :root {
            --insta-gradient: radial-gradient(circle at 30% 107%, #fdf497 0%, #fdf497 5%, #fd5949 45%, #d6249f 60%, #285AEB 90%);
        }
        * { 
            box-sizing: border-box; 
            margin: 0;
            padding: 0;
        }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; 
            background: var(--insta-gradient) no-repeat center center fixed; 
            background-size: cover;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
        }
        .brand {
            color: white;
            font-size: 48px;
            text-align: center;
            margin: 20px 0 30px 0;
            font-weight: 400;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            letter-spacing: -1px;
        }
        .card {
            background-color: #121212;
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.6);
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input[type="text"] {
            width: 100%;
            padding: 14px;
            background: #262626;
            border: 1px solid #363636;
            color: white;
            border-radius: 8px;
            outline: none;
            font-size: 14px;
        }
        input[type="text"]::placeholder {
            color: #8e8e8e;
        }
        input[type="text"]:focus {
            border-color: #0095f6;
        }
        input[type="file"] {
            display: none;
        }
        .file-label {
            display: block;
            cursor: pointer;
        }
        #preview {
            max-width: 100%;
            border-radius: 12px;
            background: #262626;
            border: 2px dashed #363636;
            padding: 20px;
            transition: all 0.3s;
        }
        #preview:hover {
            border-color: #0095f6;
        }
        .btn {
            background: #0095f6;
            color: white;
            border: none;
            padding: 14px;
            width: 100%;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            font-size: 15px;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #0081db;
        }
        .post {
            background-color: #121212;
            padding: 20px;
            border-radius: 20px;
            margin-bottom: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.6);
        }
        .post-header {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }
        .delete-btn {
            background: rgba(255, 68, 68, 0.2);
            color: #ff4444;
            border: 1px solid #ff4444;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .delete-btn:hover {
            background: #ff4444;
            color: white;
            transform: scale(1.1);
        }
        .post p {
            color: #efefef;
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 15px;
            word-wrap: break-word;
        }
        .post img {
            max-width: 100%;
            border-radius: 12px;
            margin-top: 10px;
        }
        .error {
            color: #ff4444;
            background: rgba(255, 68, 68, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .empty-state {
            text-align: center;
            color: #8e8e8e;
            padding: 40px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1 class="brand">Extagram</h1>
    
    <div class="card">
        <form method="POST" enctype="multipart/form-data" action="/upload.php">
            <input type="text" name="caption" placeholder="Escriu alguna cosa..." required>
            
            <input id="file" type="file" name="photo" accept="image/*"
                   onchange="previewImage(event)">
            
            <label for="file" class="file-label">
                <img id="preview" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100' width='300' height='200'%3E%3Crect width='100' height='100' fill='%23262626' rx='5'/%3E%3Ctext x='50' y='50' text-anchor='middle' fill='%238e8e8e' font-size='6'%3EClica per afegir imatge%3C/text%3E%3C/svg%3E" alt="Preview">
            </label>
            
            <button type="submit" class="btn">Publicar</button>
        </form>
    </div>

    <?php
    $db = new mysqli(
    getenv('DB_HOST'),
    getenv('DB_USER'),
    getenv('DB_PASSWORD'),
    getenv('DB_NAME')
    );

    if ($db->connect_error) {
        echo "<div class='card'><div class='error'>Error de connexió: " . htmlspecialchars($db->connect_error) . "</div></div>";
    } else {
        $result = $db->query("SELECT * FROM posts ORDER BY id DESC");

        if ($result && $result->num_rows > 0) {
            while ($fila = $result->fetch_assoc()) {
                echo "<div class='post'>";
                echo "<div class='post-header'>";
                echo "<button class='delete-btn' onclick=\"if(confirm('Segur que vols eliminar aquest post?')) window.location.href='/delete.php?id=" . $fila['id'] . "'\">✕</button>";
                echo "</div>";
                
                // Compatibilidad: 'caption' (nuevo) o 'post' (viejo)
                $texto = $fila['caption'] ?? $fila['post'] ?? '';
                if (!empty($texto)) {
                    echo "<p>" . htmlspecialchars($texto) . "</p>";
                }
                
                // Compatibilidad: 'image_path' (nuevo) o 'photourl' (viejo)
                $imagen = $fila['image_path'] ?? $fila['photourl'] ?? '';
                if (!empty($imagen)) {
                    echo "<img src='/uploads/" . htmlspecialchars($imagen) . "' alt='Post image'>";
                }
                // Fallback: mostrar desde BLOB si no hay archivo en disco
                elseif (!empty($fila['image_blob'])) {
                    echo "<img src='data:image/jpeg;base64," . base64_encode($fila['image_blob']) . "' alt='Post image from BLOB'>";
                }
                
                echo "</div>";
            }
        } else {
            echo "<div class='card'><div class='empty-state'>No hi ha posts encara. Sigues el primer en publicar!</div></div>";
        }

        $db->close();
    }
    ?>
</div>

<script>
function previewImage(event) {
    const preview = document.getElementById('preview');
    const file = event.target.files[0];
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.border = 'none';
            preview.style.padding = '0';
        }
        reader.readAsDataURL(file);
    }
}
</script>

</body>
</html>
