CREATE OR ALTER PROCEDURE [dbo].[Load_Gold_DWH]
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Drop the Fact table FIRST
    IF OBJECT_ID('Gold_DWH.dbo.fact_Orders', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.fact_Orders;

    -- 2. Drop the Dimension tables safely
    IF OBJECT_ID('Gold_DWH.dbo.dim_Customer', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_Customer;

    IF OBJECT_ID('Gold_DWH.dbo.dim_SalesPersonStore', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_SalesPersonStore;

    IF OBJECT_ID('Gold_DWH.dbo.dim_SalesTerritory', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_SalesTerritory;

    IF OBJECT_ID('Gold_DWH.dbo.dim_Date', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_Date;

    IF OBJECT_ID('Gold_DWH.dbo.dim_Product', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_Product;

    IF OBJECT_ID('Gold_DWH.dbo.dim_Reseller', 'U') IS NOT NULL 
        DROP TABLE Gold_DWH.dbo.dim_Reseller;


    -- 3. Load Gold tables from the correct source: silver_DH
    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_Customer
    FROM silver_DH.dbo.dim_CustomerJoin;

    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_SalesPersonStore
    FROM silver_DH.dbo.dim_SalesPersonStore;

    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_SalesTerritory
    FROM silver_DH.dbo.dim_SalesTerritory;

    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_Date
    FROM silver_DH.dbo.dim_DateData;

    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_Product
    FROM silver_DH.dbo.dim_ProductData;

    SELECT DISTINCT * INTO Gold_DWH.dbo.dim_Reseller
    FROM silver_DH.dbo.dim_ResellerData;

    SELECT DISTINCT * INTO Gold_DWH.dbo.fact_Orders
    FROM silver_DH.dbo.fact_JoinedOrders;

    PRINT 'Gold_DWH load completed successfully.';
END;
GO




--Store Procedure Tigger  RUN THIS AFTER YOUR STORE PROCEDURE HAS BEEN CREATED

EXEC [dbo].[Load_Gold_DWH];