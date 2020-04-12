CREATE DATABASE [FlowerSupplyDB];

USE [FlowerSupplyDB];

/*creating scripts for tables*/

CREATE TABLE [FlowerSupplyDB].[dbo].[Flower](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Name] VARCHAR(30) NOT NULL);

CREATE TABLE [FlowerSupplyDB].[dbo].[Plantation](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Name] VARCHAR(30) NOT NULL,
	[Address] VARCHAR(30) NOT NULL);

CREATE TABLE [FlowerSupplyDB].[dbo].[Warehouse](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Name] VARCHAR(30) NOT NULL,
	[Address] VARCHAR(30) NOT NULL);

CREATE TABLE [FlowerSupplyDB].[dbo].[PlantationFlower](
	[PlantationId] INT,
	[FlowerId] INT,
	[Amount] INT NOT NULL,
	PRIMARY KEY ([PlantationId], [FlowerId]),
	FOREIGN KEY ([PlantationId]) REFERENCES [Plantation](Id),
	FOREIGN KEY ([FlowerId]) REFERENCES [Flower](Id));

CREATE TABLE [FlowerSupplyDB].[dbo].[WarehouseFlower](
	[WarehouseId] INT,
	[FlowerId] INT,
	[Amount] INT NOT NULL,
	PRIMARY KEY ([WarehouseId], [FlowerId]),
	FOREIGN KEY ([WarehouseId]) REFERENCES [Warehouse](Id),
	FOREIGN KEY ([FlowerId]) REFERENCES [Flower](Id));

CREATE TABLE [FlowerSupplyDB].[dbo].[Status](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Name] VARCHAR(30) NOT NULL);

CREATE TABLE [FlowerSupplyDB].[dbo].[Supply](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[WarehouseId] INT,
	[PlantationId] INT,
	[ScheduledDate] DATE,
	[ClosedDate] DATE,
	[StatusId] INT,
	FOREIGN KEY ([WarehouseId]) REFERENCES [Warehouse](Id),
	FOREIGN KEY ([PlantationId]) REFERENCES [Plantation](Id),
	FOREIGN KEY ([StatusId]) REFERENCES [Status](Id));

CREATE TABLE [FlowerSupplyDB].[dbo].[SupplyFlower](
	[SupplyId] INT,
	[FlowerId] INT,
	[Amount]  INT NOT NULL,
	PRIMARY KEY([SupplyId],[FlowerId]),
	FOREIGN KEY ([SupplyId]) REFERENCES [Supply](Id),
	FOREIGN KEY ([FlowerId]) REFERENCES [Flower](Id));

/*add field for flower name*/
/*v1*/

ALTER TABLE [FlowerSupplyDB].[dbo].[Flower]
	ADD
		[Name] VARCHAR(30) NOT NULL DEFAULT 'new column';

/*v2*/

/*с латиницей*/

ALTER TABLE [FlowerSupplyDB].[dbo].[Flower]
	ADD
		[Name1] VARCHAR(30) COLLATE Latin1_General_100_CI_AI NOT NULL DEFAULT 'new column';