USE SecHand;

-- 若重跑，先刪除 View
DROP VIEW IF EXISTS Buyer_View;
DROP VIEW IF EXISTS Seller_View;
DROP VIEW IF EXISTS Admin_View;
DROP VIEW IF EXISTS Product_Status_View;

-- ============================================
-- 1. 建立買家、賣家與管理者帳號
-- ============================================

-- 建立買家帳號
CREATE USER IF NOT EXISTS 'buyer_user'@'localhost'
IDENTIFIED BY '0000';

-- 建立賣家帳號
CREATE USER IF NOT EXISTS 'seller_user'@'localhost'
IDENTIFIED BY '0000';

-- 建立管理者帳號
CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
IDENTIFIED BY '0000';

-- ============================================
-- 2. 建立 External View
-- ============================================

-- ============================================
-- 2.1 買家 View
-- 用途：
-- 買家可查看自己的訂單、購買商品、付款狀態、出貨狀態與評價資料。
-- 此 View 不顯示賣家 Email、電話等完整個資。
-- ============================================

CREATE OR REPLACE VIEW Buyer_View AS
SELECT
    buyer.mID AS buyerID,
    buyer.mName AS buyerName,

    o.oID AS orderID,
    o.oDate AS orderDate,
    o.oStatus AS orderStatus,
    o.totalAmount AS totalAmount,

    p.pID AS productID,
    p.pName AS productName,
    p.pCondition AS productCondition,
    p.price AS productPrice,

    seller.mName AS sellerName,

    c.cName AS categoryName,

    i.paymentStatus AS paymentStatus,
    pm.methodName AS paymentMethod,

    s.sStatus AS shipmentStatus,
    s.sDate AS shipmentDate,
    sm.methodName AS shipmentMethod,

    r.score AS reviewScore,
    r.comment AS reviewComment,
    r.rDate AS reviewDate

FROM `Order` o
JOIN Member buyer
    ON o.mID = buyer.mID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

JOIN Member seller
    ON p.mID = seller.mID

JOIN Category c
    ON p.cID = c.cID

LEFT JOIN Invoice i
    ON o.oID = i.oID

LEFT JOIN PaymentMethod pm
    ON i.pmID = pm.pmID

LEFT JOIN Shipment s
    ON od.sID = s.sID

LEFT JOIN ShipmentMethod sm
    ON s.smID = sm.smID

LEFT JOIN Review r
    ON o.oID = r.oID;


-- ============================================
-- 2.2 賣家 View
-- 用途：
-- 賣家可查看自己刊登的商品、商品銷售狀態、買家、付款狀態、
-- 出貨狀態與評價資料。
-- 主要提供賣家管理商品與安排出貨使用。
-- ============================================

CREATE OR REPLACE VIEW Seller_View AS
SELECT
    seller.mID AS sellerID,
    seller.mName AS sellerName,

    p.pID AS productID,
    p.pName AS productName,
    p.pCondition AS productCondition,
    p.pStatus AS productStatus,
    p.price AS productPrice,
    p.postDate AS postDate,

    c.cName AS categoryName,

    o.oID AS orderID,
    o.oDate AS orderDate,
    o.oStatus AS orderStatus,
    o.totalAmount AS orderAmount,

    buyer.mName AS buyerName,

    od.quantity AS quantity,
    od.dealPrice AS dealPrice,

    i.paymentStatus AS paymentStatus,
    pm.methodName AS paymentMethod,

    s.sStatus AS shipmentStatus,
    s.sDate AS shipmentDate,
    sm.methodName AS shipmentMethod,

    r.score AS reviewScore,
    r.comment AS reviewComment,
    r.rDate AS reviewDate

FROM Product p
JOIN Member seller
    ON p.mID = seller.mID

JOIN Category c
    ON p.cID = c.cID

LEFT JOIN OrderDetail od
    ON p.pID = od.pID

LEFT JOIN `Order` o
    ON od.oID = o.oID

LEFT JOIN Member buyer
    ON o.mID = buyer.mID

LEFT JOIN Invoice i
    ON o.oID = i.oID

LEFT JOIN PaymentMethod pm
    ON i.pmID = pm.pmID

LEFT JOIN Shipment s
    ON od.sID = s.sID

LEFT JOIN ShipmentMethod sm
    ON s.smID = sm.smID

LEFT JOIN Review r
    ON o.oID = r.oID;


-- ============================================
-- 2.3 管理者 View
-- 用途：
-- 管理者可查看平台整體交易資料，包含會員資料、商品資料、
-- 訂單資料、付款狀態、出貨狀態與評價紀錄。
-- 管理者 View 顯示資料較完整，方便後台管理。
-- ============================================

CREATE OR REPLACE VIEW Admin_View AS
SELECT
    o.oID AS orderID,
    o.oDate AS orderDate,
    o.oStatus AS orderStatus,
    o.totalAmount AS totalAmount,

    buyer.mID AS buyerID,
    buyer.mAccount AS buyerAccount,
    buyer.mName AS buyerName,
    buyer.mEmail AS buyerEmail,
    buyer.mPhone AS buyerPhone,

    seller.mID AS sellerID,
    seller.mAccount AS sellerAccount,
    seller.mName AS sellerName,
    seller.mEmail AS sellerEmail,
    seller.mPhone AS sellerPhone,

    p.pID AS productID,
    p.pName AS productName,
    p.pCondition AS productCondition,
    p.pStatus AS productStatus,
    p.price AS productPrice,
    p.postDate AS postDate,

    c.cName AS categoryName,

    od.odID AS orderDetailID,
    od.quantity AS quantity,
    od.dealPrice AS dealPrice,

    i.iID AS invoiceID,
    i.amount AS invoiceAmount,
    i.paymentStatus AS paymentStatus,
    pm.methodName AS paymentMethod,

    s.sID AS shipmentID,
    s.sStatus AS shipmentStatus,
    s.sDate AS shipmentDate,
    sm.methodName AS shipmentMethod,

    r.rID AS reviewID,
    r.score AS reviewScore,
    r.comment AS reviewComment,
    r.rDate AS reviewDate

FROM `Order` o
JOIN Member buyer
    ON o.mID = buyer.mID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

JOIN Member seller
    ON p.mID = seller.mID

JOIN Category c
    ON p.cID = c.cID

LEFT JOIN Invoice i
    ON o.oID = i.oID

LEFT JOIN PaymentMethod pm
    ON i.pmID = pm.pmID

LEFT JOIN Shipment s
    ON od.sID = s.sID

LEFT JOIN ShipmentMethod sm
    ON s.smID = sm.smID

LEFT JOIN Review r
    ON o.oID = r.oID;


-- ============================================
-- 3. 權限設定
-- ============================================

-- 先移除可能存在的權限，避免重複設定時混亂
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'buyer_user'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'seller_user'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_user'@'localhost';

--============================================
-- 買家權限
-- ============================================

-- 查詢 View
GRANT SELECT ON SecHand.Buyer_View
TO 'buyer_user'@'localhost';

-- 新增訂單相關資料
GRANT INSERT ON SecHand.`Order`
TO 'buyer_user'@'localhost';

GRANT INSERT ON SecHand.OrderDetail
TO 'buyer_user'@'localhost';

GRANT INSERT ON SecHand.Invoice
TO 'buyer_user'@'localhost';

GRANT INSERT ON SecHand.Review
TO 'buyer_user'@'localhost';

-- 修改自己的基本聯絡資料
GRANT UPDATE (mEmail, mPhone)
ON SecHand.Member
TO 'buyer_user'@'localhost';

-- 修改評價內容
GRANT UPDATE (score, comment)
ON SecHand.Review
TO 'buyer_user'@'localhost';

-- 刪除評價
GRANT DELETE ON SecHand.Review
TO 'buyer_user'@'localhost';

-- ============================================
-- 賣家權限
-- ============================================

-- 查詢 View
GRANT SELECT ON SecHand.Seller_View
TO 'seller_user'@'localhost';

-- 新增商品與出貨資料
GRANT INSERT ON SecHand.Product
TO 'seller_user'@'localhost';

GRANT INSERT ON SecHand.Shipment
TO 'seller_user'@'localhost';

GRANT INSERT ON SecHand.Review
TO 'buyer_user'@'localhost';

-- 修改商品資料
GRANT UPDATE (pCondition, pName, pStatus, description, price)
ON SecHand.Product
TO 'seller_user'@'localhost';

-- 修改出貨資料
GRANT UPDATE (sStatus, sDate)
ON SecHand.Shipment
TO 'seller_user'@'localhost';

-- 修改評價內容
GRANT UPDATE (score, comment)
ON SecHand.Review
TO 'seller_user'@'localhost';

-- 刪除商品
-- 若商品已被 OrderDetail 參照，會被外鍵限制擋下
GRANT DELETE ON SecHand.Product
TO 'seller_user'@'localhost';

-- 刪除評價
GRANT DELETE ON SecHand.Review
TO 'seller_user'@'localhost';

-- ============================================
-- 管理者權限
-- 管理者可查詢、新增、修改、刪除所有資料
-- ============================================

GRANT SELECT, INSERT, UPDATE, DELETE
ON SecHand.*
TO 'admin_user'@'localhost';


FLUSH PRIVILEGES;





-- ============================================
-- 4. 測試查詢
-- ============================================

SELECT * FROM Buyer_View;
SELECT * FROM Seller_View;
SELECT * FROM Admin_View;


-- ============================================
-- 5. GROUP BY 與 HAVING 查詢功能
-- ============================================

-- 5.1 查詢每位買家的訂單數量
SELECT
    buyer.mID AS buyerID,
    buyer.mName AS buyerName,
    COUNT(o.oID) AS orderCount
FROM Member buyer
LEFT JOIN `Order` o
    ON buyer.mID = o.mID
WHERE buyer.mRole IN ('買家', '買賣家')
GROUP BY buyer.mID, buyer.mName
ORDER BY orderCount DESC;


-- 5.2 查詢訂單數量超過 1 筆的買家
SELECT
    buyer.mID AS buyerID,
    buyer.mName AS buyerName,
    COUNT(o.oID) AS orderCount
FROM Member buyer
JOIN `Order` o
    ON buyer.mID = o.mID
WHERE buyer.mRole IN ('買家', '買賣家')
GROUP BY buyer.mID, buyer.mName
HAVING COUNT(o.oID) > 1
ORDER BY orderCount DESC;


-- 5.3 查詢每位賣家刊登的商品數量
SELECT
    seller.mID AS sellerID,
    seller.mName AS sellerName,
    COUNT(p.pID) AS productCount
FROM Member seller
LEFT JOIN Product p
    ON seller.mID = p.mID
WHERE seller.mRole IN ('賣家', '買賣家')
GROUP BY seller.mID, seller.mName
ORDER BY productCount DESC;


-- 5.4 查詢每個商品分類的商品數量
SELECT
    c.cID AS categoryID,
    c.cName AS categoryName,
    COUNT(p.pID) AS productCount
FROM Category c
LEFT JOIN Product p
    ON c.cID = p.cID
GROUP BY c.cID, c.cName
ORDER BY productCount DESC;


-- 5.5 查詢每位賣家的平均評分
SELECT
    seller.mID AS sellerID,
    seller.mName AS sellerName,
    AVG(r.score) AS averageScore,
    COUNT(r.rID) AS reviewCount
FROM Member seller
JOIN Product p
    ON seller.mID = p.mID
JOIN OrderDetail od
    ON p.pID = od.pID
JOIN `Order` o
    ON od.oID = o.oID
JOIN Review r
    ON o.oID = r.oID
GROUP BY seller.mID, seller.mName
HAVING COUNT(r.rID) > 0
ORDER BY averageScore DESC;
