USE [FlowerSupplyDB];

/*�������, ������� ���������,
 ����� �� ������� �������� 
 � ������������ ����������� ������ 
 ������������� ���� 
 �� ����������� ���������. 
 �.�. ������� �� �� ��������� ���������� ������ 
 � ������ ����, ��� �� ����, ��� �������� �������, 
 ���������� ������ �� ��������� �������� ����������. 
 ����� �������� �������� ���������� ������ �� ��������� �����������. 
 �������� ���������: Id ���� ������, Id ���������, ����������. ������������ �������� � ������� true/false.
*/

CREATE FUNCTION [dbo].[isRealFlowerSupply](
	@IdFlower INT,
	@IdPlantation INT,
	@Amount INT
	)
	RETURNS bit	
		AS 
		BEGIN
		DECLARE @ResultVar bit = 0
			IF EXISTS (
				SELECT * 					
					FROM
					[FlowerSupplyDB].[dbo].[PlantationFlower] [pl],
					[FlowerSupplyDB].[dbo].[Plantation] [p],
					[FlowerSupplyDB].[dbo].[Flower] [f]
						WHERE
						[pl].[FlowerId]=[f].[Id]
					and [pl].[PlantationId]=[p].[Id]
					and [pl].[PlantationId] = @IdPlantation
					and [pl].[FlowerId] = @IdFlower
					and [pl].[Amount]>=@Amount)
     BEGIN
        SELECT @ResultVar = 1
    END
	return @ResultVar
	end;

select [dbo].[isRealFlowerSupply](1,1,1);