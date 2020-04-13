USE [FlowerSupplyDB];

-- DROP PROCEDURE IF EXISTS [dbo].[sp_ClosedSupply_TRAN];

GO
CREATE PROCEDURE [dbo].[sp_ClosedSupply_TRAN](
	@IdSupply INT,
	@IdFlower INT,
	@IdPlantation INT,
	@IdWarehouse INT,
	@Amount INT
	)
AS
	BEGIN	
			DECLARE @Result BIT = 0	
			DECLARE @ErrorMsg VARCHAR(80)

		IF NOT EXISTS 
			(SELECT 
			[f].[Id]
				FROM
				[FlowerSupplyDB].[dbo].[Flower] [f]
					WHERE
					[f].[Id]=@IdFlower)
		BEGIN
			SET @ErrorMsg=CONCAT(
				'Can`t find flower with #',
				(SELECT @IdFlower)); 
			END	
			
			ELSE

			BEGIN
			IF NOT EXISTS 
			(SELECT 
			[p].[Id]
				FROM
				[FlowerSupplyDB].[dbo].[Plantation] [p]
					WHERE
					[p].[Id]=@IdPlantation)
		BEGIN
		SET @ErrorMsg=CONCAT(
			'Can`t find Plantation with #',
			(SELECT @IdPlantation)); 
			END

			ELSE

			BEGIN
			IF NOT EXISTS 
				(SELECT 
				[s].[Id]
					FROM
					[FlowerSupplyDB].[dbo].[Supply] [s]
						WHERE
						[s].[Id] = @IdSupply)
		BEGIN
		SET @ErrorMsg=CONCAT(
			'Can`t find supply with #',
			(SELECT @IdSupply));
		END

		ELSE

			BEGIN
			IF NOT EXISTS 
				(SELECT 
				[s].[ClosedDate]
					FROM
					[FlowerSupplyDB].[dbo].[Supply] [s]
						WHERE
						[s].[Id] = @IdSupply
						AND [s].ClosedDate IS NULL)
		BEGIN
		SET @ErrorMsg='Supply has had already closed';
		END
		
		ELSE

			BEGIN
			IF  
			 (@Amount <= 0)
		BEGIN
		SET @ErrorMsg='Amount should be >0';
		END

		ELSE

		BEGIN
		SET @Result=(SELECT [FlowerSupplyDB].[dbo].[isFlowerSupplyReal](@IdFlower, @IdPlantation, @Amount))
		IF 
		@Result!=1
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

			ELSE

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
					and [WarehouseId] = @IdWarehouse -- = (SELECT [s].[WarehouseId] FROM [FlowerSupplyDB].[dbo].[Supply] [s] WHERE [s].[Id] = @IdSupply) 
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
						and [wf].WarehouseId=@IdWarehouse) -- = (SELECT [s].[WarehouseId] FROM [FlowerSupplyDB].[dbo].[Supply] [s] WHERE [s].[Id] = @IdSupply) 
			BEGIN
			UPDATE [FlowerSupplyDB].[dbo].[WarehouseFlower]
				SET
				[Amount]=[Amount]+@Amount
					WHERE 
					[WarehouseId] = @IdWarehouse -- = (SELECT [s].[WarehouseId] FROM [FlowerSupplyDB].[dbo].[Supply] [s] WHERE [s].[Id] = @IdSupply) 
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
				SET @ErrorMsg='The flower amount has changed';
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [FlowerAmountUpd]
					END CATCH
					END
				END	
			END
		END
	END
END
		SELECT @ErrorMsg;		
	END;
GO

/*Test*/

/*Can`t find supply with #95*/
USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply_TRAN]
		@IdSupply = 95,
		@IdFlower = 3,
		@IdPlantation = 4,
		@IdWarehouse = 3,
		@Amount = 20
GO

/*case 1: add supply date and status also change flower amount*/

/*case 2: Supply has had already closed*/
USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply_TRAN]
		@IdSupply = 9,
		@IdFlower = 3,
		@IdPlantation = 4,
		@IdWarehouse = 3,
		@Amount = 5
GO

/*Can`t add supply with 4560 Flower - Mimosa from Plantation - Kusa*/
USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply_TRAN]
		@IdSupply = 9,
		@IdFlower = 3,
		@IdPlantation = 4,
		@IdWarehouse = 3,
		@Amount = 4560
GO

/*Can`t find flower with #323*/
USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply_TRAN]
		@IdSupply = 9,
		@IdFlower = 323,
		@IdPlantation = 4,
		@IdWarehouse = 3,
		@Amount = 45333
GO

/*Can`t find Plantation with #44444*/
USE [FlowerSupplyDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_ClosedSupply_TRAN]
		@IdSupply = 9,
		@IdFlower = 3,
		@IdPlantation = 44444,
		@IdWarehouse = 3,
		@Amount = 45
GO

