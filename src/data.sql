USE secondhand_platform;
SET NAMES utf8mb4;

-- Member：不輸入 mID，讓 AUTO_INCREMENT 自動產生
INSERT INTO Member
(mAccount, mName, mEmail, mPhone, mRole, mCreateDate)
VALUES
('seller_chen', '陳小美', 'seller.chen@example.com', '0912345678', '賣家', '2026-03-01'),
('seller_wang', '王書豪', 'seller.wang@example.com', '0922333444', '賣家', '2026-03-02'),
('seller_lin88', '林家豪', 'seller.lin88@example.com', '0933456789', '賣家', '2026-03-03'),
('buyer_ming01', '李小明', 'buyer.ming01@example.com', '0944567890', '買家', '2026-03-05'),
('buyer_anna02', '張小安', 'buyer.anna02@example.com', '0955678901', '買家', '2026-03-06'),
('buyer_jun03', '黃小均', 'buyer.jun03@example.com', '0966789012', '買家', '2026-03-08');

-- Category：不輸入 cID
INSERT INTO Category
(cName, cDescription)
VALUES
('手機平板', '手機、平板與相關配件'),
('電腦周邊', '鍵盤、滑鼠、螢幕與其他電腦周邊設備'),
('書籍教材', '教科書、參考書、小說與講義'),
('居家用品', '家具、收納用品與生活用品');

-- PaymentMethod：不輸入 pmID
INSERT INTO PaymentMethod
(methodName)
VALUES
('信用卡'),
('銀行轉帳'),
('電子支付'),
('貨到付款');

-- ShipmentMethod：不輸入 smID
INSERT INTO ShipmentMethod
(methodName)
VALUES
('超商取貨'),
('宅配'),
('面交');

-- Product：pID 不輸入，但 sellerID、cID 是外鍵，要查出來
INSERT INTO Product
(sellerID, cID, pName, description, price, pCondition, pStatus, postDate)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_chen'),
  (SELECT cID FROM Category WHERE cName = '手機平板'),
  '二手 iPhone 14 128GB',
  '功能正常，電池健康度 88%，附保護殼與充電線。',
  15000.00,
  '九成新',
  '已售出',
  '2026-04-10'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_chen'),
  (SELECT cID FROM Category WHERE cName = '手機平板'),
  'AirPods Pro 2',
  '盒裝完整，少量使用，耳機功能正常。',
  4200.00,
  '幾乎全新',
  '上架中',
  '2026-04-12'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
  (SELECT cID FROM Category WHERE cName = '書籍教材'),
  '資料庫系統概論課本',
  '內頁有少量畫線，不影響閱讀。',
  450.00,
  '七成新',
  '已售出',
  '2026-04-15'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_lin88'),
  (SELECT cID FROM Category WHERE cName = '居家用品'),
  '北歐風小茶几',
  '桌面有使用痕跡，但結構穩固。',
  800.00,
  '使用痕跡明顯',
  '已下架',
  '2026-04-18'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_lin88'),
  (SELECT cID FROM Category WHERE cName = '電腦周邊'),
  '機械鍵盤 茶軸',
  'RGB 燈效正常，附拔鍵器與原盒。',
  1600.00,
  '幾乎全新',
  '已售出',
  '2026-04-20'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
  (SELECT cID FROM Category WHERE cName = '書籍教材'),
  '演算法參考書',
  '書況良好，僅封面有些微折痕。',
  350.00,
  '九成新',
  '上架中',
  '2026-04-21'
);

-- Order：oID 不輸入，buyerID 用會員帳號查
INSERT INTO `Order`
(buyerID, oDate, oStatus, totalAmount)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  '2026-04-20',
  '已完成',
  15000.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  '2026-04-23',
  '已完成',
  450.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03'),
  '2026-04-25',
  '已付款',
  1600.00
);

-- OrderDetail：odID 不輸入，oID 和 pID 用查詢找
INSERT INTO OrderDetail
(oID, pID, quantity, dealPrice)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'
     AND totalAmount = 15000.00),
  (SELECT pID FROM Product WHERE pName = '二手 iPhone 14 128GB'),
  1,
  15000.00
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'
     AND totalAmount = 450.00),
  (SELECT pID FROM Product WHERE pName = '資料庫系統概論課本'),
  1,
  450.00
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
     AND oDate = '2026-04-25'
     AND totalAmount = 1600.00),
  (SELECT pID FROM Product WHERE pName = '機械鍵盤 茶軸'),
  1,
  1600.00
);

-- Invoice：iID 不輸入
INSERT INTO Invoice
(oID, pmID, iDate, amount, paymentStatus)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
  '2026-04-20',
  15000.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '銀行轉帳'),
  '2026-04-23',
  450.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
     AND oDate = '2026-04-25'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '信用卡'),
  '2026-04-25',
  1600.00,
  '已付款'
);

-- Shipment：sID 不輸入
INSERT INTO Shipment
(oID, smID, sDate, sStatus)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '2026-04-21',
  '已送達'
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  (SELECT smID FROM ShipmentMethod WHERE methodName = '宅配'),
  '2026-04-24',
  '已送達'
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
     AND oDate = '2026-04-25'),
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  NULL,
  '待出貨'
);

-- Review：rID 不輸入
INSERT INTO Review
(oID, mID, score, comment, rDate)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  5,
  '商品狀況符合描述，包裝完整，交易過程順利。',
  '2026-04-23'
),
(
  (SELECT oID FROM `Order`
   WHERE buyerID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  4,
  '書況和描述相符，價格合理。',
  '2026-04-26'
);
