
--TO PRINT OUT TABLE NAMES
SELECT SCHEMA_NAME(schema_id) AS SchemaName, name AS TableName 
FROM sys.tables 
WHERE name LIKE '%Customer%';


-- -- Drop the view dim_CustomerJoin if it exists
-- IF OBJECT_ID('dbo.dim_CustomerJoin', 'V') IS NOT NULL
--     DROP VIEW dbo.dim_CustomerJoin;
-- GO

-- -- Create the view dim_CustomerJoin
-- CREATE VIEW dbo.dim_CustomerJoin AS
-- SELECT 
--     a.CustomerID,                 -- Identifier for the customer
--     a.PersonID,                   -- Identifier for the person
--     a.TerritoryID,                -- Identifier for the sales territory
--     b.CustomerKey AS CustomerKey, -- Identifier for the customer in the customer data
--     a.AccountNumber,              -- Account number for the customer
--     b.Customer_ID,                -- Customer identifier
--     b.Customer,                   -- Customer name
--     b.City,                       -- City of the customer
--     b.[State-Province] AS StateProvince,  -- State or province of the customer
--     b.[Country-Region] AS CountryRegion,  -- Country or region of the customer
--     b.Postal_Code                 -- Postal code of the customer
-- FROM 
--     dbo.Sales_Customer a ----------check the table name it should be dbo.Sales.Customer not dbo.Sales_Customer
-- INNER JOIN 
--     dbo.Customer_data_excel b 
--     ON a.CustomerID = b.CustomerKey;
-- GO



-- Drop the view dim_CustomerJoin if it exists
IF OBJECT_ID('dbo.dim_CustomerJoin', 'V') IS NOT NULL
    DROP VIEW dbo.dim_CustomerJoin;
GO

-- Create the view dim_CustomerJoin-----------------------------------1
CREATE VIEW dbo.dim_CustomerJoin AS
SELECT 
    a.CustomerID,                         -- Identifier for the customer
    a.PersonID,                           -- Identifier for the person
    a.TerritoryID,                        -- Identifier for the sales territory
    b.CustomerKey AS CustomerKey,         -- Identifier for the customer in the customer data
    a.AccountNumber,                      -- Account number for the customer
    b.[Customer ID],                        --Customer identifier Added brackets to match my metadata 
    b.Customer,                           -- Customer name
    b.City,                               -- City of the customer
    b.[State-Province] AS StateProvince,  -- State or province of the customer
    b.[Country-Region] AS CountryRegion,  -- Country or region of the customer
    b.[Postal Code]                         -- Postal code of the customer
FROM 
    dbo.[Sales Customer] a                -- FIXED: Added brackets and space to match your metadata
INNER JOIN 
    dbo.Customer_data_excel b 
    ON a.CustomerID = b.CustomerKey;
GO


-- Drop the view dim_SalesPersonStore if it exists
IF OBJECT_ID('dbo.dim_SalesPersonStore', 'V') IS NOT NULL
    DROP VIEW dbo.dim_SalesPersonStore;
GO

-- Create the view dim_SalesPersonStore-------------------------------------2
CREATE VIEW dbo.dim_SalesPersonStore AS
SELECT 
    sp.BusinessEntityID AS SalesPersonID,     -- SalesPerson Identifier
    st.BusinessEntityID AS StoreID,           -- Store Identifier
    sp.TerritoryID,                           -- Sales Territory
    sp.SalesQuota,                            -- Sales Quota
    sp.Bonus,                                 -- Bonus
    sp.CommissionPct,                         -- Commission Percentage
    sp.SalesYTD,                              -- Sales Year-To-Date
    sp.SalesLastYear,                         -- Sales Last Year
    st.Name AS StoreName                      -- Store Name
FROM 
    dbo.SalesPerson sp
INNER JOIN 
    dbo.Store st ON sp.BusinessEntityID = st.SalesPersonID;
GO







-- Drop the view dim_SalesTerritory if it exists
IF OBJECT_ID('dbo.dim_SalesTerritory', 'V') IS NOT NULL
    DROP VIEW dbo.dim_SalesTerritory;
GO

-- Create the view dim_SalesTerritory--------------------------------------------3
CREATE VIEW dbo.dim_SalesTerritory AS
SELECT 
    TerritoryID,          -- Identifier for the sales territory
    Name,                 -- Name of the sales territory
    CountryRegionCode,    -- Country or region code
    [Group],              -- Group of the sales territory
    SalesYTD,             -- Sales Year-To-Date
    SalesLastYear,        -- Sales Last Year
    CostYTD,              -- Cost Year-To-Date
    CostLastYear          -- Cost Last Year
FROM 
    dbo.Sales_SalesTerritory;
GO





-- Drop the view dim_DateData if it exists
IF OBJECT_ID('dbo.dim_DateData', 'V') IS NOT NULL
    DROP VIEW dbo.dim_DateData;
GO

-- Create the view dim_DateData-------------------------------------------------------4
CREATE VIEW dbo.dim_DateData AS
SELECT * 
FROM dbo.Date_data;
GO

-- Drop the view dim_ProductData if it exists
IF OBJECT_ID('dbo.dim_ProductData', 'V') IS NOT NULL
    DROP VIEW dbo.dim_ProductData;
GO

-- Create the view dim_ProductData-----------------------------------------------------------------5
CREATE VIEW dbo.dim_ProductData AS
SELECT * 
FROM dbo.Product_data_excel;
GO

-- Drop the view dim_ResellerData if it exists
IF OBJECT_ID('dbo.dim_ResellerData', 'V') IS NOT NULL
    DROP VIEW dbo.dim_ResellerData;
GO

-- Create the view dim_ResellerData-------------------------------------------------------------------6
CREATE VIEW dbo.dim_ResellerData AS
SELECT * 
FROM dbo.Reseller_data_excel;
GO

-- Drop the view fact_JoinedOrders if it exists
IF OBJECT_ID('dbo.fact_JoinedOrders', 'V') IS NOT NULL
    DROP VIEW dbo.fact_JoinedOrders;
GO

-- 1. CLEAN UP THE DATABASE
-- This part checks if a view named 'fact_JoinedOrders' already exists. 
-- If it does, it deletes (drops) it so we can create a completely fresh one.
IF OBJECT_ID('dbo.fact_JoinedOrders', 'V') IS NOT NULL
    DROP VIEW dbo.fact_JoinedOrders;
GO

-- 2. CREATE THE VIEW
-- This tells the database to build our new virtual table called 'fact_JoinedOrders'.
CREATE VIEW dbo.fact_JoinedOrders AS
SELECT 
    -- COLUMNS FROM EXCEL FILE 'e'
    e.[Sales Order] AS SalesOrderId,    -- Takes the Excel order number and renames it to match our database naming standard
    e.SalesOrderLineKey,                 -- A unique tracking key for each line in Excel
    e.[Sales Order],                     -- The raw Order Number from Excel (wrapped in brackets because of the space)
    e.[Sales Order Line],                -- The row line number from Excel (wrapped in brackets because of the space)
    e.Channel,                           -- How it was sold (e.g., Online or Wholesale)
    
    -- COLUMNS FROM TRANSACTION DETAIL TABLE 'd'
    d.SalesOrderDetailID,                -- The unique ID for this line item in the core database
    d.OrderQty,                          -- Quantity of products bought
    d.ProductID,                         -- The unique number identifying the product
    d.CarrierTrackingNumber,             -- Shipment tracking number
    d.SpecialOfferID,                    -- ID for any discounts applied
    d.UnitPrice,                         -- Price per single item
    d.UnitPriceDiscount,                 -- Discount amount taken off the price
    d.LineTotal,                         -- Total cost for this specific line (Qty * Price)
    
    -- COLUMNS FROM TRANSACTION HEADER TABLE 'h'
    h.OrderDate,                         -- The date the order was made
    h.DueDate,                           -- The date the order is expected
    h.ShipDate,                          -- The date the order left the warehouse
    h.CustomerID,                        -- The ID of the customer who bought it
    h.SalesPersonID,                     -- The ID of the employee who made the sale
    h.TerritoryID,                       -- The ID of the region where it was sold
    h.ShipMethodID,                      -- The shipping company/method used
    h.TotalDue,                          -- The grand total for the whole invoice
    
    -- COLUMNS FROM ANALYTICAL SALES TABLE 's'
    s.ResellerKey,                       -- Business key for the store/reseller
    s.CustomerKey AS SalesCustomerKey,   -- The customer key from the sales data (renamed to avoid confusion)
    s.ProductKey,                        -- Analytical key for the product
    s.OrderDateKey,                      -- Special date key used for connecting to the date table
    s.DueDateKey,                        -- Special date key for the due date
    s.ShipDateKey,                       -- Special date key for the ship date
    s.SalesTerritoryKey,                 -- Analytical key for the region
    s.OrderQuantity,                     -- Quantity tracked in our sales records
    s.UnitPrice as Unit_Price,           -- Price tracked in our sales records
    s.ExtendedAmount,                    -- Total sales amount before discounts
    s.UnitPriceDiscountPct,              -- The discount percentage applied
    s.ProductStandardCost,               -- What it baseline costs the company to make/buy this product
    s.TotalProductCost,                  -- Total cost to the company for this entire line
    s.SalesAmount                        -- Final revenue made after discounts

-- 3. LINKING ALL THE TABLES TOGETHER (THE JOINS)
FROM [dbo].[SalesOrder_data_excel] e  -- Start with our main Excel table and call it 'e' for short

-- LINK 1: Excel data ('e') to the Order Header table ('h')
-- BEGINNER NOTE FOR YOUR BOSS: In Excel, order numbers look like text ('SO44110'), 
-- but in the database, they are numbers (44110). We use 'SUBSTRING' to chop off the 'SO' 
-- and 'CAST' to turn the text into a real number so they can match up flawlessly!
INNER JOIN [dbo].[SalesOrderHeader] h 
    ON CAST(SUBSTRING(e.[Sales Order], 3, LEN(e.[Sales Order])) AS INT) = h.SalesOrderID

-- LINK 2: Order Header table ('h') to the Order Detail table ('d')
-- This connects the general order information to the individual line items using the shared Order ID.
INNER JOIN [dbo].[SalesOrderDetail] d 
    ON h.SalesOrderID = d.SalesOrderID

-- LINK 3: Excel data ('e') to the final Sales table ('s')
-- This connects our initial Excel staging data to our final analytical sales data using a matching text key.
INNER JOIN [dbo].[Sales_data_excel] s 
    ON e.SalesOrderLineKey = s.SalesOrderLineKey;
GO