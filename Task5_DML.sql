USE [FlowerSupplyDB];

/*SELECT*/

/*plantation list*/

SELECT 
	[p].[Name] 
		FROM 
		[FlowerSupplyDB].[dbo].[Plantation] [p];

/*- данные по плантации: список цветов и их количество. 
   Столбцы в результате: Id плантации, имя, адрес, ИМЯ ВИДА ЦВЕТОВ, количество  */
/*v1*/
SELECT 
	[p].*,
	[pf].[Amount], 
	[f].[Name]
		FROM 
		[FlowerSupplyDB].[dbo].[PlantationFlower] [pf],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[Flower] [f]
			WHERE
			[pf].[PlantationId] = [p].[Id]
			and [pf].[FlowerId] = [f].[Id];

/*v2*/
SELECT 
	[p].*, 
	SUM([pf].[Amount]) as "Flowers per plantation"
		FROM 
		[FlowerSupplyDB].[dbo].[PlantationFlower] [pf],
		[FlowerSupplyDB].[dbo].[Plantation] [p]
			WHERE
			[pf].[PlantationId] = [p].[Id]
				GROUP BY 
				[p].[Id], 
				[p].[Address], 
				[p].[Name];

/*данные по видам цветов: для каждого вида количество плантаций, 
  на которых есть цветы данного вида. 
  Столбцы в результате: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations number");*/

  SELECT 
	[f].[Id], 
	[f].[Name], 
	COUNT([p].[Id]) as "Plantations number"
		FROM 
		[FlowerSupplyDB].[dbo].[Flower] [f],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[PlantationFlower] [pf]
			WHERE
			[pf].[PlantationId] = [p].[Id]
			and [pf].[FlowerId] = [f].[Id]
				GROUP BY
				[f].[Id], [f].[Name];
				

/*данные по видам цветов: для каждого вида количество плантаций, 
 на которых есть цветы данного вида в количестве больше 1000.
 Столбцы, как и в предыдущем пункте: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations number");*/

  SELECT 
	[f].[Id], 
	[f].[Name], 
	COUNT([pf].[PlantationId]) as "Plantations number"
		FROM 
		[FlowerSupplyDB].[dbo].[Flower] [f],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[PlantationFlower] [pf]
			WHERE
			[pf].[PlantationId] = [p].[Id]
			and [pf].[FlowerId] = [f].[Id]
			and [pf].[Amount] > 1000
				GROUP BY
				[f].[Id], [f].[Name];

/*данные по поставкам: список цветов и их количество (общее по каждому виду), 
  поставки которых назначены из определенной плантации. 
  Столбцы в результате: Id вида цветов, имя, количество. 
  Это будут данные по какой-то одной плантации;*/
   SELECT 
	[f].[Id], 
	[f].[Name],
	SUM([sf].[Amount]) as "Flowers per plantation"
		FROM 
		[FlowerSupplyDB].[dbo].[Flower] [f],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[Supply] [s],
		[FlowerSupplyDB].[dbo].[SupplyFlower] [sf],
		[FlowerSupplyDB].[dbo].[Status] [st]
			WHERE
			[f].Id = [sf].[FlowerId]
			and [s].[Id] = [sf].[SupplyId]
			and [p].[Id] = [s].[PlantationId]
			and [st].[Id] = [s].[StatusId]
			and [p].[Id] = 3
			--and [p].[Name] = 'Ame'
			and [st].[Name] = 'Scheduled'
				GROUP BY
				[f].[Id], 
				[f].[Name];

/*данные по поставкам: успешно выполненные поставки за последний месяц.
 Столбцы в результате: Id поставки, имя плантации, имя склада, дата выполнения поставки.*/

   SELECT 
	[s].[Id],
	[p].[Name], 
	[w].[Name],	
	[s].[ClosedDate]
		FROM 
		[FlowerSupplyDB].[dbo].[Warehouse] [w],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[Supply] [s]
			WHERE
			[w].Id = [s].[WarehouseId]
			and [p].[Id] = [s].[PlantationId]
			and MONTH([s].[ClosedDate]) = MONTH(getdate());

/*INSERT*/

/*добавить один вид цветов*/
INSERT INTO [FlowerSupplyDB].[dbo].[Flower]( 
	[Name]
	)
		VALUES 
		('Rose');

/*добавить несколько плантаций*/
INSERT INTO [FlowerSupplyDB].[dbo].[Plantation]( 
	 [Name],
	 [Address]
	 )
		VALUES 
		('Ame', 'Amegakura'),
		('Iwa', 'Iwagakure');

/*UPDATE*/

/*изменить количество цветов в поставке*/
UPDATE [FlowerSupplyDB].[dbo].[SupplyFlower] 
	SET 
		[Amount]=15
			WHERE 
				[FlowerSupplyDB].[dbo].[SupplyFlower].[SupplyId] = 1
				and [FlowerSupplyDB].[dbo].[SupplyFlower].[FlowerId] = 1;

