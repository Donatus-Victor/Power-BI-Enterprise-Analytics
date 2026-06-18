-- MANNUALLY READING DATA TO THE GOLD LAYER
SELECT * INTO Gold_DWH.dbo.dim_CustomerJoin
FROM silver_DH.dbo.dim_CustomerJoin