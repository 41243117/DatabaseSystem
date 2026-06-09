-- ============================================
-- 二手物品交易平台 table.sql
-- Database: secondhand_platform
-- ============================================

DROP DATABASE IF EXISTS secondhand_platform;

CREATE DATABASE secondhand_platform
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE secondhand_platform;

-- ============================================
-- 1. Member 會員資料表
-- ============================================

CREATE TABLE Member (
    mID INT AUTO_INCREMENT PRIMARY KEY,

    mAccount VARCHAR(30) NOT NULL,
    mName VARCHAR(50) NOT NULL,
    mEmail VARCHAR(100) NOT NULL,
    mPhone VARCHAR(10) NOT NULL,
    mAddress VARCHAR(200),

    mRole ENUM('買家', '賣家', '買賣家') NOT NULL,
    mCreateDate DATE NOT NULL,

    CONSTRAINT uq_member_account UNIQUE (mAccount),
    CONSTRAINT uq_member_email UNIQUE (mEmail),

    CONSTRAINT chk_member_account_length
        CHECK (CHAR_LENGTH(mAccount) BETWEEN 6 AND 30),

    CONSTRAINT chk_member_account_format
        CHECK (mAccount REGEXP '^[A-Za-z0-9_]+$'),

    CONSTRAINT chk_member_name
        CHECK (CHAR_LENGTH(TRIM(mName)) BETWEEN 1 AND 50),

    CONSTRAINT chk_member_email_format
        CHECK (mEmail REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),

    CONSTRAINT chk_member_phone_format
        CHECK (mPhone REGEXP '^09[0-9]{8}$'),

    CONSTRAINT chk_member_address_length
        CHECK (mAddress IS NULL OR CHAR_LENGTH(mAddress) <= 200)
);

-- ============================================
-- 2. Category 商品分類資料表
-- ============================================

CREATE TABLE Category (
    cID INT AUTO_INCREMENT PRIMARY KEY,

    cName VARCHAR(50) NOT NULL,
    cDescription VARCHAR(200),

    CONSTRAINT uq_category_name UNIQUE (cName),

    CONSTRAINT chk_category_name
        CHECK (CHAR_LENGTH(TRIM(cName)) BETWEEN 1 AND 50),

    CONSTRAINT chk_category_description
        CHECK (cDescription IS NULL OR CHAR_LENGTH(cDescription) <= 200)
);

-- ============================================
-- 3. Product 商品資料表
-- ============================================

CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,

    sellerID INT NOT NULL,
    cID INT NOT NULL,

    pName VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,

    pCondition ENUM(
        '全新未使用',
        '幾乎全新',
        '九成新',
        '七成新',
        '使用痕跡明顯',
        '故障品'
    ) NOT NULL,

    pStatus ENUM(
        '上架中',
        '已售出',
        '已下架'
    ) NOT NULL,

    postDate DATE NOT NULL,

    CONSTRAINT fk_product_seller
        FOREIGN KEY (sellerID) REFERENCES Member(mID),

    CONSTRAINT fk_product_category
        FOREIGN KEY (cID) REFERENCES Category(cID),

    CONSTRAINT chk_product_name
        CHECK (CHAR_LENGTH(TRIM(pName)) BETWEEN 1 AND 100),

    CONSTRAINT chk_product_description
        CHECK (description IS NULL OR CHAR_LENGTH(description) <= 500),

    CONSTRAINT chk_product_price
        CHECK (price > 0)
);

-- ============================================
-- 4. PaymentMethod 付款方式資料表
-- ============================================

CREATE TABLE PaymentMethod (
    pmID INT AUTO_INCREMENT PRIMARY KEY,

    methodName ENUM(
        '信用卡',
        '銀行轉帳',
        '電子支付',
        '貨到付款'
    ) NOT NULL,

    methodDescription VARCHAR(200),

    CONSTRAINT uq_payment_method_name UNIQUE (methodName),

    CONSTRAINT chk_payment_method_description
        CHECK (methodDescription IS NULL OR CHAR_LENGTH(methodDescription) <= 200)
);

-- ============================================
-- 5. ShipmentMethod 物流方式資料表
-- ============================================

CREATE TABLE ShipmentMethod (
    smID INT AUTO_INCREMENT PRIMARY KEY,

    methodName ENUM(
        '超商取貨',
        '宅配',
        '面交'
    ) NOT NULL,

    methodDescription VARCHAR(200),

    CONSTRAINT uq_shipment_method_name UNIQUE (methodName),

    CONSTRAINT chk_shipment_method_description
        CHECK (methodDescription IS NULL OR CHAR_LENGTH(methodDescription) <= 200)
);

-- ============================================
-- 6. Order 訂單資料表
-- ============================================

CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,

    buyerID INT NOT NULL,
    oDate DATE NOT NULL,

    oStatus ENUM(
        '待付款',
        '已付款',
        '已出貨',
        '已完成',
        '已取消'
    ) NOT NULL,

    totalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_buyer
        FOREIGN KEY (buyerID) REFERENCES Member(mID),

    CONSTRAINT chk_order_total_amount
        CHECK (totalAmount > 0)
);

-- ============================================
-- 7. OrderDetail 訂單明細資料表
-- ============================================

CREATE TABLE OrderDetail (
    odID INT AUTO_INCREMENT PRIMARY KEY,

    oID INT NOT NULL,
    pID INT NOT NULL,

    quantity INT NOT NULL DEFAULT 1,
    dealPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID) REFERENCES Product(pID),

    -- 二手商品通常只有一件，因此同一商品最多只能出現在一筆有效訂單明細中
    CONSTRAINT uq_orderdetail_product UNIQUE (pID),

    -- 本系統以單件二手商品交易為主，數量固定為 1
    CONSTRAINT chk_orderdetail_quantity
        CHECK (quantity = 1),

    CONSTRAINT chk_orderdetail_deal_price
        CHECK (dealPrice > 0)
);

-- ============================================
-- 8. Invoice 發票／付款資料表
-- ============================================

CREATE TABLE Invoice (
    iID INT AUTO_INCREMENT PRIMARY KEY,

    oID INT NOT NULL,
    pmID INT NOT NULL,

    invoiceNo VARCHAR(30) UNIQUE,
    iDate DATE,
    amount DECIMAL(10,2) NOT NULL,

    paymentStatus ENUM(
        '未付款',
        '已付款',
        '付款失敗',
        '已退款'
    ) NOT NULL,

    CONSTRAINT fk_invoice_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_invoice_payment_method
        FOREIGN KEY (pmID) REFERENCES PaymentMethod(pmID),

    -- 一筆訂單最多一筆付款／發票紀錄
    CONSTRAINT uq_invoice_order UNIQUE (oID),

    CONSTRAINT chk_invoice_amount
        CHECK (amount > 0),

    -- 若付款狀態為已付款，付款日期不可為空
    CONSTRAINT chk_invoice_paid_date
        CHECK (
            paymentStatus <> '已付款'
            OR iDate IS NOT NULL
        ),

    CONSTRAINT chk_invoice_no_length
        CHECK (invoiceNo IS NULL OR CHAR_LENGTH(invoiceNo) BETWEEN 1 AND 30)
);

-- ============================================
-- 9. Shipment 出貨資料表
-- ============================================

CREATE TABLE Shipment (
    sID INT AUTO_INCREMENT PRIMARY KEY,

    odID INT NOT NULL,
    smID INT NOT NULL,

    trackingNo VARCHAR(50) UNIQUE,
    sDate DATE,

    sStatus ENUM(
        '待出貨',
        '已寄出',
        '配送中',
        '已送達',
        '已取消'
    ) NOT NULL,

    CONSTRAINT fk_shipment_orderdetail
        FOREIGN KEY (odID) REFERENCES OrderDetail(odID),

    CONSTRAINT fk_shipment_method
        FOREIGN KEY (smID) REFERENCES ShipmentMethod(smID),

    -- 一筆訂單明細最多對應一筆出貨資料
    CONSTRAINT uq_shipment_orderdetail UNIQUE (odID),

    -- 若已寄出、配送中、已送達，出貨日期不可為空
    CONSTRAINT chk_shipment_date_required
        CHECK (
            sStatus IN ('待出貨', '已取消')
            OR sDate IS NOT NULL
        ),

    -- 若已寄出、配送中、已送達，物流追蹤碼不可為空
    CONSTRAINT chk_tracking_required
        CHECK (
            sStatus IN ('待出貨', '已取消')
            OR trackingNo IS NOT NULL
        ),

    CONSTRAINT chk_tracking_no_length
        CHECK (trackingNo IS NULL OR CHAR_LENGTH(trackingNo) BETWEEN 1 AND 50)
);

-- ============================================
-- 10. Review 評價資料表
-- ============================================

CREATE TABLE Review (
    rID INT AUTO_INCREMENT PRIMARY KEY,

    oID INT NOT NULL,
    mID INT NOT NULL,

    score INT NOT NULL,
    comment VARCHAR(300),
    rDate DATE NOT NULL,

    CONSTRAINT fk_review_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_review_member
        FOREIGN KEY (mID) REFERENCES Member(mID),

    -- 一筆訂單最多一筆評價
    CONSTRAINT uq_review_order UNIQUE (oID),

    CONSTRAINT chk_review_score
        CHECK (score BETWEEN 1 AND 5),

    CONSTRAINT chk_review_comment_length
        CHECK (comment IS NULL OR CHAR_LENGTH(comment) <= 300)
);
