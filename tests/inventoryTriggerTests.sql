INSERT INTO inventory
VALUES
('0000',1,5);

UPDATE 
	inventory
SET
	inventory.BookCode = '',
    inventory.BranchNum = 2,
    inventory.onHand = 6
WHERE
	inventory.BookCode = '0000';
    
DELETE FROM inventory
WHERE inventory.BookCode = '';