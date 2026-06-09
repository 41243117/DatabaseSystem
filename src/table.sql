-- ============================================
-- 1. Member
-- ER 屬性：
-- mID, mAccount, mName, mEmail, mPhone, mRole, mCreateDate
-- ============================================

CREATE TABLE Member (
    mID INT AUTO_INCREMENT PRIMARY KEY,

    mAccount VARCHAR(30) NOT NULL,
    mName VARCHAR(50) NOT NULL,
    mEmail VARCHAR(100) NOT NULL,
    mPhone VARCHAR(10) NOT NULL,

    mRole ENUM(
        '買家',
        '賣家',
        '買賣家'
    ) NOT NULL,

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
        CHECK (mPhone REGEXP '^09[0-9]{8}$')
);

-- ============================================
-- 2. Category
-- ER 屬性：
-- cID, cName, cDescription
-- ============================================

CREATE TABLE Category (
    cID INT AUTO_INCREMENT PRIMARY KEY,

    cName VARCHAR(50) NOT NULL,
    cDescription VARCHAR(200),

    CONSTRAINT uq_category_name UNIQUE (cName),

    CONSTRAINT chk_category_name
        CHECK (CHAR_LENGTH(TRIM(cName)) BETWEEN 1 AND 50),

    CONSTRAINT chk_category_description
        CHECK (
            cDescription IS NULL
            OR CHAR_LENGTH(cDescription) <= 200
        )
);

-- ============================================
-- 3. PaymentMethod
-- ER 屬性：
-- pmID, methodName
-- ============================================

CREATE TABLE PaymentMethod (
    pmID INT AUTO_INCREMENT PRIMARY KEY,

    methodName ENUM(
        '信用卡',
        '銀行轉帳',
        '電子支付',
        '貨到付款'
    ) NOT NULL,

    CONSTRAINT uq_paymentmethod_name UNIQUE (methodName)
);

-- ============================================
-- 4. ShipmentMethod
-- ER 屬性：
-- smID, methodName
-- ============================================

CREATE TABLE ShipmentMethod (
    smID INT AUTO_INCREMENT PRIMARY KEY,

    methodName ENUM(
        '超商取貨',
        '宅配',
        '面交'
    ) NOT NULL,

    CONSTRAINT uq_shipmentmethod_name UNIQUE (methodName)
);

-- ============================================
-- 5. Product
-- ER 屬性：
-- pID, pCondition, ptName, pStatus, description, postDate, price
--
-- ER 關係轉外鍵：
-- Member -- Lists -- Product      => mID
-- Category -- Include -- Product  => cID
-- ============================================

CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,

    mID INT NOT NULL,
    cID INT NOT NULL,

    pCondition ENUM(
        '全新未使用',
        '幾乎全新',
        '九成新',
        '七成新',
        '使用痕跡明顯',
        '故障品'
    ) NOT NULL,

    ptName VARCHAR(100) NOT NULL,

    pStatus ENUM(
        '上架中',
        '已售出',
        '已下架'
    ) NOT NULL,

    description VARCHAR(500),
    postDate DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_product_member
        FOREIGN KEY (mID) REFERENCES Member(mID),

    CONSTRAINT fk_product_category
        FOREIGN KEY (cID) REFERENCES Category(cID),

    CONSTRAINT chk_product_name
        CHECK (CHAR_LENGTH(TRIM(ptName)) BETWEEN 1 AND 100),

    CONSTRAINT chk_product_description
        CHECK (
            description IS NULL
            OR CHAR_LENGTH(description) <= 500
        ),

    CONSTRAINT chk_product_price
        CHECK (price > 0)
);

-- ============================================
-- 6. Order
-- ER 屬性：
-- oID, oStatus, oDate, totalAmount
--
-- ER 關係轉外鍵：
-- Member -- Place -- Order => mID
-- ============================================

CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,

    mID INT NOT NULL,

    oStatus ENUM(
        '待付款',
        '已付款',
        '已出貨',
        '已完成',
        '已取消'
    ) NOT NULL,

    oDate DATE NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_member
        FOREIGN KEY (mID) REFERENCES Member(mID),

    CONSTRAINT chk_order_total_amount
        CHECK (totalAmount > 0)
);

-- ============================================
-- 7. Shipment
-- ER 屬性：
-- sID, sStatus, sDate
--
-- ER 關係轉外鍵：
-- Shipment -- Use -- ShipmentMethod => smID
-- ============================================

CREATE TABLE Shipment (
    sID INT AUTO_INCREMENT PRIMARY KEY,

    smID INT NOT NULL,

    sStatus ENUM(
        '待出貨',
        '已寄出',
        '配送中',
        '已送達',
        '已取消'
    ) NOT NULL,

    sDate DATE,

    CONSTRAINT fk_shipment_method
        FOREIGN KEY (smID) REFERENCES ShipmentMethod(smID),

    CONSTRAINT chk_shipment_date_required
        CHECK (
            sStatus IN ('待出貨', '已取消')
            OR sDate IS NOT NULL
        )
);

-- ============================================
-- 8. OrderDetail
-- ER 屬性：
-- odID, quantity, dealPrice
--
-- ER 關係轉外鍵：
-- Order -- Has -- OrderDetail        => oID
-- Product -- PartOf -- OrderDetail   => pID
-- OrderDetail -- PackageIn -- Shipment => sID
-- ============================================

CREATE TABLE OrderDetail (
    odID INT AUTO_INCREMENT PRIMARY KEY,

    oID INT NOT NULL,
    pID INT NOT NULL,
    sID INT NOT NULL,

    quantity INT NOT NULL DEFAULT 1,
    dealPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID) REFERENCES Product(pID),

    CONSTRAINT fk_orderdetail_shipment
        FOREIGN KEY (sID) REFERENCES Shipment(sID),

    -- 二手商品具有唯一性，同一商品最多只能出現在一筆訂單明細中
    CONSTRAINT uq_orderdetail_product UNIQUE (pID),

    -- 本系統以單件二手商品交易為主
    CONSTRAINT chk_orderdetail_quantity
        CHECK (quantity = 1),

    CONSTRAINT chk_orderdetail_deal_price
        CHECK (dealPrice > 0)
);

-- ============================================
-- 9. Invoice
-- ER 屬性：
-- iID, iDate, amount, paymentStatus
--
-- ER 關係轉外鍵：
-- Order -- Raise -- Invoice          => oID
-- Invoice -- Use -- PaymentMethod    => pmID
-- ============================================

CREATE TABLE Invoice (
    iID INT AUTO_INCREMENT PRIMARY KEY,

    oID INT NOT NULL,
    pmID INT NOT NULL,

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

    CONSTRAINT fk_invoice_paymentmethod
        FOREIGN KEY (pmID) REFERENCES PaymentMethod(pmID),

    -- 一筆訂單只會產生一筆付款／發票資料
    CONSTRAINT uq_invoice_order UNIQUE (oID),

    CONSTRAINT chk_invoice_amount
        CHECK (amount > 0),

    -- 已付款時，付款日期不可為空
    CONSTRAINT chk_invoice_paid_date
        CHECK (
            paymentStatus <> '已付款'
            OR iDate IS NOT NULL
        )
);

-- ============================================
-- 10. Review
-- ER 屬性：
-- rID, score, comment, rDate
--
-- ER 關係轉外鍵：
-- Member -- Write -- Review      => mID
-- Order -- Recives -- Review     => oID
-- ============================================

CREATE TABLE Review (
    rID INT AUTO_INCREMENT PRIMARY KEY,

    mID INT NOT NULL,
    oID INT NOT NULL,

    score INT NOT NULL,
    comment VARCHAR(300),
    rDate DATE NOT NULL,

    CONSTRAINT fk_review_member
        FOREIGN KEY (mID) REFERENCES Member(mID),

    CONSTRAINT fk_review_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    -- 依照圖上的 Order 對 Review 為 0..1，一筆訂單最多一筆評價
    CONSTRAINT uq_review_order UNIQUE (oID),

    CONSTRAINT chk_review_score
        CHECK (score BETWEEN 1 AND 5),

    CONSTRAINT chk_review_comment
        CHECK (
            comment IS NULL
            OR CHAR_LENGTH(comment) <= 300
        )
);
