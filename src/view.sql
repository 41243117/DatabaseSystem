USE SecHand;

-- ============================================
-- 若重跑，先刪除 View
-- ============================================

DROP VIEW IF EXISTS Buyer_View;
DROP VIEW IF EXISTS Seller_View;
DROP VIEW IF EXISTS Admin_View;

-- ============================================
-- 1. Buyer_View
-- 買家檢視
-- 用途：買家查看自己的訂單、購買商品、付款狀態、出貨狀態與評價
-- ============================================

CREATE VIEW Buyer_View AS
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

    seller.mID AS sellerID,
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
-- 2. Seller_View
-- 賣家檢視
-- 用途：賣家查看自己刊登商品、商品銷售狀態、買家、付款、出貨與評價
-- ============================================

CREATE VIEW Seller_View AS
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

    buyer.mID AS buyerID,
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
-- 3. Admin_View
-- 管理者檢視
-- 用途：管理者查看平台整體交易資料，包含買家、賣家、商品、訂單、付款、出貨與評價
-- ============================================

CREATE VIEW Admin_View AS
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
