USE SecHand;

INSERT INTO Member
(mAccount, mName, mEmail, mPhone, mRole, mCreateDate)
VALUES
('buyer_test01', '測試買家', 'buyer.test01@example.com', '0911222333', '買家', '2026-06-10');


INSERT INTO Product
(mID, cID, pCondition, pName, pStatus, description, postDate, price)
VALUES
(
    (SELECT mID FROM Member WHERE mAccount = 'seller_lin8'),
    (SELECT cID FROM Category WHERE cName = '書籍教材'),
    '九成新',
    '二手資料庫課本',
    '上架中',
    '書況良好，內頁有少量筆記。',
    '2026-06-10',
    350.00
);

UPDATE Member
SET mPhone = '0988777666'
WHERE mAccount = 'buyer_test01';

UPDATE Product
SET price = 300.00
WHERE pName = '二手資料庫課本';

UPDATE Product
SET pStatus = '已下架'
WHERE pName = '二手資料庫課本';

DELETE FROM Product
WHERE pName = '二手資料庫課本';

DELETE FROM Member
WHERE mAccount = 'buyer_test01';
