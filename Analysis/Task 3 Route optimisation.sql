-- 3.1 Average delivery time per route (days)
SELECT
  o.Route_ID,
  ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)), 2) AS avg_delivery_time_days,
  COUNT(*) AS orders_count_with_actual
FROM orders o
WHERE o.Actual_Delivery_Date IS NOT NULL
GROUP BY o.Route_ID
ORDER BY avg_delivery_time_days DESC;


-- 3.2 Average traffic delay (route-level)
SELECT
  r.Route_ID,
  r.Traffic_Delay_Min AS avg_traffic_delay_min
FROM routes r
ORDER BY r.Traffic_Delay_Min DESC;


-- 3.3 Efficiency ratio per route (km per minute)
SELECT
  r.Route_ID,
  r.Distance_KM,
  r.Average_Travel_Time_Min,
  -- guard against divide-by-zero
  ROUND(r.Distance_KM / NULLIF(r.Average_Travel_Time_Min, 0), 4) AS km_per_minute_efficiency
FROM routes r
ORDER BY km_per_minute_efficiency ASC; -- ascending: worst (lowest) first



-- 3.4 Worst 3 routes by efficiency (lowest km/min)
SELECT
  r.Route_ID,
  r.Distance_KM,
  r.Average_Travel_Time_Min,
  ROUND(r.Distance_KM / NULLIF(r.Average_Travel_Time_Min,0),4) AS km_per_minute_efficiency
FROM routes r
ORDER BY km_per_minute_efficiency ASC
LIMIT 3;



-- 3.5 Routes with >20% delayed shipments
SELECT
  o.Route_ID,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN COALESCE(o.delivery_delay_days, DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)) > 0 THEN 1 ELSE 0 END) AS delayed_count,
  ROUND(100 * SUM(CASE WHEN COALESCE(o.delivery_delay_days, DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)) > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS delayed_pct
FROM orders o
GROUP BY o.Route_ID
HAVING delayed_pct > 20
ORDER BY delayed_pct DESC, delayed_count DESC;

-- 3.6 route for reconsideration to optimise it for better efficiency
SELECT
    r.Route_ID,
    ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)), 2) AS avg_delay_days,
    ROUND(AVG(r.Traffic_Delay_Min), 2) AS avg_traffic_delay,
    ROUND(r.Distance_KM / NULLIF(r.Average_Travel_Time_Min, 0), 4) AS efficiency_ratio,
    COUNT(o.Order_ID) AS total_orders
FROM routes r
LEFT JOIN orders o ON r.Route_ID = o.Route_ID
GROUP BY r.Route_ID, r.Distance_KM, r.Average_Travel_Time_Min
ORDER BY avg_delay_days DESC;


