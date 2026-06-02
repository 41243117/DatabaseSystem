CREATE DATABASE secondhand_platform
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE secondhand_platform;

CREATE TABLE Member (
MemberID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
Account VARCHAR(30) NOT NULL,
Password VARCHAR(100) NOT NULL,
Name VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL,
Phone VARCHAR(10) NOT NULL,
Address VARCHAR(200),
Role ENUM('Buyer','Seller') NOT NULL,
Status ENUM('Normal','Suspend') NOT NULL DEFAULT 'Normal',

UNIQUE (`Account`),
UNIQUE (`Email`),

CHECK (CHAR_LENGTH(`Account`) BETWEEN 6 AND 30),
CHECK (`Role` IN ('Buyer','Seller'))

);

CREATE TABLE Category (
CategoryID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL,

UNIQUE (`CategoryName`)

);

CREATE TABLE Product (
ProductID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
SellerID INT UNSIGNED NOT NULL,
CategoryID INT UNSIGNED NOT NULL,

`ProductName` VARCHAR(100) NOT NULL,
`Price` DECIMAL(10,2) NOT NULL,
`Description` TEXT,
`Status` ENUM('上架中','已售出','已下架') NOT NULL,
`CreateDate` DATE NOT NULL,

FOREIGN KEY (`SellerID`)
REFERENCES `Member` (`MemberID`),

FOREIGN KEY (`CategoryID`)
REFERENCES `Category` (`CategoryID`),

CHECK (`Price` > 0)

);

CREATE TABLE Orders (
OrderID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
BuyerID INT UNSIGNED NOT NULL,
OrderDate DATETIME NOT NULL,
TotalAmount DECIMAL(10,2) NOT NULL,
OrderStatus
ENUM('待付款','已付款','已出貨','已完成','已取消')
NOT NULL,

FOREIGN KEY (`BuyerID`)
REFERENCES `Member` (`MemberID`),

CHECK (`TotalAmount` > 0)

);

CREATE TABLE OrderDetail (
DetailID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
OrderID INT UNSIGNED NOT NULL,
ProductID INT UNSIGNED NOT NULL,

FOREIGN KEY (`OrderID`)
REFERENCES `Orders` (`OrderID`),

FOREIGN KEY (`ProductID`)
REFERENCES `Product` (`ProductID`)

);

CREATE TABLE PaymentMethod (
PaymentMethodID
INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

`MethodName`
VARCHAR(30) NOT NULL,

UNIQUE (`MethodName`)

);

CREATE TABLE Invoice (
InvoiceID
INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

`OrderID`
INT UNSIGNED NOT NULL,

`PaymentMethodID`
INT UNSIGNED NOT NULL,

`InvoiceNumber`
VARCHAR(20) NOT NULL,

`InvoiceDate`
DATE NOT NULL,

UNIQUE (`InvoiceNumber`),

FOREIGN KEY (`OrderID`)
REFERENCES `Orders` (`OrderID`),

FOREIGN KEY (`PaymentMethodID`)
REFERENCES `PaymentMethod` (`PaymentMethodID`)

);

CREATE TABLE ShipmentMethod (
ShipmentMethodID
INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

`MethodName`
VARCHAR(50) NOT NULL,

UNIQUE (`MethodName`)

);

CREATE TABLE Shipment (
ShipmentID
INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

`DetailID`
INT UNSIGNED NOT NULL,

`ShipmentMethodID`
INT UNSIGNED NOT NULL,

`TrackingNumber`
VARCHAR(50) NOT NULL,

`ShipDate`
DATE NOT NULL,

`ShipmentStatus`
ENUM('待出貨','已出貨','配送中','已送達')
NOT NULL,

UNIQUE (`TrackingNumber`),

FOREIGN KEY (`DetailID`)
REFERENCES `OrderDetail` (`DetailID`),

FOREIGN KEY (`ShipmentMethodID`)
REFERENCES `ShipmentMethod` (`ShipmentMethodID`)

);

CREATE TABLE Review (
ReviewID
INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

`OrderID`
INT UNSIGNED NOT NULL,

`MemberID`
INT UNSIGNED NOT NULL,

`Score`
INT NOT NULL,

`Comment`
VARCHAR(500),

`ReviewDate`
DATE NOT NULL,

FOREIGN KEY (`OrderID`)
REFERENCES `Orders` (`OrderID`),

FOREIGN KEY (`MemberID`)
REFERENCES `Member` (`MemberID`),

CHECK (`Score` BETWEEN 1 AND 5)

);
