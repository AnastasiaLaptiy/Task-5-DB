
USE [FlowerSupplyDB];
/*there are some of same queries the only difference between them is logic part coz include NULL here*/



/*данные по видам цветов: для каждого вида количество плантаций, 
  на которых есть цветы данного вида. 
  Столбцы в результате: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations number");*/

   SELECT 
   [f].[Id], [f].[Name], COUNT([p].[Id]) AS "Plantations number"
	FROM 
	[FlowerSupplyDB].[dbo].[Flower] [f]
	LEFT OUTER JOIN [FlowerSupplyDB].[dbo].[PlantationFlower] [pf] ON 
			[f].[Id] = [pf].[FlowerId]
	LEFT OUTER JOIN [FlowerSupplyDB].[dbo].[Plantation] [p] on
			[p].[Id] = [pf].[PlantationId]
				GROUP BY
				[f].[Id], [f].[Name];

  /*данные по видам цветов: для каждого вида количество плантаций, 
 на которых есть цветы данного вида в количестве больше 1000.
 Столбцы, как и в предыдущем пункте: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations number");*/


  SELECT 
   [f].[Id], [f].[Name], COUNT([p].[Id]) AS "Plantations number"
	FROM 
	[FlowerSupplyDB].[dbo].[Flower] [f]
	LEFT OUTER JOIN [FlowerSupplyDB].[dbo].[PlantationFlower] [pf] ON 
			[f].[Id] = [pf].[FlowerId]
	LEFT OUTER JOIN [FlowerSupplyDB].[dbo].[Plantation] [p] on
			[p].[Id] = [pf].[PlantationId]
				AND
				[pf].[Amount]>1000
					GROUP BY
					[f].[Id], [f].[Name];
				