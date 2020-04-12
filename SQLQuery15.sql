USE [FlowerSupplyDB];

/*SELECT*/

/*plantation list*/

SELECT 
	[p].[Name] 
		FROM 
		[FlowerSupplyDB].[dbo].[Plantation] [p];

/*- ������ �� ���������: ������ ������ � �� ����������. 
������� � ����������: Id ���������, ���, �����, ����������;  */
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

/*������ �� ����� ������: ��� ������� ���� ���������� ���������, 
  �� ������� ���� ����� ������� ����. 
  ������� � ����������: Id ���� ������, ���, ���������� ��������� 
  (������ ���������� ��� ������� "Plantations number");*/

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
				

/*������ �� ����� ������: ��� ������� ���� ���������� ���������, 
 �� ������� ���� ����� ������� ���� � ���������� ������ 1000.
 �������, ��� � � ���������� ������: Id ���� ������, ���, ���������� ��������� 
  (������ ���������� ��� ������� "Plantations number");*/

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

/*������ �� ���������: ������ ������ � �� ���������� (����� �� ������� ����), 
  �������� ������� ��������� �� ������������ ���������. 
  ������� � ����������: Id ���� ������, ���, ����������. 
  ��� ����� ������ �� �����-�� ����� ���������;*/
   SELECT 
	[f].[Id], 
	[f].[Name],
	SUM([sf].[Amount]) as "Flowers per plantation"
		FROM 
		[FlowerSupplyDB].[dbo].[Flower] [f],
		[FlowerSupplyDB].[dbo].[Plantation] [p],
		[FlowerSupplyDB].[dbo].[Supply] [s],
		[FlowerSupplyDB].[dbo].[SupplyFlower] [sf]
			WHERE
			[f].Id = [sf].[FlowerId]
		and [s].[Id] = [sf].[SupplyId]
		and [p].[Id] = [s].[PlantationId]
		and [p].[Name] = 'Ame'
				GROUP BY
				[f].[Id], 
				[f].[Name];

/*������ �� ���������: ������� ����������� �������� �� ��������� �����.
 ������� � ����������: Id ��������, ��� ���������, ��� ������, ���� ���������� ��������.*/

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

/*�������� ���� ��� ������*/
INSERT INTO [FlowerSupplyDB].[dbo].[Flower]( 
	[Name]
	)
		VALUES 
		('Rose');

/*�������� ��������� ���������*/
INSERT INTO [FlowerSupplyDB].[dbo].[Plantation]( 
	 [Name],
	 [Address]
	 )
		VALUES 
		('Ame', 'Amegakura'),
		('Iwa', 'Iwagakure');

/*UPDATE*/

/*�������� ���������� ������ � ��������*/
UPDATE [FlowerSupplyDB].[dbo].[SupplyFlower] 
	SET 
		[Amount]=15
			WHERE 
				[FlowerSupplyDB].[dbo].[SupplyFlower].[SupplyId] = 1
			and [FlowerSupplyDB].[dbo].[SupplyFlower].[FlowerId] = 1;

