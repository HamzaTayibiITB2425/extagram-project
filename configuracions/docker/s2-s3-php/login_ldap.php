<?php
// Datos del servidor LDAP (S8)
$ldap_host = "ldap://s8-ldap";
$ldap_dn = "cn=admin,dc=extagram,dc=com";
$ldap_password = "rootpass123";

echo "<h2>Prueba de Conexión LDAP</h2>";

// 1. Conectar
$connect = ldap_connect($ldap_host);
ldap_set_option($connect, LDAP_OPT_PROTOCOL_VERSION, 3);

if ($connect) {
    echo "Conectado al servidor LDAP... <br>";
    
    // 2. Intentar Login como Admin
    $bind = @ldap_bind($connect, $ldap_dn, $ldap_password);
    
    if ($bind) {
        echo "<h3 style='color:green'>¡ÉXITO: Autenticación Admin Correcta!</h3>";
        echo "El sistema está listo para validar usuarios.";
    } else {
        echo "<h3 style='color:red'>ERROR: Credenciales Incorrectas</h3>";
    }
    
    // 3. Buscar usuarios (Listar todos)
    $result = ldap_search($connect, "dc=extagram,dc=com", "(cn=*)");
    $entries = ldap_get_entries($connect, $result);
    
    echo "<br><b>Entradas encontradas: </b>" . $entries["count"];
    
} else {
    echo "No se pudo conectar al contenedor S8.";
}
?>
