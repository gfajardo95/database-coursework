-- Gabriel Fajardo
-- COP 4710
-- I certify that this work is my own and no one else's.

-- PROGRAM SPECS
-- This script calculates some stats about all the publishers stored in the 
-- database and stores it a table named "pubstats". There are two procedures, 
-- relating to each other as one being the outer procedure and the other being 
-- the inner procedure. The outer procedure opens a cursor and passes to the 
-- inner procedure the publisher code. It is the inner procedure's task to 
-- calculate the different stats, and then return it back to the outer 
-- procedure. The outer procedure then stores the information into the pubstats
-- table and continues iterating through the publisher codes until there are 
-- none left.

-- **************************BEGIN AUTHOR TRIGGERS*****************************

DROP PROCEDURE IF EXISTS spGetPubStatsGabrielFajardo;
DROP PROCEDURE IF EXISTS spGetAllPubStatsGabrielFajardo;

delimiter $$

CREATE PROCEDURE spGetPubStatsGabrielFajardo(
 IN pub_code CHAR(2),
 OUT pub_name CHAR(25),
 OUT tot_pub_authr DECIMAL(2,0),
 OUT tot_pub_bk DECIMAL(2,0),
 OUT max_title CHAR(40),
 OUT max_on_hand DECIMAL(2,0),
 OUT pub_on_hand DECIMAL(2,0))
BEGIN

	SELECT
		p.publisherName,
		count(DISTINCT a.authorNum) total_published_authors,
		count(DISTINCT b.bookCode) total_published_books,
		SUM(i.OnHand) books_on_hand 
			INTO pub_name, tot_pub_authr, tot_pub_bk, pub_on_hand
	FROM
		publisher p inner join
		book b on b.publisherCode = p.publisherCode inner join
		wrote w on w.bookCode = b.bookCode inner join
		author a on a.authorNum = w.authorNum inner join
		inventory i on i.BookCode = b.bookCode
	WHERE
		p.publisherCode = pub_code;

	SELECT
		MAX(m.sum_onhand),
        m.title INTO max_on_hand, max_title
	FROM
		(SELECT
			b.title title,
			b.publisherCode pub,
			SUM(i.OnHand) sum_onhand
		FROM
			inventory i INNER JOIN
			book b on b.bookCode = i.BookCode
		GROUP BY
			i.BookCode) m
	WHERE
		m.pub = pub_code
	LIMIT 1;

END$$

CREATE PROCEDURE spGetAllPubStatsGabrielFajardo ()
BEGIN
    
	DECLARE done INTEGER DEFAULT 0;
	
    DECLARE pub_code CHAR(2);
	DECLARE pub_name CHAR(25);
    DECLARE tot_pauth DECIMAL(2,0);
    DECLARE tot_pbk DECIMAL(2,0);
    DECLARE mx_bk_oh DECIMAL(2,0);
    DECLARE mx_bk_t CHAR(40);
    DECLARE bk_pub_oh DECIMAL(2,0);
    
    DECLARE done_holder INT;
    
    DECLARE pubcurs CURSOR FOR
		SELECT
			p.publisherCode
		FROM
			publisher p;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
	DROP TABLE IF EXISTS pubStats;
	CREATE TABLE pubStats
	(publisherName CHAR(25) PRIMARY KEY,
	total_published_authors DECIMAL(2,0),
	total_published_books DECIMAL(2,0),
	max_book_title CHAR(40),
	max_book_on_hand DECIMAL(2,0),
	books_by_pub_on_hand DECIMAL(2,0)
    );

    OPEN pubcurs;
    REPEAT
		FETCH pubcurs INTO pub_code;
        
        IF NOT done THEN
        -- IF pub_code IS NOT NULL THEN
			SET done_holder = done;
			CALL spGetPubStatsGabrielFajardo(pub_code,
		    pub_name, tot_pauth, tot_pbk, mx_bk_t, mx_bk_oh, bk_pub_oh);
            
            IF pub_name IS NOT NULL THEN
				INSERT INTO pubStats
				VALUES (pub_name, tot_pauth, tot_pbk, mx_bk_t, mx_bk_oh, bk_pub_oh);
			END IF;
            
            SET done = done_holder;
		END IF;
        
	UNTIL done
    END REPEAT;
    
    CLOSE pubcurs;
END$$
delimiter ;


CALL spGetAllPubStatsGabrielFajardo();
