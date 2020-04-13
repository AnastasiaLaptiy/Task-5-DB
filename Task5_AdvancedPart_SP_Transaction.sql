USE [FlowerSupplyDB];

-- DROP PROCEDURE IF EXISTS [dbo].[sp_ClosedSupply];

GO
CREATE PROCEDURE [dbo].[sp_ClosedSupply](
	@IdSupply INT,
	@IdFlower INT,
	@IdPlantation INT,
	@IdWarehouse INT,
	@Amount INT
	)
AS
	BEGIN	
			DECLARE @Result BIT = 0	
			DECLARE @ErrorMsg VARCHAR(50)
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
			BEGIN TRANSACTION [FlowerAmountUpd]
				BEGIN TRY 
				UPDATE [FlowerSupplyDB].[dbo].[Supply]
				SET
				[ClosedDate]=(SELECT GETDATE()),
				[StatusID] = 
					(SELECT [s].[Id] 
						FROM 
						[FlowerSupplyDB].[dbo].[Status] [s]
							WHERE 
							[s].[Name]='Closed')
					WHERE 
				    [Id] = @IdSupply
					and [WarehouseId] = @IdWarehouse
					and [PlantationId] = @IdPlantation;

			IF EXISTS(
				SELECT *
					FROM [FlowerSupplyDB].[dbo].[SupplyFlower] [sf]
						WHERE 
						[sf].[FlowerId] = @IdFlower
						and [sf].SupplyId = @IdSupply)
			BEGIN
				UPDATE [FlowerSupplyDB].[dbo].[SupplyFlower]
					SET
					[Amount] = @Amount
						WHERE 
						[SupplyId] = @IdSupply
						and [FlowerId] = @IdFlower;
			END
			ELSE 
				BEGIN
				INSERT INTO [FlowerSupplyDB].[dbo].[SupplyFlower]( 
					[SupplyId], 
					[FlowerId], 
					[Amount]
					)
						VALUES (
						@IdSupply, @IdFlower, @Amount
					);
				END

			IF EXISTS(
				SELECT *
					FROM [FlowerSupplyDB].[dbo].[PlantationFlower] [pf]
						WHERE 
						[pf].[FlowerId] = @IdFlower
						and [pf].PlantationId = @IdPlantation)
			BEGIN
			UPDATE [FlowerSupplyDB].[dbo].[PlantationFlower]
				SET
				[Amount] = [Amount]-@Amount
					WHERE 
					[PlantationId] = @IdPlantation
					and [FlowerId] = @IdFlower;
			END
			ELSE 
				BEGIN
					INSERT INTO [FlowerSupplyDB].[dbo].[PlantationFlower](
						[PlantationId],
						[FlowerId],
						[Amount])
					VALUES(
					@IdPlantation, @IdFlower, @Amount
					);
			END

			IF EXISTS(
				SELECT *
					FROM [FlowerSupplyDB].[dbo].[WarehouseFlower] [wf]
						WHERE 
						[wf].[FlowerId]=@IdFlower
						and [wf].WarehouseId=@IdWarehouse)
			BEGIN
			UPDATE [FlowerSupplyDB].[dbo].[WarehouseFlower]
				SET
				[Amount]=[Amount]+@Amount
					WHERE 
					[WarehouseId] = @IdWarehouse
					and [FlowerId] = @IdFlower;
			END
			ELSE 
				BEGIN
					INSERT INTO [FlowerSupplyDB].[dbo].[WarehouseFlower](
						[WarehouseId],
						[FlowerId],
						[Amount])
					VALUES(
					@IdWarehouse, @IdFlower, @Amount
					);
				END
				
				COMMIT TRANSACTION [FlowerAmountUpd]

			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [FlowerAmountUpd]
					END CATCH

				END
			END
		ELSE
		BEGIN
		SET @ErrorMsg='Такой поставки нет';
		SELECT @ErrorMsg;
		END
	END;
GO

/*Test*/

USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply]
		@IdSupply = 93,
		@IdFlower = 3,
		@IdPlantation = 4,
		@IdWarehouse = 3,
		@Amount = 20


GO

