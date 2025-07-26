
-- Create CustomerTB
CREATE TABLE CustomerTB (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(50),
    City VARCHAR(100)
);

-- Insert Customers
INSERT INTO CustomerTB (CustomerID, FirstName, LastName, Email, Phone, City)
VALUES
(1, 'Musa', 'Ahmed', 'musa.ahmed@hotmail.com', '0803-123-0001', 'Lagos'),
(2, 'Ray', 'Samson', 'ray.samson@yahoo.com', '0803-123-0022', 'Ibadan'),
(3, 'Chinedu', 'Okafor', 'chinedu.ok@yahoo.com', '0803-123-0003', 'Enugu'),
(4, 'Dare', 'Adewale', 'dare.adewale@hotmail.com', '0803-123-0041', 'Abuja'),
(5, 'Efe', 'Ojo', 'efe.ojo@gmail.com', '0803-123-0051', 'Port Harcourt'),
(6, 'Aisha', 'Bello', 'aisha.bello@hotmail.com', '0803-123-0061', 'Kano'),
(7, 'Tunde', 'Salami', 'tunde.salami@hotmail.com', '0803-123-0071', 'Ilorin'),
(8, 'Nneka', 'Umeh', 'nneka.umeh@hotmail.com', '0803-123-0081', 'Owerri'),
(9, 'Kelvin', 'Peters', 'kelvin.peters@hotmail.com', '0803-123-0091', 'Asaba'),
(10, 'Blessing', 'Mark', 'blessing.peters@hotmail.com', '0803-123-0010', 'Uyo');

-- Create ProductTB
CREATE TABLE ProductTB (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    UnitPrice DECIMAL(10, 2),
    StockQty INT
);

-- Insert Products
INSERT INTO ProductTB (ProductID, ProductName, Category, UnitPrice, StockQty)
VALUES
(1, 'Wireless Mouse', 'Accessories', 7500.00, 120),
(2, 'USB-C Charger 65W', 'Electronics', 14500.00, 75),
(3, 'Noise-Cancel Headset', 'Audio', 8550.00, 50),
(4, '27" 4K Monitor', 'Displays', 185000.00, 25),
(5, 'Laptop Stand', 'Accessories', 19500.00, 90),
(6, 'Bluetooth Speaker', 'Audio', 52000.00, 60),
(7, 'Mechanical Keyboard', 'Accessories', 18500.00, 40),
(8, 'WebCam 1080p', 'Electronics', 25000.00, 55),
(9, 'Smartwatch Series 5', 'Wearables', 320000.00, 30),
(10, 'Portable SSD 1TB', 'Storage', 125000.00, 35);

-- Create OrdersTB
CREATE TABLE OrdersTB (
    OrderID INT,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT
);

-- Insert Orders
INSERT INTO OrdersTB (OrderID, CustomerID, ProductID, OrderDate, Quantity)
VALUES
(1001, 1, 3, '2025-06-01', 1),
(1002, 2, 5, '2025-06-01', 1),
(1003, 3, 6, '2025-06-05', 1),
(1004, 4, 1, '2025-06-06', 2),
(1005, 5, 4, '2025-06-07', 1),
(1006, 6, 2, '2025-06-08', 1),
(1007, 7, 8, '2025-06-09', 1),
(1008, 8, 10, '2025-06-10', 1),
(1009, 9, 9, '2025-06-12', 1),
(1010, 10, 6, '2025-06-25', 2);

-- Query 4: Customers who bought 'Wireless Mouse'
SELECT DISTINCT c.FirstName, c.Email
FROM CustomerTB c
JOIN OrdersTB o ON c.CustomerID = o.CustomerID
JOIN ProductTB p ON o.ProductID = p.ProductID
WHERE p.ProductName = 'Wireless Mouse';

-- Query 5: All customer full names in ascending alphabetical order
SELECT FirstName, LastName
FROM CustomerTB
ORDER BY LastName ASC, FirstName ASC;

-- Query 6: Every order with full name, product, quantity, unit price, total price, and order date
SELECT 
    c.FirstName + ' ' + c.LastName AS FullName,
    p.ProductName,
    o.Quantity,
    p.UnitPrice,
    (o.Quantity * p.UnitPrice) AS TotalPrice,
    o.OrderDate
FROM OrdersTB o
JOIN CustomerTB c ON o.CustomerID = c.CustomerID
JOIN ProductTB p ON o.ProductID = p.ProductID;

-- Query 7: Average sales per product category, descending
SELECT 
    p.Category,
    AVG(o.Quantity * p.UnitPrice) AS AvgSales
FROM OrdersTB o
JOIN ProductTB p ON o.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY AvgSales DESC;

-- Query 8: Highest revenue-generating city per year
SELECT SalesYear, City, TotalRevenue
FROM (
    SELECT 
        YEAR(o.OrderDate) AS SalesYear,
        c.City,
        SUM(o.Quantity * p.UnitPrice) AS TotalRevenue,
        RANK() OVER (PARTITION BY YEAR(o.OrderDate) ORDER BY SUM(o.Quantity * p.UnitPrice) DESC) AS RankPerYear
    FROM OrdersTB o
    JOIN CustomerTB c ON o.CustomerID = c.CustomerID
    JOIN ProductTB p ON o.ProductID = p.ProductID
    GROUP BY YEAR(o.OrderDate), c.City
) AS RankedRevenue
WHERE RankPerYear = 1;
