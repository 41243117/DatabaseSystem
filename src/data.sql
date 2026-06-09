USE SecHand;
SET NAMES utf8mb4;

INSERT INTO Member
(mAccount, mName, mEmail, mPhone, mRole, mCreateDate)
VALUES
('seller_chen', '陳小美', 'seller.chen@example.com', '0912345678', '賣家', '2026-03-01'),
('seller_wang', '王書豪', 'seller.wang@example.com', '0922333444', '賣家', '2026-03-02'),
('seller_lin88', '林家豪', 'seller.lin88@example.com', '0933456789', '賣家', '2026-03-03'),
('buyer_ming01', '李小明', 'buyer.ming01@example.com', '0944567890', '買家', '2026-03-05'),
('buyer_anna02', '張小安', 'buyer.anna02@example.com', '0955678901', '買家', '2026-03-06'),
('buyer_jun03', '黃小均', 'buyer.jun03@example.com', '0966789012', '買家', '2026-03-08');

INSERT INTO Category
(cName, cDescription)
VALUES
('手機平板', '手機、平板與相關配件'),
('電腦周邊', '鍵盤、滑鼠、螢幕與其他電腦周邊設備'),
('書籍教材', '教科書、參考書、小說與講義'),
('居家用品', '家具、收納用品與生活用品');

INSERT INTO PaymentMethod
(methodName)
VALUES
('信用卡'),
('銀行轉帳'),
('電子支付'),
('貨到付款');

INSERT INTO ShipmentMethod
(methodName)
VALUES
('超商取貨'),
('宅配'),
('面交');

INSERT INTO Product
(mID, cID, pCondition, pName, pStatus, description, postDate, price)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_chen'),
  (SELECT cID FROM Category WHERE cName = '手機平板'),
  '九成新',
  '二手 iPhone 14 128GB',
  '已售出',
  '功能正常，電池健康度 88%，附保護殼與充電線。',
  '2026-04-10',
  15000.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_chen'),
  (SELECT cID FROM Category WHERE cName = '手機平板'),
  '幾乎全新',
  'AirPods Pro 2',
  '上架中',
  '盒裝完整，少量使用，耳機功能正常。',
  '2026-04-12',
  4200.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
  (SELECT cID FROM Category WHERE cName = '書籍教材'),
  '七成新',
  '資料庫系統概論課本',
  '已售出',
  '內頁有少量畫線，不影響閱讀。',
  '2026-04-15',
  450.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_lin88'),
  (SELECT cID FROM Category WHERE cName = '居家用品'),
  '使用痕跡明顯',
  '北歐風小茶几',
  '已下架',
  '桌面有使用痕跡，但結構穩固。',
  '2026-04-18',
  800.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_lin88'),
  (SELECT cID FROM Category WHERE cName = '電腦周邊'),
  '幾乎全新',
  '機械鍵盤 茶軸',
  '已售出',
  'RGB 燈效正常，附拔鍵器與原盒。',
  '2026-04-20',
  1600.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_wang'),
  (SELECT cID FROM Category WHERE cName = '書籍教材'),
  '九成新',
  '演算法參考書',
  '上架中',
  '書況良好，僅封面有些微折痕。',
  '2026-04-21',
  350.00
);

INSERT INTO `Order`
(mID, oStatus, oDate, totalAmount)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  '已完成',
  '2026-04-20',
  15000.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  '已完成',
  '2026-04-23',
  450.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03'),
  '已付款',
  '2026-04-25',
  1600.00
);

INSERT INTO Shipment
(smID, sStatus, sDate)
VALUES
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '已送達',
  '2026-04-21'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '宅配'),
  '已送達',
  '2026-04-24'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '待出貨',
  NULL
);

INSERT INTO OrderDetail
(oID, pID, sID, quantity, dealPrice)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  (SELECT pID FROM Product WHERE pName = '二手 iPhone 14 128GB'),
  1,
  1,
  15000.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  (SELECT pID FROM Product WHERE pName = '資料庫系統概論課本'),
  2,
  1,
  450.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
     AND oDate = '2026-04-25'),
  (SELECT pID FROM Product WHERE pName = '機械鍵盤 茶軸'),
  3,
  1,
  1600.00
);

INSERT INTO Invoice
(oID, pmID, iDate, amount, paymentStatus)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
  '2026-04-20',
  15000.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '銀行轉帳'),
  '2026-04-23',
  450.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
     AND oDate = '2026-04-25'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '信用卡'),
  '2026-04-25',
  1600.00,
  '已付款'
);

INSERT INTO Review
(mID, oID, score, comment, rDate)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
     AND oDate = '2026-04-20'),
  5,
  '商品狀況符合描述，包裝完整，交易過程順利。',
  '2026-04-23'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
     AND oDate = '2026-04-23'),
  4,
  '書況和描述相符，價格合理。',
  '2026-04-26'
);
