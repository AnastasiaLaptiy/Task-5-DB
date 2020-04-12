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

CREATE FUNCTION [dbo].[isFlowerSupplyReal](
	@IdFlower INT,
	@IdPlantation INT,
	@Amount INT
	)
	RETURNS bit	
		AS 
		BEGIN
		DECLARE @Result bit = 0
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
					SELECT @Result = 0;
				END
	RETURN @Result
END;

/*Test*/

SELECT [dbo].[isFlowerSupplyReal](5,3,15); --0


SELECT [dbo].[isFlowerSupplyReal](1,1,200); --1