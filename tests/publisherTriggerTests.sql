INSERT INTO Publisher
VALUES
('ZZ','ZEE ZEE', 'Zauk Zity ZZ');

UPDATE
	publisher
SET
	publisher.publisherCode = '',
    publisher.publisherName = 'My name is!..',
    publisher.city = 'Mad City'
WHERE
	publisher.publisherCode = 'ZZ';

DELETE FROM publisher
WHERE publisher.publisherCode = '';