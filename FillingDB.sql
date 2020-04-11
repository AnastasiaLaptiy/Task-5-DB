USE [FlowerSupplyDB];

INSERT INTO [FlowerSupplyDB].[dbo].[Flower]( 
	[Name]
	)
		VALUES 
		('Rose');

INSERT INTO [FlowerSupplyDB].[dbo].[Flower]( 
	[Name]
	)
		VALUES 
		('Anemone'),
		('Mimosa'),
		('Tulip');

INSERT INTO [FlowerSupplyDB].[dbo].[Status]( 
	[Name]
	)
		VALUES 
		('Scheduled'),
		('In Progress'),
		('Closed'),
		('Canceled');

INSERT INTO [FlowerSupplyDB].[dbo].[Plantation]( 
	 [Name],
	 [Address]
	 )
		VALUES 
		('Ame', 'Amegakura'),
		('Iwa', 'Iwagakure'),
		('Kiri', 'Kirigakure'),
		('Kusa', 'Kusagakure');

INSERT INTO [FlowerSupplyDB].[dbo].[Warehouse]( 
	 [Name],
	 [Address]
	 )
		VALUES 
		('Centaurea', 'South Blue'),
		('Rubeck', 'North Blue'),
		('Logue', 'East Blue'),
		('Ohara', 'West Blue');

INSERT INTO [FlowerSupplyDB].[dbo].[PlantationFlower](
	[PlantationId], 
	[FlowerId], 
	[Amount]
	)
		VALUES 
		(1,1,1),
		(2,3,1),
		(3,2,1),
		(4,4,1),
		(1,2,1);

INSERT INTO [FlowerSupplyDB].[dbo].[WarehouseFlower]( 
	[WarehouseId], 
	[FlowerId], 
	[Amount])
		VALUES 
		(1,1,2),
		(2,3,2),
		(3,2,2),
		(4,4,2),
		(1,2,2);

INSERT INTO [FlowerSupplyDB].[dbo].[Supply] (
	[WarehouseId], 
	[PlantationId], 
	[ScheduledDate], 
	[ClosedDate], 
	[StatusId]
	)
		VALUES
		(1,1,'2020-01-05','2020-02-05', 8),
		(2,3,'2020-01-05','2020-02-05', 6),
		(4,4,'2020-01-05','2020-02-05', 8);

INSERT INTO [FlowerSupplyDB].[dbo].[Supply] (
	[WarehouseId], 
	[PlantationId], 
	[ScheduledDate], 
	[StatusId]
	)
	VALUES
		(3,3,'2020-04-05', 9),
		(2,2,'2020-05-05', 7),
		(3,4,'2020-04-05', 7);

INSERT INTO [FlowerSupplyDB].[dbo].[SupplyFlower] (
	[SupplyId],
	[FlowerId],
	[Amount]
	)
		VALUES
		(1,1,10),
		(7,2,10),
		(4,3,10),
		(2,4,10),
		(9,1,10),
		(8,2,10);

