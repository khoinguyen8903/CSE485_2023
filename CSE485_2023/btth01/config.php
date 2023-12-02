<?php
$servername = "localhost";
$username = "root";
$password = "Feb4thlmd@";
$dbname = "BTTH01_CSE485";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    // Thiết lập chế độ lỗi để PDO thông báo lỗi nếu có
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Kết nối thành công";
} catch(PDOException $e) {
    echo "Kết nối thất bại: " . $e->getMessage();
}
?>