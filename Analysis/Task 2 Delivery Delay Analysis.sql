
UPDATE orders
SET delivery_delay_days = GREATEST(0, DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date));

-- 2.1 Calculate delivery delay (in days) for each order
SELECT Order_ID, Order_Date, Expected_Delivery_Date, Actual_Delivery_Date, delivery_delay_days
FROM orders
WHERE delivery_delay_days > 0
ORDER BY delivery_delay_days DESC;

-- 2.2 Find Top 10 delayed routes based on average delay days
SELECT Order_ID, Route_ID, Warehouse_ID, Agent_ID,delivery_delay_days
FROM orders
ORDER BY delivery_delay_days DESC
LIMIT 10;

-- 2.3 Use window functions to rank all orders by delay within each warehouse.
SELECT
    Warehouse_ID,
    Order_ID,
    DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS delay_days,
    RANK() OVER (
        PARTITION BY Warehouse_ID
        ORDER BY DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) DESC
    ) AS delay_rank
FROM orders;