-- Gabriel Fajardo
-- COP 4710
-- This work is my own, and I did not copy any of it from any outside source.

-- PROGRAM SPECS
-- This script enables users to see what has changed in the database, who
-- made the change, and by whom. This is done by creating a HistoricalAudit 
-- table to store this information. The accompanying triggers for all of the 
-- database's tables, excluding this one, are used for this same goal. They fire 
-- whenever an update, insert, or delete is performed on any of the tables, and 
-- calls the "on_table_change" stored procedure to log the change into the 
-- HistoricalAudit table.


CREATE TABLE HistoricalAudit 
(edited_table CHAR(40),
edited_column CHAR(40),
query_action CHAR(6), -- insert, update, delete
old_value CHAR(50),
new_value CHAR(50),
key_val_1 CHAR(5),
key_val_2 VARCHAR(5),
key_val_3 VARCHAR(5),
user_id VARCHAR(100),
time_stamp TIMESTAMP
);

delimiter $$
-- **************************BEGIN AUTHOR TRIGGERS*****************************
CREATE TRIGGER 
	author_update
AFTER UPDATE
	ON author FOR EACH ROW
BEGIN
	DECLARE auth_num DECIMAL(2,0);
    SET auth_num = OLD.authorNum;
    
	IF OLD.authorFirst <> NEW.authorFirst THEN
        CALL on_table_change ("author", "authorFirst", "UPDATE", 
			OLD.authorFirst, NEW.authorFirst, auth_num, "", "");
    END IF;
    IF OLD.authorLast <> NEW.authorLast THEN
        CALL on_table_change ("author", "authorLast", "UPDATE", 
			OLD.authorLast, NEW.authorLast, auth_num, "", "");
    END IF;
END$$

CREATE TRIGGER
	author_delete
AFTER DELETE
	ON author FOR EACH ROW
BEGIN
  
	CALL on_table_change ("author", "_", "DELETE", "_", "", 
		OLD.authorNum, "", "");
    
END$$

CREATE TRIGGER
	author_insert
AFTER INSERT
	ON author FOR EACH ROW
BEGIN
	
    CALL on_table_change ("author", "_", "INSERT", "", "_", 
		NEW.authorNum, "", "");
    
END$$

-- ****************************END AUTHOR TRIGGERS*****************************
-- ****************************************************************************
-- ****************************BEGIN BOOK TRIGGERS*****************************
CREATE TRIGGER
	book_update
AFTER UPDATE
	ON book FOR EACH ROW
BEGIN
	DECLARE bcode CHAR(4);
    SET bcode = OLD.bookCode;
    
    IF OLD.title <> NEW.title THEN
		CALL on_table_change ("book", "title", "UPDATE", OLD.title, NEW.title, 
			bcode, "", "");
    END IF;
    IF OLD.publisherCode <> NEW.publisherCode THEN
		CALL on_table_change ("book", "publisherCode", "UPDATE", 
			OLD.publisherCode, NEW.publisherCode, bcode, "", "");
	END IF;
    IF OLD.type <> NEW.type THEN
		CALL on_table_change ("book", "type", "UPDATE", OLD.type, NEW.type, 
			bcode, "", "");
	END IF;
    IF OLD.paperback <> NEW.paperback THEN
		CALL on_table_change ("book", "paperback", "UPDATE", OLD.paperback, 
			NEW.paperback, bcode, "", "");
    END IF;
	
END$$

CREATE TRIGGER
	book_delete
AFTER DELETE
	ON book FOR EACH ROW
BEGIN
	
    CALL on_table_change ("book", "_", "DELETE", "_", "", 
		OLD.bookCode, "", "");
    
END$$

CREATE TRIGGER
	book_insert
AFTER INSERT
	ON book FOR EACH ROW
BEGIN
	CALL on_table_change ("book", "_", "INSERT", "", "_", 
			NEW.bookCode, "", "");
END$$
-- ******************************END BOOK TRIGGERS*****************************
-- ****************************************************************************
-- **************************BEGIN BRANCH TRIGGERS*****************************
CREATE TRIGGER
	branch_update
AFTER UPDATE
	ON branch FOR EACH ROW
BEGIN
	DECLARE bn DECIMAL(2,0);
    SET bn = OLD.branchNum;
    
    IF OLD.branchName <> NEW.branchName THEN
		CALL on_table_change ("branch", "branchName", "UPDATE", OLD.branchName, 
			NEW.branchName, bn, "", "");
	END IF;
    IF OLD.branchLocation <> NEW.branchLocation THEN
		CALL on_table_change ("branch", "branchLocation", "UPDATE", 
			OLD.branchLocation, NEW.branchLocation, bn, "", "");
	END IF;
    
END$$

CREATE TRIGGER
	branch_delete
AFTER DELETE
	ON branch FOR EACH ROW
BEGIN
	CALL on_table_change ("branch", "_", "DELETE", "_", "", 
			OLD.branchNum, "", "");
END$$

CREATE TRIGGER
	branch_insert
AFTER INSERT
	ON branch FOR EACH ROW
BEGIN
	CALL on_table_change ("branch", "_", "INSERT", "", "_", 
			NEW.branchNum, "", "");
END$$
-- ****************************END BRANCH TRIGGERS*****************************
-- ****************************************************************************
-- ***************************BEGIN COPY TRIGGERS******************************
CREATE TRIGGER
	copy_update
AFTER UPDATE
	ON copy FOR EACH ROW
BEGIN
	DECLARE bcode CHAR(4);
    DECLARE bnum DECIMAL(2,0);
    DECLARE cnum DECIMAL(2,0);
    
    SET bcode = OLD.bookCode;
    SET bnum = OLD.branchNum;
    SET cnum = OLD.copyNum;
    
    IF OLD.bookCode <> NEW.bookCode THEN
		CALL on_table_change ("copy", "bookCode", "UPDATE", OLD.bookCode, 
			NEW.bookCode, bcode, bnum, cnum);
    END IF;
    IF OLD.branchNum <> NEW.branchNum THEN
		CALL on_table_change ("copy", "branchNum", "UPDATE", OLD.branchNum, 
			NEW.branchNum, bcode, bnum, cnum);
    END IF;
    IF OLD.copyNum <> NEW.copyNum THEN
		CALL on_table_change ("copy", "copyNum", "UPDATE", OLD.copyNum, 
			NEW.copyNum, bcode, bnum, cnum);
    END IF;
    IF OLD.quality <> NEW.quality THEN
		CALL on_table_change ("copy", "quality", "UPDATE", OLD.quality, 
			NEW.quality, bcode, bnum, cnum);
    END IF;
    IF OLD.price <> NEW.price THEN
		CALL on_table_change ("copy", "price", "UPDATE", OLD.price, NEW.price, 
			bcode, bnum, cnum);
	END IF;
END$$

CREATE TRIGGER
	copy_delete
AFTER DELETE
	ON copy FOR EACH ROW
BEGIN
	CALL on_table_change ("copy", "_", "DELETE", "_", "", 
		OLD.bookCode, OLD.branchNum, OLD.copyNum);
END$$

CREATE TRIGGER
	copy_insert
AFTER INSERT
	ON copy FOR EACH ROW
BEGIN
	CALL on_table_change ("copy", "_", "INSERT", "", "_", 
		NEW.bookCode, NEW.branchNum, NEW.copyNum);
END$$
-- *****************************END COPY TRIGGERS******************************
-- ****************************************************************************
-- **************************BEGIN INVENTORY TRIGGERS**************************
CREATE TRIGGER
	inventory_update
AFTER UPDATE
	ON inventory FOR EACH ROW
BEGIN
	DECLARE bcode CHAR(4);
    DECLARE bnum DECIMAL(2,0);
    SET bcode = OLD.BookCode;
    SET bnum = OLD.BranchNum;
    
    IF OLD.BookCode <> NEW.BookCode THEN
		CALL on_table_change ("inventory", "BookCode", "UPDATE", OLD.BookCode, 
			NEW.BookCode, bcode, bnum, "");
	END IF;
    IF OLD.BranchNum <> NEW.BranchNum THEN
		CALL on_table_change ("inventory", "BranchNum", "UPDATE", 
			OLD.BranchNum, NEW.BranchNum, bcode, bnum, "");
	END IF;
    IF OLD.OnHand <> NEW.OnHand THEN
		CALL on_table_change ("inventory", "OnHand", "UPDATE", OLD.OnHand, 
			NEW.OnHand, bcode, bnum, "");
	END IF;
END$$

CREATE TRIGGER
	inventory_delete
AFTER DELETE
	ON inventory FOR EACH ROW
BEGIN
	CALL on_table_change ("inventory", "_", "DELETE", "_", "", 
		OLD.BookCode, OLD.BranchNum, "");
END$$

CREATE TRIGGER
	inventory_insert
AFTER INSERT
	ON inventory FOR EACH ROW
BEGIN
	CALL on_table_change ("inventory", "_", "INSERT", "", "_", 
		NEW.BookCode, NEW.BranchNum, "");
END$$
-- **************************END INVENTORY TRIGGERS****************************
-- ****************************************************************************
-- *************************BEGIN PUBLISHER TRIGGERS***************************
CREATE TRIGGER
	publisher_update
AFTER UPDATE
	ON publisher FOR EACH ROW
BEGIN
	DECLARE pubCode CHAR(3);
    SET pubCode = OLD.publisherCode;
    
    IF OLD.publisherCode <> NEW.publisherCode THEN
		CALL on_table_change ("publisher", "publisherCode", "UPDATE", 
			OLD.publisherCode, NEW.publisherCode, pubCode, "", "");
    END IF;
    IF OLD.publisherName <> NEW.publisherName THEN
		CALL on_table_change ("publisher", "publisherName", "UPDATE", 
			OLD.publisherName, NEW.publisherName, pubCode, "", "");
    END IF;
    IF OLD.city <> NEW.city THEN
		CALL on_table_change ("publisher", "city", "UPDATE", OLD.city, 
			NEW.city, pubCode, "", "");
    END IF;
END$$

CREATE TRIGGER
	publisher_delete
AFTER DELETE
	ON publisher FOR EACH ROW
BEGIN
	CALL on_table_change ("publisher", "_", "DELETE", "_", "", 
		OLD.PublisherCode, "", "");
END$$

CREATE TRIGGER
	publisher_insert
AFTER INSERT
	ON publisher FOR EACH ROW
BEGIN
	CALL on_table_change ("publisher", "_", "INSERT", "", "_", 
		NEW.publisherCode, "", "");
END$$
-- **************************END PUBLISHER TRIGGERS****************************
-- ****************************************************************************
-- ****************************BEGIN WROTE TRIGGERS****************************
CREATE TRIGGER
	wrote_update
AFTER UPDATE
	ON wrote FOR EACH ROW
BEGIN
	DECLARE bcode CHAR(4);
    DECLARE anum DECIMAL(2,0);
    
    SET bcode = OLD.bookCode;
    SET anum = OLD.authorNum;
    
    IF OLD.bookCode <> NEW.bookCode THEN
		CALL on_table_change ("wrote", "bookCode", "UPDATE", OLD.bookCode, 
			NEW.bookCode, bcode, anum, "");
    END IF;
    IF OLD.authorNum <> NEW.authorNum THEN
		CALL on_table_change ("wrote", "authorNum", "UPDATE", OLD.authorNum, 
			NEW.authorNum, bcode, anum, "");
    END IF;
    IF OLD.sequence <> NEW.sequence THEN
		CALL on_table_change ("wrote", "sequence", "UPDATE", OLD.sequence, 
			NEW.sequence, bcode, anum, "");
    END IF;
END$$

CREATE TRIGGER
	wrote_delete
AFTER DELETE
	ON wrote FOR EACH ROW
BEGIN
	CALL on_table_change ("wrote", "_", "DELETE", "_", "", 
		OLD.bookCode, OLD.authorNum, "");
END$$

CREATE TRIGGER
	wrote_insert
AFTER INSERT
	ON wrote FOR EACH ROW
BEGIN
	CALL on_table_change ("wrote", "_", "INSERT", "", "_", 
		NEW.bookCode, NEW.authorNum, "");
END$$
-- *****************************END WROTE TRIGGERS*****************************


CREATE PROCEDURE on_table_change (
 IN tname CHAR(40),
 IN cname CHAR(40),
 IN q_action CHAR(6),
 IN old_val CHAR(50),
 IN new_val CHAR(50),
 IN kv1 CHAR(4),
 IN kv2 VARCHAR(4),
 IN kv3 VARCHAR(4)
)
BEGIN
	INSERT INTO HistoricalAudit
    VALUE (tname, cname, q_action, old_val, new_val, kv1, kv2, kv3, USER(), CURRENT_TIMESTAMP);
END$$
 
delimiter ;