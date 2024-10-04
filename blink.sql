create database IF NOT EXISTS  blink_it;
use blink_it;
/*Orders Table */
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    StoreID INT,
    OrderDate DATETIME,
    DeliveryTime INT,
    TotalAmount DECIMAL(10, 2),
    Status VARCHAR(20)
);
-- customer table 
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50),
    SignUpDate DATE,
    TotalOrders INT,
    LastOrderDate DATE
);
-- stores table 
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    City VARCHAR(50),
    Area VARCHAR(50),
    Category VARCHAR(50)
);
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT
);
CREATE TABLE Delivery (
    OrderID INT,
    DeliveryPersonID INT,
    DeliveryStartTime DATETIME,
    DeliveryEndTime DATETIME,
    DistanceCovered INT
);
-- NOW WE INSERT ITS VALUE 

INSERT INTO Orders (OrderID, CustomerID, StoreID, OrderDate, DeliveryTime, TotalAmount, Status)
VALUES 
(101, 1001, 201, '2024-01-15 08:30:00', 30, 150.00, 'Completed'),
(102, 1002, 202, '2024-01-15 09:00:00', 45, 230.00, 'Completed'),
(103, 1003, 201, '2024-01-15 09:15:00', 60, 500.00, 'Cancelled'),
(104, 1001, 201, '2024-01-15 10:00:00', 20, 100.00, 'Completed'),
(105, 1004, 203, '2024-01-15 11:00:00', 35, 200.00, 'Completed');

INSERT INTO Customers (CustomerID, Name, City, SignUpDate, TotalOrders, LastOrderDate)
VALUES 
(1001, 'John Doe', 'Mumbai', '2023-12-01', 10, '2024-01-15'),
(1002, 'Alice Johnson', 'Bangalore', '2024-01-02', 3, '2024-01-15'),
(1003, 'Bob Smith', 'Pune', '2023-11-25', 2, '2024-01-15'),
(1004, 'Charlie Brown', 'Delhi', '2023-10-10', 1, '2024-01-15'),
(1005, 'Eve Miller', 'Mumbai', '2023-12-20', 5, '2024-01-10');

INSERT INTO Stores (StoreID, City, Area, Category)
VALUES 
(201, 'Mumbai', 'Andheri', 'Groceries'),
(202, 'Bangalore', 'Koramangala', 'Groceries'),
(203, 'Delhi', 'CP', 'Essentials'),
(204, 'Pune', 'Baner', 'Groceries'),
(205, 'Mumbai', 'Borivali', 'Essentials');


INSERT INTO products (ProductID, ProductName, Category, Price)
VALUES
    (301, 'Milk', 'Dairy', 50.00),
    (302, 'Bread', 'Bakery', 30.00),
    (303, 'Apples', 'Fruits', 100.00),
    (304, 'Toothpaste', 'Personal Care', 75.00),
    (305, 'Rice', 'Grains', 120.00);
    
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(101, 301, 2),
(101, 302, 1),
(102, 303, 1),
(102, 304, 3),
(104, 305, 1),
(105, 301, 4),
(105, 303, 2);
INSERT INTO Delivery (OrderID, DeliveryPersonID, DeliveryStartTime, DeliveryEndTime, DistanceCovered) VALUES
(101, 501, '2024-01-15 08:45:00', '2024-01-15 09:15:00', 5),
(102, 502, '2024-01-15 09:10:00', '2024-01-15 09:55:00', 8),
(104, 503, '2024-01-15 10:05:00', '2024-01-15 10:25:00', 3),
(105, 504, '2024-01-15 11:10:00', '2024-01-15 11:45:00', 7);

select* from orders;
select* from delivery
/*-----------------------------------------ASSIGMENT QUESTION ------------------------------------------------
-------------------------------------------OPERATIONAL ANALYSIS --------------------------------------------
 CALCULATE AVERAGAE TIME DELIVERY  
 -- IN EACH CITY*/
 
 select * from customers;
 
 Select tores.City,
    AVG(TIMESTAMPDIFF(MINUTE, Delivery.DeliveryStartTime, Delivery.DeliveryEndTime)) AS Average_time 
FROM livery
JOIN Orders ON Delivery.OrderID = Orders.OrderID
JOIN stores ON Orders.StoreID = Stores.StoreID
GROUP BY stores.City;
    
select customers.Name,
sum(orders.TotalAmount) as Total_Value
from customers 
join Orders on customers.CustomerID=orders.CustomerID
where
orders.Status='Completed'
group by customers.name
order by Total_Value
limit 3;
    
select products.productName, sum(detail.Quantity) as Total_Quantity
from orders  
join stores on orders.StoreID=stores.StoreID
join orderdetails detail  on orders.OrderID=detail.OrderID
join products on detail.ProductID=products.ProductID
where stores.city='Mumbai'
group by products.ProductName
order by Total_Quantity
limit 3;

select count(*) as without_orders
from customers where LastOrderDate<date_sub(current_date(),interval 30 day);



select Stores.StoreID,
sum(orders.TotalAmount)as TotalRevenue from orders
join stores on orders.StoreID=stores.StoreID
where orders.Status='Completed'
group by 
stores.storeID;


Select Customers.Name,
Count(Orders.OrderID) as total_orders
from customers 
join Orders on customers.CustomerID=orders.CustomerID
-- 3 mahine ka gap 
where orders.OrderDate>=date_sub(current_date(),interval 3 month)
group by customers.Name
having
count(orders.OrderID)=1;


-- List of cities with the percentage of single-order customers
SELECT customers.City,
(SUM(CASE WHEN o.total_orders = 1 THEN 1 ELSE 0 END) / COUNT(customers.CustomerID)) * 100 AS single_order_percentage
FROM Customers 
JOIN (SELECT CustomerID, COUNT(OrderID) AS total_orders
FROM Orders 
GROUP BY CustomerID) O ON customers.CustomerID = o.CustomerID
GROUP BY customers.City
ORDER BY single_order_percentage ;



