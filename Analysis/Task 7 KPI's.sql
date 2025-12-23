-- 7.1 Average Delivery Delay per Region (Start_Location)
SELECT
  r.Start_Location AS region,
  ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)), 2) AS avg_delivery_delay_days,
  COUNT(*) AS deliveries_count
FROM orders o
JOIN routes r ON o.Route_ID = r.Route_ID
WHERE o.Actual_Delivery_Date IS NOT NULL
  AND o.Expected_Delivery_Date IS NOT NULL
GROUP BY r.Start_Location
ORDER BY avg_delivery_delay_days DESC;


-- 7.2 On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100
-- a Overall on-time %
SELECT
  ROUND(
    100.0 * SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END)
    / NULLIF(SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL THEN 1 ELSE 0 END), 0)
  , 2) AS on_time_percentage,
  SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL THEN 1 ELSE 0 END) AS total_delivered
FROM orders o;


-- 7.3 On-time % by region (Start_Location)
SELECT
  r.Start_Location AS region,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL THEN 1 ELSE 0 END) AS total_delivered,
  ROUND(
    100.0 * SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END)
    / NULLIF(SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL THEN 1 ELSE 0 END), 0)
  , 2) AS on_time_percentage
FROM orders o
JOIN routes r ON o.Route_ID = r.Route_ID
GROUP BY r.Start_Location
ORDER BY on_time_percentage DESC;



-- 7.4 Average Traffic Delay per Route
SELECT
  r.Route_ID,
  ROUND(AVG(r.Traffic_Delay_Min), 2) AS avg_traffic_delay_min,
  COUNT(o.Order_ID) AS orders_using_route
FROM routes r
LEFT JOIN orders o ON r.Route_ID = o.Route_ID
GROUP BY r.Route_ID
ORDER BY avg_traffic_delay_min DESC;

-- 7.5 Chart Grapgh purpose On time vs Delayed orders
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END)
        / COUNT(*), 
    2) AS on_time_percentage,

    ROUND(
        100.0 * SUM(CASE WHEN Actual_Delivery_Date > Expected_Delivery_Date THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS delayed_percentage
FROM orders;

