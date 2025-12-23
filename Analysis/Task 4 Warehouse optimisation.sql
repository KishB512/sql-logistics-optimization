-- 4.1 Top 3 warehouses by average processing time (highest first)
SELECT
  Warehouse_ID,
  Warehouse_Name,
  ROUND(AVG(Average_Processing_Time_Min),2) AS avg_processing_time_min
FROM warehouses
GROUP BY Warehouse_ID, Warehouse_Name
ORDER BY avg_processing_time_min DESC
LIMIT 3;

-- 4.2 Total vs delayed shipments for each warehouse
-- delayed = Actual_Delivery_Date > Expected_Delivery_Date
SELECT
  o.Warehouse_ID,
  w.Warehouse_Name,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN o.Actual_Delivery_Date > o.Expected_Delivery_Date THEN 1 ELSE 0 END) AS delayed_shipments,
  ROUND(100 * SUM(CASE WHEN o.Actual_Delivery_Date > o.Expected_Delivery_Date THEN 1 ELSE 0 END) / COUNT(*), 2) AS delayed_pct
FROM orders o
LEFT JOIN warehouses w ON o.Warehouse_ID = w.Warehouse_ID
GROUP BY o.Warehouse_ID, w.Warehouse_Name
ORDER BY delayed_pct DESC, delayed_shipments DESC;


-- 4.3 CTEs: Find bottleneck warehouses where processing time > global average
WITH global_avg AS (
  SELECT ROUND(AVG(Average_Processing_Time_Min),2) AS global_avg_proc_min
  FROM warehouses
),
wh_stats AS (
  SELECT
    Warehouse_ID,
    Warehouse_Name,
    ROUND(AVG(Average_Processing_Time_Min),2) AS avg_proc_min,
    COUNT(*) AS warehouse_count_rows
  FROM warehouses
  GROUP BY Warehouse_ID, Warehouse_Name
)
SELECT
  s.Warehouse_ID,
  s.Warehouse_Name,
  s.avg_proc_min,
  g.global_avg_proc_min,
  ROUND(100 * (s.avg_proc_min - g.global_avg_proc_min) / NULLIF(g.global_avg_proc_min,0),2) AS pct_above_global
FROM wh_stats s
CROSS JOIN global_avg g
WHERE s.avg_proc_min > g.global_avg_proc_min
ORDER BY pct_above_global DESC;



-- 4.4 Rank warehouses by on-time delivery percentage (best first)
-- on-time = Actual_Delivery_Date <= Expected_Delivery_Date 
SELECT
  Warehouse_ID,
  Warehouse_Name,
  total_delivered,
  on_time_count,
  ROUND(100 * on_time_count / NULLIF(total_delivered,0),2) AS on_time_pct,
  RANK() OVER (ORDER BY ROUND(100 * on_time_count / NULLIF(total_delivered,0),2) DESC) AS on_time_rank
FROM (
  SELECT
    o.Warehouse_ID,
    w.Warehouse_Name,
    SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL THEN 1 ELSE 0 END) AS total_delivered,
    SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END) AS on_time_count
  FROM orders o
  LEFT JOIN warehouses w ON o.Warehouse_ID = w.Warehouse_ID
  GROUP BY o.Warehouse_ID, w.Warehouse_Name
) t
ORDER BY on_time_pct DESC;

-- 4.5 Graph of avg processing time for each warehouse 
SELECT
  Warehouse_ID,
  ROUND(AVG(Average_Processing_Time_Min),2) AS avg_processing_time
FROM warehouses
GROUP BY Warehouse_ID
ORDER BY avg_processing_time DESC;


