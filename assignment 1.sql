-- Ashley Teraishi
-- CST 363 Assignment 1
--
-- e5.1 Exercises from chapter 5
--
-- Before you begin:
-- create the tables and data using the script 
--   zagimore_schema.sql
--
-- 1  Display all records in the REGION table
SELECT * 
FROM region;

-- 2 Display StoreID and StoreZIP for all stores
SELECT storeid, storezip 
FROM store;

-- 3 Display CustomerName and CustomerZip for all customers
--   sorted alphabetically by CustomerName
SELECT customername, customerzip
FROM customer
ORDER BY customername;

-- 4 Display the RegionIDs where we have stores 
--   and do not display duplicates
SELECT DISTINCT regionid
FROM store;

-- 5 Display all information for all stores in RegionID C 
SELECT *
FROM store
WHERE regionid = 'C';

-- 6 Display CustomerID and CustomerName for customers who name 
--   begins with the letter T
SELECT customerid, customername
FROM customer
WHERE customername LIKE 'T%';

-- 7 Display ProductID, ProductName and ProductPrice for 
--   products with a price of $100 or higher
SELECT productid, productname, productprice
FROM product
WHERE productprice >= 100;

-- 8 Display ProductID, ProductName, ProductPrice and VendorName
--   for products sorted by ProductID
SELECT product.productid, product.productname, product.productprice, vendor.vendorname
FROM product 
JOIN vendor 
ON product.vendorid = vendor.vendorid
ORDER BY productid;


-- 9 Display ProductID, ProductName, ProductPrice,  VendorName and CategoryName
--   for products.  Sort by ProductID
SELECT product.productid, product.productname, product.productprice, vendor.vendorname, category.categoryname
FROM product 
JOIN vendor 
ON product.vendorid = vendor.vendorid
JOIN category 
ON product.categoryid = category.categoryid
ORDER BY productid;

-- 10 Display ProductID, ProductName, ProductPrice  
--   for products in category "Camping" sorted by ProductID
SELECT productid, productname, productprice
FROM product
WHERE categoryid = 'CP'
ORDER BY productid;

-- 11 Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
SELECT product.productid, product.productname, product.productprice
FROM product
JOIN store
JOIN salestransaction
ON store.storeid = salestransaction.storeid
JOIN includes
ON product.productid = includes.productid 
AND salestransaction.tid = includes.tid
WHERE store.storezip = '60600'
ORDER BY productid;


-- 12 Display ProductID, ProductName and ProductPrice for VendorName "Pacifica Gear" and were
--    sold in the region "Tristate".  Do not show duplicate information.
SELECT DISTINCT product.productid, product.productname, product.productprice
FROM vendor
JOIN product
ON vendor.vendorid = product.vendorid
JOIN store
JOIN salestransaction
ON store.storeid = salestransaction.storeid
JOIN includes
ON product.productid = includes.productid 
AND salestransaction.tid = includes.tid
WHERE vendor.vendorname = 'Pacifica Gear'
AND store.regionid = 'T';

-- 13 Display TID, CustomerName and TDate for any customer buying a product "Easy Boot"
--    Sorted by TID.
SELECT salestransaction.tid, customer.customername, salestransaction.tdate
FROM customer
JOIN product
JOIN store
JOIN salestransaction
ON store.storeid = salestransaction.storeid
AND customer.customerid = salestransaction.customerid
JOIN includes
ON product.productid = includes.productid 
AND salestransaction.tid = includes.tid
WHERE product.productname = 'Easy Boot'
ORDER BY salestransaction.tid;


-- 14 Create table and insert the following data

-- create table company with columns
--    companyid char(3), name varchar(50), ceo varchar(50)
--    make column companyid the primary key
CREATE TABLE company 
(	companyid CHAR(3)		NOT NULL,
    companyname VARCHAR(50)	NOT NULL,
    ceo VARCHAR(50)			NOT NULL,
    PRIMARY KEY (companyid) ); 

-- insert the following data 
--    companyid   name          ceo
--    ACF         Acme Finance  Mike Dempsey
--    TCA         Tara Capital  Ava Newton
--    ALB         Albritton     Lena Dollar
INSERT INTO company VALUES ('ACF', 'Acme Finance', 'Mike Dempsey');
INSERT INTO company VALUES ('TCA', 'Tara Capital', 'Ava Newton');
INSERT INTO company VALUES ('ALB', 'Albritton', 'Lena Dollar');

-- create a table security with columns
--     secid, name, type
--     secid should be the primary key
CREATE TABLE security
(	secid CHAR(2)		NOT NULL,
    secname VARCHAR(50)	NOT NULL,
    sectype VARCHAR(10)	NOT NULL,
    PRIMARY KEY (secid) );

-- insert the following data
--    secid    name                type
--    AE       Abhi Engineering    Stock
--    BH       Blues Health        Stock
--    CM       County Municipality Bond
--    DU       Downtown Utlity     Bond
--    EM       Emmitt Machines     Stock
INSERT INTO security VALUES ('AE', 'Abhi Engineering', 'Stock');
INSERT INTO security VALUES ('BH', 'Blues Health', 'Stock');
INSERT INTO security VALUES ('CM', 'County Municipality', 'Bond');
INSERT INTO security VALUES ('DU', 'Downtown Utility', 'Bond');
INSERT INTO security VALUES ('EM', 'Emmit Machines', 'Stock');

-- create the following table called fund 
--  with columns companyid, inceptiondate, fundid, name
--   fundid should be the primary key
--   companyid should be a foreign key referring to the company table.
CREATE TABLE fund
(	companyid CHAR(3)	NOT NULL,
	inceptiondate DATE	NOT NULL,
    fundid CHAR(2)		NOT NULL,
    fundname VARCHAR(30)	NOT NULL,
    PRIMARY KEY (fundid),
    FOREIGN KEY (companyid) REFERENCES company(companyid) );

-- CompanyID  InceptionDate   FundID Name
--    ACF      2005-01-01     BG     Big Growth
--    ACF      2006-01-01     SG     Steady Growth
--    TCA      2005-01-01     LF     Tiger Fund
--    TCA      2006-01-01     OF     Owl Fund
--    ALB      2005-01-01     JU     Jupiter
--    ALB      2006-01-01     SA     Saturn
INSERT INTO fund VALUES ('ACF', '2005-01-01', 'BG', 'Big Growth');
INSERT INTO fund VALUES ('ACF', '2006-01-01', 'SG', 'Steady Growth');
INSERT INTO fund VALUES ('TCA', '2005-01-01', 'LF', 'Tiger Fund');
INSERT INTO fund VALUES ('TCA', '2006-01-01', 'OF', 'Owl Fund');
INSERT INTO fund VALUES ('ALB', '2005-01-01', 'JU', 'Jupiter');
INSERT INTO fund VALUES ('ALB', '2006-01-01', 'SA', 'Saturn');


-- create table holdings with columns
--   fundid, secid, quantity
--   make (fundid, secid) the primary key
--   fundid is also a foreign key referring to the fund  table
--   secid is also a foreign key referring to the security table
CREATE TABLE holdings
(	fundid CHAR(2)	NOT NULL,
	secid CHAR(2)	NOT NULL,
    quantity INT	NOT NULL,
    PRIMARY KEY (fundid, secid),
    FOREIGN KEY (fundid) REFERENCES fund(fundid),
    FOREIGN KEY (secid) REFERENCES security(secid) );

--    fundid   secid    quantity
--     BG       AE           500
--     BG       EM           300
--     SG       AE           300
--     SG       DU           300
--     LF       EM          1000
--     LF       BH          1000
--     OF       CM          1000
--     OF       DU          1000
--     JU       EM          2000
--     JU       DU          1000
--     SA       EM          1000
--     SA       DU          2000
INSERT INTO holdings VALUES ('BG', 'AE', 500); 
INSERT INTO holdings VALUES ('BG', 'EM', 300);
INSERT INTO holdings VALUES ('SG', 'AE', 300);  
INSERT INTO holdings VALUES ('SG', 'DU', 300); 
INSERT INTO holdings VALUES ('LF', 'EM', 1000); 
INSERT INTO holdings VALUES ('LF', 'BH', 1000); 
INSERT INTO holdings VALUES ('OF', 'CM', 1000); 
INSERT INTO holdings VALUES ('OF', 'DU', 1000); 
INSERT INTO holdings VALUES ('JU', 'EM', 2000); 
INSERT INTO holdings VALUES ('JU', 'DU', 1000); 
INSERT INTO holdings VALUES ('SA', 'EM', 1000);
INSERT INTO holdings VALUES ('SA', 'DU', 2000); 


-- 15 Use alter table command to add a column "price" to the 
--    security table.  The datatype should be numeric(7,2)
ALTER TABLE security
ADD price NUMERIC(7, 2);
 

-- 16 drop tables company, security, fund, holdings.
--    You must drop them in a certain order.
DROP TABLE holdings; 
DROP TABLE security;
DROP TABLE fund;
DROP TABLE company;


-- 17 Try to delete the row for product with productid '5X1'
DELETE FROM product
WHERE productid = '5X1';

-- 18 Explain why does the delete in question 17 fails.
-- the output states: "cannot delete or update a parent row: a foreign constraint fails"

-- the product with the productid '5X1' cannot be deleted because it is
-- referenced to in the includes table
-- given this, only a product that has never been sold can be deleted

-- 19 Try to delete the row for prduct with productid '5X2'
DElETE FROM product
WHERE productid = '5X2';

-- 20 Re-insert productid '5X2'
INSERT INTO product VALUES('5X2', 'Action Sandal', 70.00, 'PG', 'FW');

-- 21  update the price of '5X2', 'Action Sandal' by $10.00
UPDATE product
SET productprice = productprice + 10
WHERE productid = '5X2';

-- 22 increase the price of all products in the 'CY' category by 5%
UPDATE product
SET productprice = productprice + (productprice * 0.05)
WHERE categoryid = 'CY';

-- 23 decrease the price of all products made by vendorname 'Pacifica Gear' by $5.00
UPDATE product
JOIN vendor
ON product.vendorid = vendor.vendorid
SET productprice = productprice + 5
WHERE vendorname = 'Pacifica Gear';

-- 24 List productid and productprice for all products.  Sort by productid;
SELECT productid, productprice
FROM product
ORDER BY productid;

