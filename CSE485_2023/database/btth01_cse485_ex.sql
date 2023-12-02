-- Liệt kê các bài viết về các bài hát thuộc thể loại Nhạc trữ tình
SELECT baiviet.*
FROM baiviet
JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai
WHERE theloai.ten_tloai = 'Nhạc trữ tình';

--	Liệt kê các bài viết của tác giả “Nhacvietplus” 
SELECT baiviet.*
FROM baiviet
JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
WHERE tacgia.ten_tgia = 'Nhacvietplus';

-- Liệt kê các thể loại nhạc chưa có bài viết cảm nhận nào.
SELECT theloai.*
FROM theloai
WHERE NOT EXISTS (
    SELECT 1
    FROM baiviet
    WHERE baiviet.ma_tloai = theloai.ma_tloai
        AND baiviet.noidung IS NOT NULL
);

-- Liệt kê các bài viết với các thông tin sau: mã bài viết, tên bài viết, tên bài hát, tên tác giả, tên thể loại, ngày viết
SELECT baiviet.ma_bviet, baiviet.tieude, baiviet.ten_bhat, tacgia.ten_tgia, theloai.ten_tloai, baiviet.ngayviet
FROM baiviet
JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai;

--	Tìm thể loại có số bài viết nhiều nhất 
SELECT theloai.ten_tloai, COUNT(baiviet.ma_bviet) AS so_bai_viet
FROM theloai
LEFT JOIN baiviet ON theloai.ma_tloai = baiviet.ma_tloai
GROUP BY theloai.ten_tloai
ORDER BY so_bai_viet DESC
LIMIT 1;

--	Liệt kê 2 tác giả có số bài viết nhiều nhất 
SELECT tacgia.ten_tgia, COUNT(baiviet.ma_bviet) AS so_bai_viet
FROM tacgia
LEFT JOIN baiviet ON tacgia.ma_tgia = baiviet.ma_tgia
GROUP BY tacgia.ten_tgia
ORDER BY so_bai_viet DESC
LIMIT 2;
--Liệt kê các bài viết về các bài hát có tựa bài hát chứa 1 trong các từ “yêu”, “thương”, “anh”, “em” 
SELECT *
FROM baiviet
WHERE ten_bhat LIKE '%yêu%' OR ten_bhat LIKE '%thương%' OR ten_bhat LIKE '%anh%' OR ten_bhat LIKE '%em%';
--	Liệt kê các bài viết về các bài hát có tiêu đề bài viết hoặc tựa bài hát chứa 1 trong các từ “yêu”, “thương”, “anh”, “em” 
SELECT *
FROM baiviet
WHERE tieude LIKE '%yêu%' OR tieude LIKE '%thương%' OR tieude LIKE '%anh%' OR tieude LIKE '%em%'
   OR ten_bhat LIKE '%yêu%' OR ten_bhat LIKE '%thương%' OR ten_bhat LIKE '%anh%' OR ten_bhat LIKE '%em%';
-- 	Tạo 1 thủ tục có tên sp_DSBaiViet với tham số truyền vào là Tên thể loại và trả về danh sách Bài viết của thể loại đó. Nếu thể loại không tồn tại thì hiển thị thông báo lỗi
DELIMITER //

CREATE PROCEDURE sp_DSBaiViet(IN pTenTheLoai VARCHAR(50))
BEGIN
    DECLARE theloai_id INT;

    -- Kiểm tra xem thể loại có tồn tại không
    SELECT ma_tloai INTO theloai_id FROM theloai WHERE ten_tloai = pTenTheLoai;

    IF theloai_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thể loại không tồn tại';
    ELSE
        -- Trả về danh sách bài viết của thể loại
        SELECT baiviet.*
        FROM baiviet
        WHERE ma_tloai = theloai_id;
    END IF;
END //

DELIMITER ;
--	Thêm mới cột SLBaiViet vào trong bảng theloai. Tạo 1 trigger có tên tg_CapNhatTheLoai để khi thêm/sửa/xóa bài viết thì số lượng bài viết trong bảng theloai được cập nhật theo

-- Thêm cột SLBaiViet vào bảng theloai
ALTER TABLE theloai
ADD COLUMN SLBaiViet INT DEFAULT 0;

-- Tạo trigger tg_CapNhatTheLoai
DELIMITER //

CREATE TRIGGER tg_CapNhatTheLoai
AFTER INSERT ON baiviet
FOR EACH ROW
BEGIN
    DECLARE theloai_id INT;

    -- Lấy ID của thể loại của bài viết mới thêm vào
    SELECT ma_tloai INTO theloai_id FROM baiviet WHERE ma_bviet = NEW.ma_bviet;

    -- Cập nhật số lượng bài viết trong bảng theloai
    UPDATE theloai
    SET SLBaiViet = SLBaiViet + 1
    WHERE ma_tloai = theloai_id;
END //

DELIMITER ;
--	Bổ sung thêm bảng Users để lưu thông tin Tài khoản đăng nhập và sử dụng cho chức năng Đăng nhập/Quản trị trang web. 
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
