INSERT INTO
    `Member` (
        `mID`,
        `mAccount`,
        `mName`,
        `mEmail`,
        `mPhone`,
        `mRole`,
        `createDate`
    )
VALUES
    (
        1001,
        'buyer_ming01',
        '林小明',
        'ming01@example.com',
        '0912345678',
        '買家',
        '2026-03-01'
    ),
    (
        1002,
        'buyer_han02',
        '陳怡涵',
        'yihan02@example.com',
        '0922333444',
        '買家',
        '2026-03-03'
    ),
    (
        1003,
        'buyer_yu03',
        '張家瑜',
        'jiayu03@example.com',
        '0933555666',
        '買家',
        '2026-03-08'
    ),
    (
        1004,
        'buyer_kai04',
        '王柏凱',
        'bokai04@example.com',
        '0966888999',
        '買家',
        '2026-03-12'
    ),
    (
        2001,
        'seller_lee01',
        '李承恩',
        'seller.lee01@example.com',
        '0977111222',
        '賣家',
        '2026-02-20'
    ),
    (
        2002,
        'seller_wu02',
        '吳佳蓉',
        'seller.wu02@example.com',
        '0988222333',
        '賣家',
        '2026-02-25'
    ),
    (
        2003,
        'seller_tsai03',
        '蔡宗翰',
        'seller.tsai03@example.com',
        '0955444333',
        '賣家',
        '2026-03-05'
    ),
    (
        2004,
        'seller_lin04',
        '林佩君',
        'seller.lin04@example.com',
        '0911222333',
        '賣家',
        '2026-03-10'
    );

-- (3001, 'bad', '測試者', 'bad@example.com', '0911111111', '買家', '2026-03-01') CONSTRAINT failed (mAccount 長度需 6～30 字元)
-- (3002, 'buyer_test01', '重複信箱', 'ming01@example.com', '0911111112', '買家', '2026-03-01') CONSTRAINT failed (mEmail 不可重複)
-- (3003, 'buyer_test02', '角色錯誤', 'role@example.com', '0911111113', '管理員', '2026-03-01') CONSTRAINT failed (mRole 只能是「買家」、「賣家」)

-- Category
INSERT INTO
    `Category` (`cID`, `cName`, `cDescription`)
VALUES
    (1, '手機', '二手手機與智慧型手機相關商品'),
    (2, '3C配件', '耳機、行動電源、充電器等電子配件'),
    (3, '遊戲娛樂', '遊戲主機、遊戲片與相關周邊'),
    (4, '筆電', '筆記型電腦與電腦設備'),
    (5, '居家生活', '家具、收納與生活用品'),
    (6, '相機攝影', '相機、鏡頭與攝影配件'),
    (7, '書籍講義', '二手書、教科書與課程講義');

-- (8, '手機', '重複分類名稱') CONSTRAINT failed (cName 不可重複)
-- (9, '', '分類名稱不可空白') CONSTRAINT failed (cName 長度 1～50 字元)

-- Product
INSERT INTO
    `Product` (
        `pID`,
        `sellerID`,
        `cID`,
        `pName`,
        `description`,
        `price`,
        `pCondition`,
        `pStatus`,
        `postDate`
    )
VALUES
    (
        3001,
        2001,
        1,
        '二手 iPhone 14 128GB 藍色',
        '功能正常，電池健康度 88%，盒裝與充電線齊全。',
        12000,
        '九成新',
        '已售出',
        '2026-04-10'
    ),
    (
        3002,
        2002,
        2,
        'AirPods Pro 2',
        '耳機與充電盒皆可正常使用，附保護殼。',
        3000,
        '七成新',
        '已售出',
        '2026-04-12'
    ),
    (
        3003,
        2003,
        3,
        'Nintendo Switch OLED 白色',
        '主機螢幕無明顯刮痕，附 Joy-Con 與底座。',
        7200,
        '九成新',
        '已售出',
        '2026-04-15'
    ),
    (
        3004,
        2004,
        4,
        'ASUS Vivobook 14',
        '文書筆電，8GB RAM，256GB SSD，外觀有使用痕跡。',
        15000,
        '七成新',
        '已下架',
        '2026-04-18'
    ),
    (
        3005,
        2001,
        5,
        'Patagonia 後背包 25L',
        '適合上課與通勤，拉鍊正常，背帶完整。',
        1600,
        '幾乎全新',
        '上架中',
        '2026-05-01'
    ),
    (
        3006,
        2002,
        5,
        '無印良品透明收納盒三件組',
        '外觀乾淨，尺寸適合桌面與衣櫃收納。',
        350,
        '九成新',
        '上架中',
        '2026-05-03'
    ),
    (
        3007,
        2003,
        6,
        'Canon EOS M50 單機身',
        '快門數約 9000，功能正常，附原廠電池與充電器。',
        14500,
        '九成新',
        '已售出',
        '2026-05-05'
    ),
    (
        3008,
        2004,
        7,
        '大一英文課本與練習本',
        '有少量筆記，不影響閱讀。',
        280,
        '使用痕跡明顯',
        '已售出',
        '2026-05-06'
    ),
    (
        3009,
        2001,
        2,
        '小米 10000mAh 行動電源',
        '可正常充電，外殼有輕微刮痕。',
        450,
        '七成新',
        '已售出',
        '2026-05-08'
    ),
    (
        3010,
        2002,
        5,
        'IKEA 工作椅',
        '椅面有磨損，已下架暫不販售。',
        900,
        '使用痕跡明顯',
        '已下架',
        '2026-05-10'
    ),
    (
        3011,
        2003,
        2,
        'Sony WH-1000XM4 無線耳機',
        '降噪功能正常，附收納盒。',
        4800,
        '幾乎全新',
        '上架中',
        '2026-05-12'
    );

-- (3012, 2001, 1, '價格錯誤商品', '價格不可小於等於 0', 0, '九成新', '上架中', '2026-05-12') CONSTRAINT failed (price 必須大於 0)
-- (3013, 2001, 1, '狀況錯誤商品', '商品狀況不在允許值內', 1000, '普通', '上架中', '2026-05-12') CONSTRAINT failed (pCondition 值域錯誤)
-- (3014, 2001, 1, '狀態錯誤商品', '商品狀態不在允許值內', 1000, '九成新', '保留中', '2026-05-12') CONSTRAINT failed (pStatus 值域錯誤)

-- PaymentMethod
INSERT INTO
    `PaymentMethod` (`pmID`, `methodName`)
VALUES
    (1, '信用卡'),
    (2, '銀行轉帳'),
    (3, '電子支付'),
    (4, '貨到付款');

-- (5, '信用卡') CONSTRAINT failed (methodName 不可重複)
-- (6, '支票') CONSTRAINT failed (methodName 只能是「信用卡」、「銀行轉帳」、「電子支付」、「貨到付款」)

-- ShipmentMethod
INSERT INTO
    `ShipmentMethod` (`smID`, `methodName`)
VALUES
    (1, '超商取貨'),
    (2, '宅配'),
    (3, '面交');

-- (4, '宅配') CONSTRAINT failed (methodName 不可重複)
-- (5, '海外空運') CONSTRAINT failed (methodName 只能是「超商取貨」、「宅配」、「面交」)

-- Order
INSERT INTO
    `Order` (`oID`, `buyerID`, `oDate`, `oStatus`, `totalAmount`)
VALUES
    (5001, 1001, '2026-05-02', '已完成', 12000),
    (5002, 1002, '2026-05-10', '已出貨', 3450),
    (5003, 1003, '2026-05-16', '待付款', 7200),
    (5004, 1004, '2026-05-17', '已完成', 280),
    (5005, 1001, '2026-05-20', '已付款', 14500),
    (5006, 1002, '2026-05-21', '已取消', 15000);

-- (5007, 1001, '2026-05-22', '處理中', 1000) CONSTRAINT failed (oStatus 值域錯誤)
-- (5008, 1001, '2026-05-22', '待付款', -100) CONSTRAINT failed (totalAmount 必須大於或等於 0)
-- (5009, 9999, '2026-05-22', '待付款', 1000) CONSTRAINT failed (buyerID 必須參照 Member.mID)

-- OrderDetail
INSERT INTO
    `OrderDetail` (`odID`, `oID`, `pID`, `quantity`, `dealPrice`)
VALUES
    (6001, 5001, 3001, 1, 12000),
    (6002, 5002, 3002, 1, 3000),
    (6003, 5002, 3009, 1, 450),
    (6004, 5003, 3003, 1, 7200),
    (6005, 5004, 3008, 1, 280),
    (6006, 5005, 3007, 1, 14500),
    (6007, 5006, 3004, 1, 15000);

-- (6008, 5001, 3005, 0, 1600) CONSTRAINT failed (quantity 必須大於 0)
-- (6009, 5001, 3005, 1, 0) CONSTRAINT failed (dealPrice 必須大於 0)
-- (6010, 5002, 3001, 1, 12000) CONSTRAINT failed (同一商品最多只能出現在一筆訂單明細)

-- Invoice
INSERT INTO
    `Invoice` (`iID`, `oID`, `pmID`, `iDate`, `amount`, `paymentStatus`)
VALUES
    (7001, 5001, 1, '2026-05-02', 12000, '已付款'),
    (7002, 5002, 3, '2026-05-10', 3450, '已付款'),
    (7003, 5003, 2, NULL, 7200, '未付款'),
    (7004, 5004, 4, '2026-05-17', 280, '已付款'),
    (7005, 5005, 3, '2026-05-20', 14500, '已付款'),
    (7006, 5006, 1, '2026-05-21', 15000, '已退款');

-- (7007, 5001, 1, '2026-05-01', 12000, '已付款') CONSTRAINT failed (iDate 不可早於 oDate)
-- (7008, 5001, 1, '2026-05-02', 100, '已付款') CONSTRAINT failed (amount 應等於 Order.totalAmount)
-- (7009, 5001, 1, '2026-05-02', 12000, '處理中') CONSTRAINT failed (paymentStatus 值域錯誤)

-- Shipment
INSERT INTO
    `Shipment` (`sID`, `oID`, `smID`, `sDate`, `sStatus`)
VALUES
    (8001, 5001, 2, '2026-05-03', '已送達'),
    (8002, 5002, 1, '2026-05-11', '配送中'),
    (8003, 5003, 1, NULL, '待出貨'),
    (8004, 5004, 3, '2026-05-17', '已送達'),
    (8005, 5005, 2, NULL, '待出貨'),
    (8006, 5006, 2, NULL, '已取消');

-- (8007, 5001, 2, '2026-05-01', '已寄出') CONSTRAINT failed (sDate 不可早於付款日期)
-- (8008, 5001, 2, '2026-05-03', '運送中') CONSTRAINT failed (sStatus 值域錯誤)
-- (8009, 5001, 9, '2026-05-03', '已寄出') CONSTRAINT failed (smID 必須參照 ShipmentMethod.smID)

-- Review
INSERT INTO
    `Review` (`rID`, `oID`, `mID`, `score`, `comment`, `rDate`)
VALUES
    (9001, 5001, 1001, 5, '商品保存良好，賣家回覆速度很快。', '2026-05-06'),
    (9002, 5004, 1004, 4, '書況符合描述，面交很順利。', '2026-05-18');

-- (9003, 5001, 1001, 6, '評分不可超過 5', '2026-05-06') CONSTRAINT failed (score 必須介於 1 到 5)
-- (9004, 5003, 1003, 5, '尚未完成訂單不可評價', '2026-05-18') CONSTRAINT failed (rDate 不可早於訂單完成日期)
-- (9005, 5001, 1001, 5, '同一訂單重複評價', '2026-05-07') CONSTRAINT failed (一份訂單最多只能有一筆評價)

