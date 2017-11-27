UPDATE
	book
SET
	title = 'VeniceE',
    publisherCode = '',
    type = '',
    paperback = ''
WHERE
	bookCode = '0378';
    
DELETE FROM book
WHERE bookCode = '0378';

INSERT INTO Book
VALUES
('0378','Venice','SS','ART','N');