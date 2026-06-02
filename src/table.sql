CREATE DATABASE secondhand_platform
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE secondhand_platform;

-- ===========================
-- Member
-- ===========================

CREATE TABLE Member (
    mID INT PRIMARY KEY,
    mAccount VARCHAR(30) NOT NULL,
    mName VARCHAR(50) NOT NULL,
    mEmail VARCHAR(100) NOT NULL,
    mPhone VARCHAR(10) NOT NULL,
    mRole ENUM('買家','賣家') NOT NULL,
    mCreateDate DATE NOT NULL,

    UNIQUE (mAccount),
    UNIQUE (mEmail),

    CHECK (CHAR_LENGTH(mAccount) BETWEEN 6 AND 30)
);

-- ===========================
-- Category
-- ===========================

CREATE TABLE Category (
    cID INT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cDescription VARCHAR(255),

    UNIQUE(cName)
);

-- ===========================
-- Product
-- ===========================

CREATE TABLE Product (
    pID INT PRIMARY KEY,

    sellerID INT NOT NULL,
    cID INT NOT NULL,

    pName VARCHAR(100) NOT NULL,
    description TEXT,

    price DECIMAL(10,2) NOT NULL,

    pCondition ENUM(
        '幾乎全新',
        '九成新',
        '七成新',
        '使用痕跡明顯'
    ) NOT NULL,

    pStatus ENUM(
        '上架中',
        '已售出',
        '已下架'
    ) NOT NULL,

    postDate DATE NOT NULL,

    FOREIGN KEY (sellerID)
    REFERENCES Member(mID),

    FOREIGN KEY (cID)
    REFERENCES Category(cID),

    CHECK (price > 0)
);

-- ===========================
-- PaymentMethod
-- ===========================

CREATE TABLE PaymentMethod (
    pmID INT PRIMARY KEY,

    methodName ENUM(
        '信用卡',
        '銀行轉帳',
        '電子支付',
        '貨到付款'
    ) NOT NULL,

    UNIQUE(methodName)
);

-- ===========================
-- ShipmentMethod
-- ===========================

CREATE TABLE ShipmentMethod (
    smID INT PRIMARY KEY,

    methodName ENUM(
        '超商取貨',
        '宅配',
        '面交'
    ) NOT NULL,

    UNIQUE(methodName)
);

-- ===========================
-- Order
-- ===========================

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,

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

    FOREIGN KEY (buyerID)
    REFERENCES Member(mID)
);

-- ===========================
-- OrderDetail
-- ===========================

CREATE TABLE OrderDetail (
    odID INT PRIMARY KEY,

    oID INT NOT NULL,

    pID INT NOT NULL,

    quantity INT NOT NULL,

    dealPrice DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (oID)
    REFERENCES `Order`(oID),

    FOREIGN KEY (pID)
    REFERENCES Product(pID),

    UNIQUE(pID),

    CHECK (quantity > 0),
    CHECK (dealPrice > 0)
);

-- ===========================
-- Invoice
-- ===========================

CREATE TABLE Invoice (
    iID INT PRIMARY KEY,

    oID INT NOT NULL,

    pmID INT NOT NULL,

    iDate DATE,

    amount DECIMAL(10,2) NOT NULL,

    paymentStatus ENUM(
        '未付款',
        '已付款',
        '已退款'
    ) NOT NULL,

    FOREIGN KEY (oID)
    REFERENCES `Order`(oID),

    FOREIGN KEY (pmID)
    REFERENCES PaymentMethod(pmID)
);

-- ===========================
-- Shipment
-- ===========================

CREATE TABLE Shipment (
    sID INT PRIMARY KEY,

    oID INT NOT NULL,

    smID INT NOT NULL,

    sDate DATE,

    sStatus ENUM(
        '待出貨',
        '配送中',
        '已送達',
        '已取消'
    ) NOT NULL,

    FOREIGN KEY (oID)
    REFERENCES `Order`(oID),

    FOREIGN KEY (smID)
    REFERENCES ShipmentMethod(smID)
);

-- ===========================
-- Review
-- ===========================

CREATE TABLE Review (
    rID INT PRIMARY KEY,

    oID INT NOT NULL,

    mID INT NOT NULL,

    score INT NOT NULL,

    comment VARCHAR(500),

    rDate DATE NOT NULL,

    FOREIGN KEY (oID)
    REFERENCES `Order`(oID),

    FOREIGN KEY (mID)
    REFERENCES Member(mID),

    CHECK (score BETWEEN 1 AND 5),

    UNIQUE(oID)
);
