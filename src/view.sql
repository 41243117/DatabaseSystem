-- ===========================================
-- views.sql
-- 二手物品交易平台 View 與權限設定
-- 完整依照 ER Diagram 設計
-- ===========================================

USE secondhand_shop;

-- ===========================================
-- 建立帳號（如已建立則跳過）
-- ===========================================
CREATE USER IF NOT EXISTS 'buyer_user'@'localhost'
IDENTIFIED BY 'test_buyer_0000';

CREATE USER IF NOT EXISTS 'seller_user'@'localhost'
IDENTIFIED BY 'test_seller_0000';

CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
IDENTIFIED BY 'test_admin_0000';

-- ===========================================
-- 買家 view：商品瀏覽
-- 買家只能看到上架中的商品
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_product_list AS
SELECT
    p.pID,
    p.pName,
    p.description,
    p.price,
    p.pCondition,
    p.pStatus,
    p.postDate,

    c.cID,
    c.cName AS CategoryName,
    c.cDescription,

    seller.mID AS SellerID,
    seller.mAccount AS SellerAccount,
    seller.mName AS SellerName,
    seller.mEmail AS SellerEmail
FROM
    Product p
    JOIN Member seller ON p.mID = seller.mID
    JOIN Category c ON p.cID = c.cID
WHERE
    p.pStatus = '上架中'
    AND seller.mRole = '賣家';

-- ===========================================
-- 買家 view：買家訂單查詢
-- 買家可看自己的訂單、商品、付款、物流狀態
-- 實際查詢時可加 WHERE BuyerID = 自己的 mID
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_order_status AS
SELECT
    buyer.mID AS BuyerID,
    buyer.mAccount AS BuyerAccount,
    buyer.mName AS BuyerName,
    buyer.mEmail AS BuyerEmail,
    buyer.mPhone AS BuyerPhone,

    o.oID,
    o.oDate,
    o.oStatus,
    o.totalAmount,

    od.odID,
    od.quantity,
    od.dealPrice,

    p.pID,
    p.pName,
    p.price,
    p.pCondition,
    p.pStatus,

    seller.mID AS SellerID,
    seller.mName AS SellerName,
    seller.mEmail AS SellerEmail,

    i.iID,
    i.iDate,
    i.amount AS InvoiceAmount,
    i.paymentStatus,

    pm.pmID,
    pm.methodName AS PaymentMethod,

    sh.sID,
    sh.sDate,
    sh.sStatus,

    sm.smID,
    sm.methodName AS ShipmentMethod
FROM
    Member buyer
    JOIN `Order` o ON buyer.mID = o.mID
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    JOIN Member seller ON p.mID = seller.mID
    LEFT JOIN Invoice i ON o.oID = i.oID
    LEFT JOIN PaymentMethod pm ON i.pmID = pm.pmID
    LEFT JOIN Shipment sh ON od.sID = sh.sID
    LEFT JOIN ShipmentMethod sm ON sh.smID = sm.smID
WHERE
    buyer.mRole = '買家'
    AND seller.mRole = '賣家';

-- ===========================================
-- 買家 view：評價紀錄
-- Member Write Review，Review Receives Order
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_review_history AS
SELECT
    r.rID,
    r.score,
    r.comment,
    r.rDate,

    reviewer.mID AS ReviewerID,
    reviewer.mAccount AS ReviewerAccount,
    reviewer.mName AS ReviewerName,
    reviewer.mRole AS ReviewerRole,

    o.oID,
    o.oDate,
    o.oStatus,

    p.pID,
    p.pName,

    seller.mID AS SellerID,
    seller.mName AS SellerName
FROM
    Review r
    JOIN Member reviewer ON r.mID = reviewer.mID
    JOIN `Order` o ON r.oID = o.oID
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    JOIN Member seller ON p.mID = seller.mID
WHERE
    reviewer.mRole = '買家';

-- ===========================================
-- 賣家 view：商品管理
-- 賣家查看自己刊登的商品
-- ===========================================
CREATE OR REPLACE VIEW view_seller_product_manage AS
SELECT
    seller.mID AS SellerID,
    seller.mAccount AS SellerAccount,
    seller.mName AS SellerName,
    seller.mEmail AS SellerEmail,
    seller.mPhone AS SellerPhone,

    p.pID,
    p.pName,
    p.description,
    p.price,
    p.pCondition,
    p.pStatus,
    p.postDate,

    c.cID,
    c.cName AS CategoryName,
    c.cDescription
FROM
    Member seller
    JOIN Product p ON seller.mID = p.mID
    JOIN Category c ON p.cID = c.cID
WHERE
    seller.mRole = '賣家';

-- ===========================================
-- 賣家 view：訂單管理
-- 賣家查看自己的商品被下單後的訂單、付款、出貨狀態
-- ===========================================
CREATE OR REPLACE VIEW view_seller_order_manage AS
SELECT
    seller.mID AS SellerID,
    seller.mAccount AS SellerAccount,
    seller.mName AS SellerName,
    seller.mEmail AS SellerEmail,

    p.pID,
    p.pName,
    p.price,
    p.pCondition,
    p.pStatus,

    od.odID,
    od.quantity,
    od.dealPrice,

    o.oID,
    o.oDate,
    o.oStatus,
    o.totalAmount,

    buyer.mID AS BuyerID,
    buyer.mName AS BuyerName,
    buyer.mEmail AS BuyerEmail,
    buyer.mPhone AS BuyerPhone,

    i.iID,
    i.iDate,
    i.amount AS InvoiceAmount,
    i.paymentStatus,

    pm.pmID,
    pm.methodName AS PaymentMethod,

    sh.sID,
    sh.sDate,
    sh.sStatus,

    sm.smID,
    sm.methodName AS ShipmentMethod
FROM
    Member seller
    JOIN Product p ON seller.mID = p.mID
    JOIN OrderDetail od ON p.pID = od.pID
    JOIN `Order` o ON od.oID = o.oID
    JOIN Member buyer ON o.mID = buyer.mID
    LEFT JOIN Invoice i ON o.oID = i.oID
    LEFT JOIN PaymentMethod pm ON i.pmID = pm.pmID
    LEFT JOIN Shipment sh ON od.sID = sh.sID
    LEFT JOIN ShipmentMethod sm ON sh.smID = sm.smID
WHERE
    seller.mRole = '賣家'
    AND buyer.mRole = '買家';

-- ===========================================
-- 賣家 view：收到的評價
-- 用賣家商品所屬訂單取得評價
-- ===========================================
CREATE OR REPLACE VIEW view_seller_review_received AS
SELECT
    seller.mID AS SellerID,
    seller.mName AS SellerName,

    r.rID,
    r.score,
    r.comment,
    r.rDate,

    reviewer.mID AS ReviewerID,
    reviewer.mName AS ReviewerName,
    reviewer.mRole AS ReviewerRole,

    o.oID,
    p.pID,
    p.pName
FROM
    Member seller
    JOIN Product p ON seller.mID = p.mID
    JOIN OrderDetail od ON p.pID = od.pID
    JOIN `Order` o ON od.oID = o.oID
    JOIN Review r ON o.oID = r.oID
    JOIN Member reviewer ON r.mID = reviewer.mID
WHERE
    seller.mRole = '賣家';

-- ===========================================
-- 管理員 view：會員清單
-- ===========================================
CREATE OR REPLACE VIEW view_admin_member_list AS
SELECT
    mID,
    mAccount,
    mName,
    mEmail,
    mPhone,
    mRole,
    mCreateDate
FROM
    Member;

-- ===========================================
-- 管理員 view：全站交易總覽
-- 管理員可查看訂單、商品、會員、付款、物流、評價
-- ===========================================
CREATE OR REPLACE VIEW view_admin_trade_dashboard AS
SELECT
    o.oID,
    o.oDate,
    o.oStatus,
    o.totalAmount,

    buyer.mID AS BuyerID,
    buyer.mName AS BuyerName,
    buyer.mEmail AS BuyerEmail,

    seller.mID AS SellerID,
    seller.mName AS SellerName,
    seller.mEmail AS SellerEmail,

    p.pID,
    p.pName,
    p.price,
    p.pCondition,
    p.pStatus,

    c.cID,
    c.cName AS CategoryName,

    od.odID,
    od.quantity,
    od.dealPrice,

    i.iID,
    i.iDate,
    i.amount AS InvoiceAmount,
    i.paymentStatus,

    pm.pmID,
    pm.methodName AS PaymentMethod,

    sh.sID,
    sh.sDate,
    sh.sStatus,

    sm.smID,
    sm.methodName AS ShipmentMethod,

    r.rID,
    r.score,
    r.comment,
    r.rDate,

    reviewer.mID AS ReviewerID,
    reviewer.mName AS ReviewerName,
    reviewer.mRole AS ReviewerRole
FROM
    `Order` o
    JOIN Member buyer ON o.mID = buyer.mID
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID
    JOIN Member seller ON p.mID = seller.mID
    JOIN Category c ON p.cID = c.cID
    LEFT JOIN Invoice i ON o.oID = i.oID
    LEFT JOIN PaymentMethod pm ON i.pmID = pm.pmID
    LEFT JOIN Shipment sh ON od.sID = sh.sID
    LEFT JOIN ShipmentMethod sm ON sh.smID = sm.smID
    LEFT JOIN Review r ON o.oID = r.oID
    LEFT JOIN Member reviewer ON r.mID = reviewer.mID;

-- ===========================================
-- 商品狀態 view
-- 判斷商品是否可購買
-- ===========================================
CREATE OR REPLACE VIEW view_product_status AS
SELECT
    p.pID,
    p.pName,
    p.price,
    p.pCondition,
    p.pStatus,

    c.cID,
    c.cName AS CategoryName,

    seller.mID AS SellerID,
    seller.mName AS SellerName,

    CASE
        WHEN p.pStatus = '上架中' THEN '可購買'
        WHEN p.pStatus = '已售出' THEN '已售出'
        WHEN p.pStatus = '已下架' THEN '不可購買'
        ELSE '狀態異常'
    END AS BuyStatus
FROM
    Product p
    JOIN Category c ON p.cID = c.cID
    JOIN Member seller ON p.mID = seller.mID;

-- ===========================================
-- 統計 view：每個分類的商品數量
-- ===========================================
CREATE OR REPLACE VIEW view_category_product_count AS
SELECT
    c.cID,
    c.cName AS CategoryName,
    COUNT(p.pID) AS ProductCount
FROM
    Category c
    LEFT JOIN Product p ON c.cID = p.cID
GROUP BY
    c.cID,
    c.cName;

-- ===========================================
-- 統計 view：每位賣家刊登商品數量
-- ===========================================
CREATE OR REPLACE VIEW view_seller_product_count AS
SELECT
    seller.mID AS SellerID,
    seller.mName AS SellerName,
    COUNT(p.pID) AS ProductCount
FROM
    Member seller
    LEFT JOIN Product p ON seller.mID = p.mID
WHERE
    seller.mRole = '賣家'
GROUP BY
    seller.mID,
    seller.mName;

-- ===========================================
-- 統計 view：每位買家的訂單數量
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_order_count AS
SELECT
    buyer.mID AS BuyerID,
    buyer.mName AS BuyerName,
    COUNT(o.oID) AS OrderCount
FROM
    Member buyer
    LEFT JOIN `Order` o ON buyer.mID = o.mID
WHERE
    buyer.mRole = '買家'
GROUP BY
    buyer.mID,
    buyer.mName;

-- ===========================================
-- HAVING view：訂單超過 2 筆的買家
-- ===========================================
CREATE OR REPLACE VIEW view_buyer_order_gt2 AS
SELECT
    buyer.mID AS BuyerID,
    buyer.mName AS BuyerName,
    COUNT(o.oID) AS OrderCount
FROM
    Member buyer
    JOIN `Order` o ON buyer.mID = o.mID
WHERE
    buyer.mRole = '買家'
GROUP BY
    buyer.mID,
    buyer.mName
HAVING
    COUNT(o.oID) > 2;

-- ===========================================
-- 統計 view：每件商品被下單次數
-- ER 圖中一個商品最多出現在一筆 OrderDetail，所以通常是 0 或 1
-- ===========================================
CREATE OR REPLACE VIEW view_product_order_count AS
SELECT
    p.pID,
    p.pName,
    COUNT(od.odID) AS OrderCount
FROM
    Product p
    LEFT JOIN OrderDetail od ON p.pID = od.pID
GROUP BY
    p.pID,
    p.pName;

-- ===========================================
-- 統計 view：每件商品平均評分
-- ===========================================
CREATE OR REPLACE VIEW view_product_avg_rating AS
SELECT
    p.pID,
    p.pName,
    AVG(r.score) AS AvgRating,
    COUNT(r.rID) AS RatingCount
FROM
    Product p
    JOIN OrderDetail od ON p.pID = od.pID
    JOIN `Order` o ON od.oID = o.oID
    JOIN Review r ON o.oID = r.oID
GROUP BY
    p.pID,
    p.pName
HAVING
    COUNT(r.rID) > 0;

-- ===========================================
-- 統計 view：每位賣家的平均評分
-- ===========================================
CREATE OR REPLACE VIEW view_seller_avg_rating AS
SELECT
    seller.mID AS SellerID,
    seller.mName AS SellerName,
    AVG(r.score) AS AvgRating,
    COUNT(r.rID) AS RatingCount
FROM
    Member seller
    JOIN Product p ON seller.mID = p.mID
    JOIN OrderDetail od ON p.pID = od.pID
    JOIN `Order` o ON od.oID = o.oID
    JOIN Review r ON o.oID = r.oID
WHERE
    seller.mRole = '賣家'
GROUP BY
    seller.mID,
    seller.mName
HAVING
    COUNT(r.rID) > 0;

-- ===========================================
-- 統計 view：每種付款方式使用次數
-- ===========================================
CREATE OR REPLACE VIEW view_payment_method_count AS
SELECT
    pm.pmID,
    pm.methodName AS PaymentMethod,
    COUNT(i.iID) AS UsedCount
FROM
    PaymentMethod pm
    LEFT JOIN Invoice i ON pm.pmID = i.pmID
GROUP BY
    pm.pmID,
    pm.methodName;

-- ===========================================
-- 統計 view：每種物流方式使用次數
-- ===========================================
CREATE OR REPLACE VIEW view_shipment_method_count AS
SELECT
    sm.smID,
    sm.methodName AS ShipmentMethod,
    COUNT(sh.sID) AS UsedCount
FROM
    ShipmentMethod sm
    LEFT JOIN Shipment sh ON sm.smID = sh.smID
GROUP BY
    sm.smID,
    sm.methodName;

-- ===========================================
-- 權限設定
-- ===========================================

-- 買家權限
GRANT SELECT
ON secondhand_shop.view_buyer_product_list
TO 'buyer_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_buyer_order_status
TO 'buyer_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_buyer_review_history
TO 'buyer_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'buyer_user'@'localhost';

-- 賣家權限
GRANT SELECT
ON secondhand_shop.view_seller_product_manage
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_order_manage
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_review_received
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_avg_rating
TO 'seller_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'seller_user'@'localhost';

-- 管理員權限
GRANT SELECT
ON secondhand_shop.view_admin_member_list
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_admin_trade_dashboard
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_product_status
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_category_product_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_product_count
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
ON secondhand_shop.view_product_avg_rating
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_seller_avg_rating
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_payment_method_count
TO 'admin_user'@'localhost';

GRANT SELECT
ON secondhand_shop.view_shipment_method_count
TO 'admin_user'@'localhost';

FLUSH PRIVILEGES;
