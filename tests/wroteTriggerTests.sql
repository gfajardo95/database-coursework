INSERT INTO wrote
VALUES
('0000',3,1);

UPDATE
	wrote
SET
	wrote.bookCode = '1111',
    wrote.authorNum = 2,
    wrote.sequence = 2
WHERE
	wrote.bookCode = '0000';

DELETE FROM wrote
WHERE wrote.bookCode = '1111';