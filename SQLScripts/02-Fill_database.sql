USE farmas;

INSERT INTO [dbo].[Roles] (Id, Name) 
VALUES (NEWID(),'Doctor'),
	(NEWID(),'Patient');



INSERT INTO [dbo].[Category] (Name) 
VALUES('Antibiotics'),
	('Nutrition'),
	('Dermatological'),
	('Pain and inflammation'), 
	('Nervous System'), 
	('Allergies');

INSERT INTO [dbo].[PaymentType] (Name) 
VALUES ('Debit Card' ),
		('Credit Card');


