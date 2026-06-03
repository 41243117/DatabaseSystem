USE secondhand_platform;

SET NAMES utf8mb4;

--Member--
INSERT INTO Member
(mID, mAccount, mName, mEmail, mPhone, mRole, mCreateDate)
VALUES
(1001, 'seller_chen', '陳小美', 'seller.chen@example.com', '0912345678', '賣家', '2026-03-01'),
(1002, 'seller_wang', '王書豪', 'seller.wang@example.com', '0922333444', '賣家', '2026-03-02'),
(1003, 'seller_lin88', '林家豪', 'seller.lin88@example.com', '0933456789', '賣家', '2026-03-03'),
(2001, 'buyer_ming01', '李小明', 'buyer.ming01@example.com', '0944567890', '買家', '2026-03-05'),
(2002, 'buyer_anna02', '張小安', 'buyer.anna02@example.com', '0955678901', '買家', '2026-03-06'),
(2003, 'buyer_jun03', '黃小均', 'buyer.jun03@example.com', '0966789012', '買家', '2026-03-08');

--Category--
INSERT INTO Category
(cID, cName, cDescription)
VALUES
(1, '手機平板', '手機、平板與相關配件'),
(2, '電腦周邊', '鍵盤、滑鼠、螢幕與其他電腦周邊設備'),
(3, '書籍教材', '教科書、參考書、小說與講義'),
(4, '居家用品', '家具、收納用品與生活用品');

--PaymentMethod--
INSERT INTO PaymentMethod
(pmID, methodName)
VALUES
(1, '信用卡'),
(2, '銀行轉帳'),
(3, '電子支付'),
(4, '貨到付款');

--ShipmentMethod--
INSERT INTO ShipmentMethod
(smID, methodName)
VALUES
(1, '超商取貨'),
(2, '宅配'),
(3, '面交');

--Product--
INSERT INTO Product
(pID, sellerID, cID, pName, description, price, pCondition, pStatus, postDate)
VALUES
(1, 1001, 1, '二手 iPhone 14 128GB',
 '功能正常，電池健康度 88%，附保護殼與充電線。',
 15000.00, '九成新', '已售出', '2026-04-10'),

(2, 1001, 1, 'AirPods Pro 2',
 '盒裝完整，少量使用，耳機功能正常。',
 4200.00, '幾乎全新', '上架中', '2026-04-12'),

(3, 1002, 3, '資料庫系統概論課本',
 '內頁有少量畫線，不影響閱讀。',
 450.00, '七成新', '已售出', '2026-04-15'),

(4, 1003, 4, '北歐風小茶几',
 '桌面有使用痕跡，但結構穩固。',
 800.00, '使用痕跡明顯', '已下架', '2026-04-18'),

(5, 1003, 2, '機械鍵盤 茶軸',
 'RGB 燈效正常，附拔鍵器與原盒。',
 1600.00, '幾乎全新', '已售出', '2026-04-20'),

(6, 1002, 3, '演算法參考書',
 '書況良好，僅封面有些微折痕。',
 350.00, '九成新', '上架中', '2026-04-21');

--Order--
INSERT INTO `Order`
(oID, buyerID, oDate, oStatus, totalAmount)
VALUES
(3001, 2001, '2026-04-20', '已完成', 15000.00),
(3002, 2002, '2026-04-23', '已完成', 450.00),
(3003, 2003, '2026-04-25', '已付款', 1600.00);

--OrderDetail--
INSERT INTO OrderDetail
(odID, oID, pID, quantity, dealPrice)
VALUES
(4001, 3001, 1, 1, 15000.00),
(4002, 3002, 3, 1, 450.00),
(4003, 3003, 5, 1, 1600.00);

--Invoice--
INSERT INTO Invoice
(iID, oID, pmID, iDate, amount, paymentStatus)
VALUES
(5001, 3001, 3, '2026-04-20', 15000.00, '已付款'),
(5002, 3002, 2, '2026-04-23', 450.00, '已付款'),
(5003, 3003, 1, '2026-04-25', 1600.00, '已付款');

--Shipment--
INSERT INTO Shipment
(sID, oID, smID, sDate, sStatus)
VALUES
(6001, 3001, 1, '2026-04-21', '已送達'),
(6002, 3002, 2, '2026-04-24', '已送達'),
(6003, 3003, 1, NULL, '待出貨');

--Review--
INSERT INTO Review
(rID, oID, mID, score, comment, rDate)
VALUES
(7001, 3001, 2001, 5,
 '商品狀況符合描述，包裝完整，交易過程順利。',
 '2026-04-23'),

(7002, 3002, 2002, 4,
 '書況和描述相符，價格合理。',
 '2026-04-26');


SELECT * FROM Member;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM PaymentMethod;
SELECT * FROM ShipmentMethod;
SELECT * FROM `Order`;
SELECT * FROM OrderDetail;
SELECT * FROM Invoice;
SELECT * FROM Shipment;
SELECT * FROM Review;
```
