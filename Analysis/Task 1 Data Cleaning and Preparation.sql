-- 1.1 Checking duplicate Order_IDs
SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING cnt > 1;

-- 1.2 Checking NULLs in critical orders columns
SELECT 
  SUM(Order_ID IS NULL) AS order_id_nulls,
  SUM(Warehouse_ID IS NULL) AS warehouse_nulls,
  SUM(Route_ID IS NULL) AS route_nulls,
  SUM(Agent_ID IS NULL) AS agent_nulls,
  SUM(Order_Date IS NULL) AS order_date_nulls,
  SUM(Expected_Delivery_Date IS NULL) AS expected_date_nulls,
  SUM(Actual_Delivery_Date IS NULL) AS actual_date_nulls,
  SUM(Order_Value IS NULL) AS order_value_nulls
FROM orders;


-- 1.3 Ensuring date columns are stored as DATE (convert if they were text)
UPDATE orders
SET 
    Order_Date = STR_TO_DATE(Order_Date, '%Y-%m-%d'),
    Expected_Delivery_Date = STR_TO_DATE(Expected_Delivery_Date, '%Y-%m-%d'),
    Actual_Delivery_Date = STR_TO_DATE(Actual_Delivery_Date, '%Y-%m-%d');

UPDATE orders
SET 
    delivery_delay_days = DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date),
    delivery_time_days = DATEDIFF(Actual_Delivery_Date, Order_Date)
WHERE Actual_Delivery_Date IS NOT NULL;


-- 1.4 Flaging records where Actual_Delivery_Date is before Order_Date
SELECT Order_ID, Order_Date, Actual_Delivery_Date
FROM orders
WHERE Actual_Delivery_Date < Order_Date;

ALTER TABLE orders
  ADD COLUMN delivery_delay_days INT DEFAULT NULL,
  ADD COLUMN delivery_time_days INT DEFAULT NULL;