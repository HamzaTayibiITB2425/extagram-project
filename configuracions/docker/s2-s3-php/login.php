<?php
session_start();
$message = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $ldap_host = "ldap://s8-ldap";
    $ldap_dn = "cn=admin,dc=extagram,dc=com";
    $ldap_pass = "rootpass123";
    
    $user = $_POST['username'];
    $pass = $_POST['password'];

    // 1. Conectar a LDAP
    $ds = ldap_connect($ldap_host);
    ldap_set_option($ds, LDAP_OPT_PROTOCOL_VERSION, 3);

    if ($ds) {
        // 2. Buscar al usuario para obtener su DN completo (Distinguished Name)
        // Nos bindamos como admin primero para tener permiso de buscar
        $bind = ldap_bind($ds, $ldap_dn, $ldap_pass);
        
        if ($bind) {
            $search = ldap_search($ds, "dc=extagram,dc=com", "(cn=$user)");
            $info = ldap_get_entries($ds, $search);
            
            if ($info["count"] > 0) {
                // El usuario existe, ahora intentamos comprobar SU contraseña
                $user_dn = $info[0]["dn"];
                $user_bind = @ldap_bind($ds, $user_dn, $pass);
                
                if ($user_bind) {
                    $_SESSION['user'] = $user;
                    header("Location: extagram.php"); // Redirigir a la app principal
                    exit;
                } else {
                    $message = "Contraseña incorrecta.";
                }
            } else {
                $message = "Usuario no encontrado.";
            }
        } else {
            $message = "Error interno: No se pudo conectar al directorio.";
        }
        ldap_close($ds);
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login Extagram</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #fafafa; }
        .login-container { background: white; padding: 40px; border: 1px solid #dbdbdb; width: 350px; text-align: center; }
        input { width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #dbdbdb; border-radius: 3px; box-sizing: border-box;}
        button { width: 100%; padding: 10px; background-color: #0095f6; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; margin-top: 10px;}
        .error { color: red; font-size: 14px; margin-bottom: 10px; }
        h1 { font-family: 'Cookie', cursive; font-size: 3rem; margin-bottom: 20px;}
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Extagram</h1>
        <?php if($message) echo "<p class='error'>$message</p>"; ?>
        <form method="POST">
            <input type="text" name="username" placeholder="Usuario " required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button type="submit">Iniciar Sesión</button>
        </form>
        <p style="font-size: 12px; color: #8e8e8e; margin-top: 20px;">
           ¿No tienes cuenta? Contacta al administrador LDAP.
        </p>
    </div>
</body>
</html>
