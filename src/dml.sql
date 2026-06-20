-- 買家可執行：
-- 1. 查詢 Buyer_View
-- 2. 查詢 Product_Status_View
-- 3. 新增訂單
-- 4. 新增訂單明細
-- 5. 新增付款紀錄
-- 6. 新增評價
-- 7. 修改自己的聯絡資料
-- 8. 修改評價內容
-- 9. 刪除評價
--
-- 買家不可執行：
-- 1. 新增商品
-- 2. 修改商品狀態
-- 3. 新增出貨資料
-- 4. 修改出貨狀態
-- 5. 刪除商品
-- 6. 刪除資料表或 View


-- -------------------------
-- 1-1 買家可以查詢自己的外部檢視
-- 預期結果：成功
-- -------------------------

SELECT *
FROM Buyer_View;


-- -------------------------
-- 1-2 買家可以查詢商品狀態
-- 預期結果：成功
-- -------------------------

SELECT *
FROM Product_Status_View;


-- -------------------------
-- 1-3 買家新增訂單
-- 預期結果：成功
-- -------------------------

INSERT INTO `Order`
(mID, oStatus, oDate, totalAmount)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
    '待付款',
    '2026-06-10',
    350.00
);


-- -------------------------
-- 1-4 買家新增付款紀錄
-- 預期結果：成功
-- 注意：這裡 paymentStatus 先用「未付款」
-- 因為買家不應該直接把付款狀態改成已付款
-- -------------------------

INSERT INTO Invoice
(oID, pmID, iDate, amount, paymentStatus)
VALUES
(
    (
        SELECT oID
        FROM `Order`
        WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
          AND oDate = '2026-06-10'
          AND totalAmount = 350.00
        ORDER BY oID DESC
        LIMIT 1
    ),
    (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
    NULL,
    350.00,
    '未付款'
);


-- -------------------------
-- 1-5 買家新增評價
-- 預期結果：成功
-- 注意：若你的 Review 已加入 reviewType，請用這版
-- -------------------------

INSERT INTO Review
(mID, oID, reviewType, score, comment, rDate)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
    (
        SELECT oID
        FROM `Order`
        WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
          AND oDate = '2026-06-10'
          AND totalAmount = 350.00
        ORDER BY oID DESC
        LIMIT 1
    ),
    '買家評價',
    5,
    '測試買家評價：商品狀況良好。',
    '2026-06-10'
);


-- -------------------------
-- 1-6 買家修改自己的聯絡電話
-- 預期結果：成功
-- -------------------------

UPDATE Member
SET mPhone = '0988777666'
WHERE mAccount = 'buyer_ming01';


-- -------------------------
-- 1-7 買家修改自己寫的評價內容
-- 預期結果：成功
-- -------------------------

UPDATE Review
SET comment = '測試買家評價：修改後的評價內容。'
WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
  AND reviewType = '買家評價'
  AND comment = '測試買家評價：商品狀況良好。';


-- -------------------------
-- 1-8 買家不能新增商品
-- 預期結果：失敗，Access denied
-- -------------------------

INSERT INTO Product
(mID, cID, pCondition, pName, pStatus, description, postDate, price)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
    (SELECT cID FROM Category WHERE cName = '書籍教材'),
    '九成新',
    '買家不應該新增的商品',
    '上架中',
    '此筆資料應該因權限不足而新增失敗。',
    '2026-06-10',
    300.00
);


-- -------------------------
-- 1-9 買家不能修改商品狀態
-- 預期結果：失敗，Access denied
-- -------------------------

UPDATE Product
SET pStatus = '已下架'
WHERE pName = 'AirPods Pro 2';


-- -------------------------
-- 1-10 買家不能刪除商品
-- 預期結果：失敗，Access denied
-- -------------------------

DELETE FROM Product
WHERE pName = 'AirPods Pro 2';


-- -------------------------
-- 1-11 買家不能 DROP View
-- 預期結果：失敗，Access denied
-- -------------------------

DROP VIEW Buyer_View;



-- 賣家可執行：
-- 1. 查詢 Seller_View
-- 2. 查詢 Product_Status_View
-- 3. 新增商品
-- 4. 修改商品資訊
-- 5. 修改商品狀態
-- 6. 新增出貨資料
-- 7. 修改出貨狀態
-- 8. 新增評價
--
-- 賣家不可執行：
-- 1. 新增訂單
-- 2. 修改付款狀態
-- 3. 修改買家會員資料
-- 4. 刪除訂單
-- 5. DROP 資料表或 View


-- -------------------------
-- 2-1 賣家查詢自己的外部檢視
-- 預期結果：成功
-- -------------------------

SELECT *
FROM Seller_View;


-- -------------------------
-- 2-2 賣家新增商品
-- 預期結果：成功
-- -------------------------

INSERT INTO Product
(mID, cID, pCondition, pName, pStatus, description, postDate, price)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
    (SELECT cID FROM Category WHERE cName = '書籍教材'),
    '九成新',
    '賣家測試新增商品',
    '上架中',
    '此商品為賣家權限測試用。',
    '2026-06-10',
    500.00
);


-- -------------------------
-- 2-3 賣家修改商品價格
-- 預期結果：成功
-- -------------------------

UPDATE Product
SET price = 450.00
WHERE pName = '賣家測試新增商品';


-- -------------------------
-- 2-4 賣家修改商品狀態
-- 預期結果：成功
-- -------------------------

UPDATE Product
SET pStatus = '已下架'
WHERE pName = '賣家測試新增商品';


-- -------------------------
-- 2-5 賣家新增出貨資料
-- 預期結果：成功
-- -------------------------

INSERT INTO Shipment
(smID, sStatus, sDate)
VALUES
(
    (SELECT smID FROM ShipmentMethod WHERE methodName = '宅配'),
    '待出貨',
    NULL
);


-- -------------------------
-- 2-6 賣家修改出貨狀態
-- 預期結果：成功
-- -------------------------

UPDATE Shipment
SET sStatus = '已寄出',
    sDate = '2026-06-11'
WHERE sID = (
    SELECT MAX(sID)
    FROM Shipment
);


-- -------------------------
-- 2-7 賣家新增評價
-- 預期結果：成功
-- 注意：需要 Review 已經有 reviewType 欄位
-- -------------------------

INSERT INTO Review
(mID, oID, reviewType, score, comment, rDate)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
    (
        SELECT oID
        FROM `Order`
        ORDER BY oID DESC
        LIMIT 1
    ),
    '賣家評價',
    5,
    '測試賣家評價：買家付款快速。',
    '2026-06-11'
);


-- -------------------------
-- 2-8 賣家不能新增訂單
-- 預期結果：失敗，Access denied
-- -------------------------

INSERT INTO `Order`
(mID, oStatus, oDate, totalAmount)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
    '待付款',
    '2026-06-10',
    999.00
);


-- -------------------------
-- 2-9 賣家不能修改付款狀態
-- 預期結果：失敗，Access denied
-- -------------------------

UPDATE Invoice
SET paymentStatus = '已付款',
    iDate = '2026-06-10'
WHERE iID = 1;


-- -------------------------
-- 2-10 賣家不能修改買家會員資料
-- 預期結果：失敗，Access denied
-- -------------------------

UPDATE Member
SET mPhone = '0911111111'
WHERE mAccount = 'buyer_ming01';


-- -------------------------
-- 2-11 賣家不能刪除訂單
-- 預期結果：失敗，Access denied
-- -------------------------

DELETE FROM `Order`
WHERE oID = 1;


-- -------------------------
-- 2-12 賣家不能 DROP 資料表
-- 預期結果：失敗，Access denied
-- -------------------------

DROP TABLE Member;



-- 管理者可執行：
-- 1. 查詢 Admin_View
-- 2. 查詢所有資料
-- 3. 新增資料
-- 4. 修改訂單狀態
-- 5. 修改付款狀態
-- 6. 刪除資料
-- 7. 建立或刪除測試 View / 測試 Table


-- -------------------------
-- 3-1 管理者查詢完整外部檢視
-- 預期結果：成功
-- -------------------------

SELECT *
FROM Admin_View;


-- -------------------------
-- 3-2 管理者可以修改訂單狀態
-- 預期結果：成功
-- -------------------------

UPDATE `Order`
SET oStatus = '已付款'
WHERE oID = 1;


-- -------------------------
-- 3-3 管理者可以修改付款狀態
-- 預期結果：成功
-- -------------------------

UPDATE Invoice
SET paymentStatus = '已付款',
    iDate = '2026-06-10'
WHERE iID = 1;


-- -------------------------
-- 3-4 管理者新增測試分類
-- 預期結果：成功
-- -------------------------

INSERT INTO Category
(cName, cDescription)
VALUES
('管理者測試分類', '此分類用於管理者新增與刪除測試。');


-- -------------------------
-- 3-5 管理者修改測試分類
-- 預期結果：成功
-- -------------------------

UPDATE Category
SET cDescription = '此分類已由管理者修改。'
WHERE cName = '管理者測試分類';


-- -------------------------
-- 3-6 管理者刪除測試分類
-- 預期結果：成功
-- -------------------------

DELETE FROM Category
WHERE cName = '管理者測試分類';


-- -------------------------
-- 3-7 管理者建立測試 View
-- 預期結果：成功
-- 若目前 admin_user 沒有 CREATE 權限，請在 permission.sql 補上 CREATE, DROP
-- -------------------------

CREATE OR REPLACE VIEW Admin_Test_View AS
SELECT
    mID,
    mAccount,
    mName,
    mRole
FROM Member;


-- -------------------------
-- 3-8 管理者刪除測試 View
-- 預期結果：成功
-- -------------------------

DROP VIEW Admin_Test_View;
