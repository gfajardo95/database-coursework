INSERT INTO copy
VALUES
('0000',1,1,'Excellent',7.19);

UPDATE
	copy
SET
	copy.bookCode = '',
    copy.branchNum = 10,
    copy.copyNum = 2,
    copy.quality = 'Good',
    copy.price = 0.00
WHERE
	copy.bookCode = '0000';

DELETE FROM copy
WHERE copy.bookCode = '';