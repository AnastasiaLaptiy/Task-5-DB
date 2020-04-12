USE [FlowerSupplyDB];

-- DROP PROCEDURE IF EXISTS [dbo].[sp_ClosedSupply];

GO
CREATE PROCEDURE [dbo].[sp_ClosedSupply](
	@IdSupply INT,
	@IdFlower INT,
	@IdPlantation INT,
	@Amount INT
	)
AS
	BEGIN	
			DECLARE @Result bit = 0
		IF EXISTS 
			(SELECT 
			[s].Id
				FROM
				[FlowerSupplyDB].[dbo].[Supply] [s]
					WHERE
					[s].Id=@IdSupply)
		BEGIN

		set @Result=(SELECT [FlowerSupplyDB].[dbo].[isFlowerSupplyReal](@IdFlower, @IdPlantation, @Amount))
		IF 
		@Result=1
			BEGIN
			INSERT INTO [FlowerSupplyDB].[dbo].[SupplyFlower]( 
				[SupplyId], 
				[FlowerId], 
				[Amount]
				)
					VALUES (
					@IdSupply, @IdFlower, @Amount
				);
			UPDATE [FlowerSupplyDB].[dbo].[Supply]
				SET
				[ClosedDate]=(SELECT GETDATE()),
				[StatusID] = 
					(SELECT [s].[Id] 
						FROM 
						[FlowerSupplyDB].[dbo].[Status] [s]
							WHERE 
							[s].Name='Closed')
					WHERE 
				    [Id] = @IdSupply;
			END
		END
	END;
GO

/*Test*/

USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply]
		@IdSupply = 10,
		@IdFlower = 1,
		@IdPlantation = 1,
		@Amount = 20

SELECT	'Return Value' = @return_value

GO

