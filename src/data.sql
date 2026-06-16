-- =========================
-- 補資料到 10 筆
-- 請貼在原本 data.sql 最下面
-- =========================

USE SecHand;

-- Member：原本 6 筆，補到 10 筆
INSERT INTO Member
(mAccount, mName, mEmail, mPhone, mRole, mCreateDate)
VALUES
('seller_liu09', '劉志明', 'seller.liu09@example.com', '0977890123', '賣家', '2026-03-09'),
('seller_tsai10', '蔡依婷', 'seller.tsai10@example.com', '0988901234', '賣家', '2026-03-10'),
('buyer_kai04', '吳小凱', 'buyer.kai04@example.com', '0999012345', '買家', '2026-03-11'),
('buyer_yu05', '鄭小瑜', 'buyer.yu05@example.com', '0900123456', '買家', '2026-03-12');


-- Category：原本 4 筆，補到 10 筆
INSERT INTO Category
(cName, cDescription)
VALUES
('生活家電', '電風扇、吹風機、檯燈與其他小家電'),
('運動用品', '球具、瑜珈用品與健身器材'),
('美妝保養', '保養品、化妝品與美容工具'),
('服飾配件', '衣服、鞋子、包包與飾品'),
('遊戲娛樂', '遊戲片、主機配件與娛樂用品'),
('票券禮品', '禮券、票券與禮品卡');


-- Product：原本 6 筆，補到 10 筆
INSERT INTO Product
(mID, cID, pCondition, pName, pStatus, description, postDate, price)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_liu09'),
  (SELECT cID FROM Category WHERE cName = '電腦周邊'),
  '九成新',
  '羅技無線滑鼠',
  '已售出',
  '功能正常，外觀乾淨，適合文書與日常使用。',
  '2026-04-22',
  550.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_liu09'),
  (SELECT cID FROM Category WHERE cName = '生活家電'),
  '七成新',
  '小型電風扇',
  '已售出',
  '風量正常，適合宿舍或書桌使用。',
  '2026-04-23',
  300.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_tsai10'),
  (SELECT cID FROM Category WHERE cName = '運動用品'),
  '幾乎全新',
  '瑜珈墊',
  '已售出',
  '只使用過幾次，表面乾淨無破損。',
  '2026-04-24',
  250.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'seller_tsai10'),
  (SELECT cID FROM Category WHERE cName = '遊戲娛樂'),
  '九成新',
  'Nintendo Switch 遊戲片',
  '已售出',
  '遊戲片讀取正常，外盒保存良好。',
  '2026-04-25',
  900.00
);


-- 把原本還是上架中/已下架、但後面要加入訂單的商品改成已售出，資料比較合理
UPDATE Product
SET pStatus = '已售出'
WHERE pName IN ('AirPods Pro 2', '北歐風小茶几', '演算法參考書');


-- Order：原本 3 筆，補到 10 筆
INSERT INTO `Order`
(mID, oStatus, oDate, totalAmount)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  '已完成',
  '2026-04-26',
  4200.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  '已完成',
  '2026-04-27',
  800.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04'),
  '已完成',
  '2026-04-28',
  350.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05'),
  '已完成',
  '2026-04-29',
  550.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  '已完成',
  '2026-05-01',
  300.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04'),
  '已完成',
  '2026-05-02',
  250.00
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05'),
  '已完成',
  '2026-05-03',
  900.00
);


-- Shipment：原本 3 筆，補到 10 筆
INSERT INTO Shipment
(smID, sStatus, sDate)
VALUES
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '已送達',
  '2026-04-27'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '面交'),
  '已送達',
  '2026-04-28'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '宅配'),
  '已送達',
  '2026-04-29'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '已送達',
  '2026-04-30'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '宅配'),
  '已送達',
  '2026-05-02'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '面交'),
  '已送達',
  '2026-05-03'
),
(
  (SELECT smID FROM ShipmentMethod WHERE methodName = '超商取貨'),
  '已送達',
  '2026-05-04'
);


-- OrderDetail：原本 3 筆，補到 10 筆
INSERT INTO OrderDetail
(oID, pID, sID, quantity, dealPrice)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-04-26'),
  (SELECT pID FROM Product WHERE pName = 'AirPods Pro 2'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-04-27' LIMIT 1),
  1,
  4200.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
   AND oDate = '2026-04-27'),
  (SELECT pID FROM Product WHERE pName = '北歐風小茶几'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-04-28' LIMIT 1),
  1,
  800.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-04-28'),
  (SELECT pID FROM Product WHERE pName = '演算法參考書'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-04-29' LIMIT 1),
  1,
  350.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-04-29'),
  (SELECT pID FROM Product WHERE pName = '羅技無線滑鼠'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-04-30' LIMIT 1),
  1,
  550.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-05-01'),
  (SELECT pID FROM Product WHERE pName = '小型電風扇'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-05-02' LIMIT 1),
  1,
  300.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-05-02'),
  (SELECT pID FROM Product WHERE pName = '瑜珈墊'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-05-03' LIMIT 1),
  1,
  250.00
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-05-03'),
  (SELECT pID FROM Product WHERE pName = 'Nintendo Switch 遊戲片'),
  (SELECT sID FROM Shipment WHERE sStatus = '已送達' AND sDate = '2026-05-04' LIMIT 1),
  1,
  900.00
);


-- Invoice：原本 3 筆，補到 10 筆
INSERT INTO Invoice
(oID, pmID, iDate, amount, paymentStatus)
VALUES
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-04-26'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
  '2026-04-26',
  4200.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
   AND oDate = '2026-04-27'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '銀行轉帳'),
  '2026-04-27',
  800.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-04-28'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '信用卡'),
  '2026-04-28',
  350.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-04-29'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
  '2026-04-29',
  550.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-05-01'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '貨到付款'),
  '2026-05-01',
  300.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-05-02'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '電子支付'),
  '2026-05-02',
  250.00,
  '已付款'
),
(
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-05-03'),
  (SELECT pmID FROM PaymentMethod WHERE methodName = '信用卡'),
  '2026-05-03',
  900.00,
  '已付款'
);


-- Review：原本 2 筆，補到 10 筆
INSERT INTO Review
(mID, oID, score, comment, rDate)
VALUES
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_jun03')
   AND oDate = '2026-04-25'),
  5,
  '鍵盤狀況很好，出貨速度也很快。',
  '2026-04-28'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-04-26'),
  5,
  '耳機音質正常，包裝也很完整。',
  '2026-04-29'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_anna02')
   AND oDate = '2026-04-27'),
  4,
  '茶几和描述差不多，整體滿意。',
  '2026-04-30'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-04-28'),
  5,
  '書況很好，價格合理。',
  '2026-05-01'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-04-29'),
  4,
  '滑鼠功能正常，外觀也乾淨。',
  '2026-05-02'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_ming01')
   AND oDate = '2026-05-01'),
  4,
  '電風扇可以正常使用，交易順利。',
  '2026-05-04'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_kai04')
   AND oDate = '2026-05-02'),
  5,
  '瑜珈墊很新，沒有明顯髒污。',
  '2026-05-05'
),
(
  (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05'),
  (SELECT oID FROM `Order`
   WHERE mID = (SELECT mID FROM Member WHERE mAccount = 'buyer_yu05')
   AND oDate = '2026-05-03'),
  5,
  '遊戲片讀取正常，保存狀況很好。',
  '2026-05-06'
);
