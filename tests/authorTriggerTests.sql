-- AUTHOR TRIGGER TESTS
UPDATE
	author
SET
	authorFirst = 'V',
    authorLast = 'V'
WHERE
	authorNum = 3;
    
DELETE FROM author
WHERE authorFirst = 'V';

INSERT INTO Author
VALUES
(3,'Vintage','Vernor');
	