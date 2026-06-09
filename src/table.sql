-- ============================================
-- 1. Member
-- 屬性：mID, mAccount, mName, mEmail, mPhone, mRole, mCreateDate
-- ============================================

CREATE TABLE Member (
    mID INT AUTO_INCREMENT PRIMARY KEY,
    mAccount VARCHAR(30) NOT NULL,
    mName VARCHAR(50) NOT NULL,
    mEmail VARCHAR(100) NOT NULL,
    mPhone VARCHAR(10) NOT NULL,
    mRole VARCHAR(10) NOT NULL,
    mCreateDate DATE NOT NULL,

    CONSTRAINT uq_member_account UNIQUE (mAccount),
    CONSTRAINT uq_member_email UNIQUE (mEmail),

    CONSTRAINT chk_member_account_length
        CHECK (CHAR_LENGTH(mAccount) BETWEEN 1 AND 30),

    CONSTRAINT chk_member_name
        CHECK (CHAR_LENGTH(TRIM(mName)) BETWEEN 1 AND 50),

    CONSTRAINT chk_member_phone
        CHECK (CHAR_LENGTH(mPhone) BETWEEN 8 AND 10)
);

-- ============================================
-- 2. Category
-- 屬性：cID, cName, cDescription
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
-- 3. PaymentMethod
-- 屬性：pmID, methodName
-- ============================================

CREATE TABLE PaymentMethod (
    pmID INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(30) NOT NULL,

    CONSTRAINT uq_paymentmethod_name UNIQUE (methodName),

    CONSTRAINT chk_paymentmethod_name
        CHECK (CHAR_LENGTH(TRIM(methodName)) BETWEEN 1 AND 30)
);

-- ============================================
-- 4. ShipmentMethod
-- 屬性：smID, methodName
-- ============================================

CREATE TABLE ShipmentMethod (
    smID INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(30) NOT NULL,

    CONSTRAINT uq_shipmentmethod_name UNIQUE (methodName),

    CONSTRAINT chk_shipmentmethod_name
        CHECK (CHAR_LENGTH(TRIM(methodName)) BETWEEN 1 AND 30)
);

-- ============================================
-- 5. Product
-- 屬性：pID, pCondition, ptName, pStatus, description, postDate, price
-- 關係：
-- Member -- Lists -- Product   => mID 外鍵
-- Category -- Include -- Product => cID 外鍵
-- ============================================

CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    mID INT NOT NULL,
    cID INT NOT NULL,

    pCondition VARCHAR(30) NOT NULL,
    ptName VARCHAR(100) NOT NULL,
    pStatus VARCHAR(20) NOT NULL,
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
        CHECK (description IS NULL OR CHAR_LENGTH(description) <= 500),

    CONSTRAINT chk_product_price
        CHECK (price > 0)
);

-- ============================================
-- 6. Order
-- 屬性：oID, oStatus, oDate, totalAmount
-- 關係：
-- Member -- Place -- Order => mID 外鍵
-- ============================================

CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    mID INT NOT NULL,

    oStatus VARCHAR(20) NOT NULL,
    oDate DATE NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_member
        FOREIGN KEY (mID) REFERENCES Member(mID),

    CONSTRAINT chk_order_totalamount
        CHECK (totalAmount > 0)
);

-- ============================================
-- 7. Shipment
-- 屬性：sID, sStatus, sDate
-- 關係：
-- Shipment -- Use -- ShipmentMethod => smID 外鍵
-- ============================================

CREATE TABLE Shipment (
    sID INT AUTO_INCREMENT PRIMARY KEY,
    smID INT NOT NULL,

    sStatus VARCHAR(20) NOT NULL,
    sDate DATE NOT NULL,

    CONSTRAINT fk_shipment_method
        FOREIGN KEY (smID) REFERENCES ShipmentMethod(smID)
);

-- ============================================
-- 8. OrderDetail
-- 屬性：odID, quantity, dealPrice
-- 關係：
-- Order -- Has -- OrderDetail => oID 外鍵
-- Product -- PartOf -- OrderDetail => pID 外鍵
-- OrderDetail -- PackageIn -- Shipment => sID 外鍵
-- ============================================

CREATE TABLE OrderDetail (
    odID INT AUTO_INCREMENT PRIMARY KEY,
    oID INT NOT NULL,
    pID INT NOT NULL,
    sID INT NOT NULL,

    quantity INT NOT NULL,
    dealPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID) REFERENCES Product(pID),

    CONSTRAINT fk_orderdetail_shipment
        FOREIGN KEY (sID) REFERENCES Shipment(sID),

    CONSTRAINT chk_orderdetail_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_orderdetail_dealprice
        CHECK (dealPrice > 0)
);

-- ============================================
-- 9. Invoice
-- 屬性：iID, iDate, amount, paymentStatus
-- 關係：
-- Order -- Raise -- Invoice => oID 外鍵
-- Invoice -- Use -- PaymentMethod => pmID 外鍵
-- ============================================

CREATE TABLE Invoice (
    iID INT AUTO_INCREMENT PRIMARY KEY,
    oID INT NOT NULL,
    pmID INT NOT NULL,

    iDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paymentStatus VARCHAR(20) NOT NULL,

    CONSTRAINT fk_invoice_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),

    CONSTRAINT fk_invoice_paymentmethod
        FOREIGN KEY (pmID) REFERENCES PaymentMethod(pmID),

    CONSTRAINT uq_invoice_order UNIQUE (oID),

    CONSTRAINT chk_invoice_amount
        CHECK (amount > 0)
);

-- ============================================
-- 10. Review
-- 屬性：rID, score, comment, rDate
-- 關係：
-- Member -- Write -- Review => mID 外鍵
-- Order -- Recives -- Review => oID 外鍵
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

    CONSTRAINT uq_review_order UNIQUE (oID),

    CONSTRAINT chk_review_score
        CHECK (score BETWEEN 1 AND 5),

    CONSTRAINT chk_review_comment
        CHECK (comment IS NULL OR CHAR_LENGTH(comment) <= 300)
);
