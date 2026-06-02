-- ===========================================
-- views.sql
-- 二手交易平台 View 與權限設定
-- 資料庫名稱：secondhand_shop
-- 使用資料表：Buyer、Seller、Product、Orders、Payment、Shipment、Review
-- ===========================================

-- ===========================================
-- 使用資料庫
-- ===========================================
USE secondhand_shop;

-- ===========================================
-- 建立帳號（如已建立則跳過）
-- ===========================================
CREATE USER IF NOT EXISTS 'buyer_user'@'localhost' IDENTIFIED BY 'test_buyer_0000';

CREATE USER IF NOT EXISTS 'seller_user'@'localhost' IDENTIFIED BY 'test_seller_0000';

CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'test_admin_0000';

-- ===========================================
-- 買家 view：主儀表板
-- 功能：串聯買家個人資料、訂單、商品、付款、出貨與評價
-- 注意：實際查詢時可加 WHERE BuyerID = 指定買家編號
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_dashboard AS
SELECT
    b.BuyerID,
    b.Name AS BuyerName,
    b.Email AS BuyerEmail,
    b.Phone AS BuyerPhone,
    b.Address AS BuyerAddress,
    b.RegisterDate,

    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus,

    p.ProductID,
    p.ProductName,
    p.Category AS ProductCategory,
    p.Price AS ProductPrice,
    p.Description AS ProductDescription,
    p.Status AS ProductStatus,

    s.SellerID,
    s.Name AS SellerName,

    pay.PaymentID,
    pay.PaymentMethod,
    pay.Amount AS PaymentAmount,
    pay.PaymentDate,
    pay.InvoiceNo,

    sh.ShipmentID,
    sh.LogisticsCompany,
    sh.TrackingNo,
    sh.ShipDate,
    sh.Status AS ShipmentStatus,

    r.ReviewID,
    r.Rating AS ReviewRating,
    r.Comment AS ReviewComment,
    r.ReviewDate
FROM
    Buyer b
    LEFT JOIN `Orders` o ON b.BuyerID = o.BuyerID
    LEFT JOIN Product p ON o.ProductID = p.ProductID
    LEFT JOIN Seller s ON p.SellerID = s.SellerID
    LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
    LEFT JOIN Shipment sh ON o.OrderID = sh.OrderID
    LEFT JOIN Review r ON o.OrderID = r.OrderID;

-- ===========================================
-- 買家 view：可購買商品列表
-- 功能：只顯示目前狀態為「上架中」的商品
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_available_products AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category AS ProductCategory,
    p.Price AS ProductPrice,
    p.Description AS ProductDescription,
    p.Status AS ProductStatus,

    s.SellerID,
    s.Name AS SellerName
FROM
    Product p
    JOIN Seller s ON p.SellerID = s.SellerID
WHERE
    p.Status = '上架中';

-- ===========================================
-- 賣家 view：主儀表板
-- 功能：串聯賣家個人資料、刊登商品、買家訂單、付款與出貨資訊
-- 注意：實際查詢時可加 WHERE SellerID = 指定賣家編號
-- ===========================================
CREATE OR REPLACE VIEW view_seller_dashboard AS
SELECT
    s.SellerID,
    s.Name AS SellerName,
    s.Email AS SellerEmail,
    s.Phone AS SellerPhone,
    s.Address AS SellerAddress,

    p.ProductID,
    p.ProductName,
    p.Category AS ProductCategory,
    p.Price AS ProductPrice,
    p.Description AS ProductDescription,
    p.Status AS ProductStatus,

    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus,

    b.BuyerID,
    b.Name AS BuyerName,

    pay.PaymentID,
    pay.PaymentMethod,
    pay.Amount AS PaymentAmount,
    pay.PaymentDate,
    pay.InvoiceNo,

    sh.ShipmentID,
    sh.LogisticsCompany,
    sh.TrackingNo,
    sh.ShipDate,
    sh.Status AS ShipmentStatus
FROM
    Seller s
    LEFT JOIN Product p ON s.SellerID = p.SellerID
    LEFT JOIN `Orders` o ON p.ProductID = o.ProductID
    LEFT JOIN Buyer b ON o.BuyerID = b.BuyerID
    LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
    LEFT JOIN Shipment sh ON o.OrderID = sh.OrderID;

-- ===========================================
-- 管理員 view：全站交易總覽儀表板
-- 功能：查看所有訂單、買家、賣家、商品、付款、出貨與評價資料
-- ===========================================
CREATE OR REPLACE VIEW view_admin_dashboard AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus,

    b.BuyerID,
    b.Name AS BuyerName,
    b.Email AS BuyerEmail,

    s.SellerID,
    s.Name AS SellerName,
    s.Email AS SellerEmail,

    p.ProductID,
    p.ProductName,
    p.Category AS ProductCategory,
    p.Price AS ProductPrice,
    p.Description AS ProductDescription,
    p.Status AS ProductStatus,

    pay.PaymentID,
    pay.PaymentMethod,
    pay.Amount AS PaymentAmount,
    pay.PaymentDate,
    pay.InvoiceNo,

    sh.ShipmentID,
    sh.LogisticsCompany,
    sh.TrackingNo,
    sh.ShipDate,
    sh.Status AS ShipmentStatus,

    r.ReviewID,
    r.Rating AS ReviewRating,
    r.Comment AS ReviewComment,
    r.ReviewDate
FROM
    `Orders` o
    JOIN Buyer b ON o.BuyerID = b.BuyerID
    JOIN Product p ON o.ProductID = p.ProductID
    JOIN Seller s ON p.SellerID = s.SellerID
    LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
    LEFT JOIN Shipment sh ON o.OrderID = sh.OrderID
    LEFT JOIN Review r ON o.OrderID = r.OrderID;

-- ===========================================
-- 商品可購買狀態 view
-- 功能：依商品狀態判斷是否可以購買
-- ===========================================
CREATE OR REPLACE VIEW view_product_status AS
SELECT
    ProductID,
    ProductName,
    Category,
    Price,
    Description,
    Status AS ProductStatus,
    CASE
        WHEN Status = '上架中' THEN '可購買'
        WHEN Status = '已售出' THEN '已售出'
        WHEN Status = '已下架' THEN '不可購買'
        ELSE '狀態異常'
    END AS BuyStatus
FROM
    Product;

-- ===========================================
-- 常用分組 GROUP BY 與 HAVING 查詢 view
-- ===========================================

-- ===========================================
-- 每個買家的訂單數量
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_order_count AS
SELECT
    b.BuyerID,
    b.Name AS BuyerName,
    COUNT(o.OrderID) AS OrderCount
FROM
    Buyer b
    LEFT JOIN `Orders` o ON b.BuyerID = o.BuyerID
GROUP BY
    b.BuyerID,
    b.Name;

-- ===========================================
-- 訂單超過 2 次的活躍買家
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_order_gt2 AS
SELECT
    b.BuyerID,
    b.Name AS BuyerName,
    COUNT(o.OrderID) AS OrderCount
FROM
    Buyer b
    JOIN `Orders` o ON b.BuyerID = o.BuyerID
GROUP BY
    b.BuyerID,
    b.Name
HAVING
    COUNT(o.OrderID) > 2;

-- ===========================================
-- 每件商品被下單次數
-- ===========================================
CREATE OR REPLACE VIEW view_product_order_count AS
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(o.OrderID) AS OrderCount
FROM
    Product p
    LEFT JOIN `Orders` o ON p.ProductID = o.ProductID
GROUP BY
    p.ProductID,
    p.ProductName;

-- ===========================================
-- 每位賣家刊登商品數量
-- ===========================================
CREATE OR REPLACE VIEW view_seller_product_count AS
SELECT
    s.SellerID,
    s.Name AS SellerName,
    COUNT(p.ProductID) AS ProductCount
FROM
    Seller s
    LEFT JOIN Product p ON s.SellerID = p.SellerID
GROUP BY
    s.SellerID,
    s.Name;

-- ===========================================
-- 每件商品的平均評分
-- ===========================================
CREATE OR REPLACE VIEW view_product_avg_rating AS
SELECT
    p.ProductID,
    p.ProductName,
    AVG(r.Rating) AS AvgRating,
    COUNT(r.ReviewID) AS RatingCount
FROM
    Product p
    JOIN `Orders` o ON p.ProductID = o.ProductID
    JOIN Review r ON o.OrderID = r.OrderID
GROUP BY
    p.ProductID,
    p.ProductName
HAVING
    COUNT(r.ReviewID) > 0;

-- ===========================================
-- 每位賣家的平均評分
-- 功能：透過賣家商品的訂單評價計算賣家評分
-- ===========================================
CREATE OR REPLACE VIEW view_seller_avg_rating AS
SELECT
    s.SellerID,
    s.Name AS SellerName,
    AVG(r.Rating) AS AvgRating,
    COUNT(r.ReviewID) AS RatingCount
FROM
    Seller s
    JOIN Product p ON s.SellerID = p.SellerID
    JOIN `Orders` o ON p.ProductID = o.ProductID
    JOIN Review r ON o.OrderID = r.OrderID
GROUP BY
    s.SellerID,
    s.Name
HAVING
    COUNT(r.ReviewID) > 0;

-- ===========================================
-- 每種付款方式使用次數
-- ===========================================
CREATE OR REPLACE VIEW view_payment_method_count AS
SELECT
    PaymentMethod,
    COUNT(PaymentID) AS UsedCount
FROM
    Payment
GROUP BY
    PaymentMethod;

-- ===========================================
-- 每種出貨狀態的數量
-- ===========================================
CREATE OR REPLACE VIEW view_shipment_status_count AS
SELECT
    Status AS ShipmentStatus,
    COUNT(ShipmentID) AS ShipmentCount
FROM
    Shipment
GROUP BY
    Status;

-- ===========================================
-- 權限設定
-- ===========================================

-- ===========================================
-- 買家權限
-- ===========================================
GRANT SELECT
ON secondhand_shop.view_buyer_dashboard
TO 'buyer_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_buyer_available_products
TO 'buyer_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'buyer_user'@'localhost';

-- ===========================================
-- 賣家權限
-- ===========================================
GRANT SELECT
ON secondhand_shop.view_seller_dashboard
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_avg_rating
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'seller_user'@'localhost';

-- ===========================================
-- 管理員權限
-- ===========================================
GRANT SELECT
ON secondhand_shop.view_admin_dashboard
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_buyer_order_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_buyer_order_gt2
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_order_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_product_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_avg_rating
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_avg_rating
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_payment_method_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_shipment_status_count
TO 'admin_user'@'localhost';

-- ===========================================
-- 重新整理權限
-- ===========================================
FLUSH PRIVILEGES;

