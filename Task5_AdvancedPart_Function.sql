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

/* > �.�. ��������������, ��� � ��� ��� ��������� ���� �� ���� IdSupply?
 > ���� ��� ������� ������ ��� ���������, �� ��, � ���� ��� ���� ���������, ��, ����� ������ ������� �� �������� ��� �� ���� ����� ��  IdSupply
 > ����� ��, ���� �� ���������, ��� ����� ������� �������� � �������� ����� ������, 
	�������� ���� � ��� ��������� ���������, �� � �� ����� ������� ��������� ������� ��� �����,
	������ ��� ����� ��������� ��������� ������ ��������� � ����� �����������, 
	������� �� ��������� � ��������"�������� �� �������� � ����� ���-��� ������"
 > ������ ��� �������� ���/���� ��� �� ����� ��� ��������� ������� �� ��������, 
   ��������� ��� ���, ������� ��� ������� (� ��� ���� ��� ���-�� ������ ���������), � �� ������� ��� ���� �� ��������� �� � �������� ��� ���
 > ������ ����, ���� �� ����� ����� IdSupply � ��������� ������� �� ���, �� ��, ��� ����� �����*/

-- DROP FUNCTION IF EXISTS [dbo].[isFlowerSupplyReal];

GO
CREATE FUNCTION [dbo].[isFlowerSupplyReal](
	@IdFlower INT,
	@IdPlantation INT,
	@Amount INT
	)
	RETURNS BIT	
		AS 
		BEGIN
		DECLARE @Result BIT = 0
		DECLARE @ErrorMsg VARCHAR(30)
			IF EXISTS (
				SELECT * 					
					FROM
					[FlowerSupplyDB].[dbo].[PlantationFlower] [pl],
					[FlowerSupplyDB].[dbo].[Plantation] [p],
					[FlowerSupplyDB].[dbo].[Flower] [f]
						WHERE
						[pl].[FlowerId] = [f].[Id]
					and [pl].[PlantationId] = [p].[Id]
					and [pl].[PlantationId] = @IdPlantation
					and [pl].[FlowerId] = @IdFlower
					and [pl].[Amount] >= @Amount)
					 BEGIN
						SELECT @Result = 1
					 END
			ELSE
				BEGIN
					SET @ErrorMsg=CONCAT(
					'Can`t add supply with ',
					(SELECT @Amount),
					' Flower - ', 
					(SELECT [f].[Name] FROM [FlowerSupplyDB].[dbo].[Flower] [f] WHERE [f].[Id] = @IdFlower),
					' from Plantation - ',
					(SELECT [p].[Name] FROM [FlowerSupplyDB].[dbo].[Plantation] [p] WHERE [p].[Id] = @IdPlantation)
					);
				END
	RETURN @Result
END;
GO

/*Test*/

SELECT [dbo].[isFlowerSupplyReal](5,3,15); --0


SELECT [dbo].[isFlowerSupplyReal](1,1,200); --1