UPDATE
	branch
SET
	branch.branchName = '',
    branch.branchLocation = ''
WHERE
	branch.branchNum = 1;

UPDATE
	branch
SET
	branch.branchName = 'Henry Downtown',
    branch.branchLocation = '16 Riverview'
WHERE
	branch.branchNum = 1;

INSERT INTO branch
VALUES
(5,'Variant Edition','5th Ave');

DELETE FROM branch
WHERE branch.branchNum = 5;