-- 5.1 Rank agents (per route) by on-time delivery percentage
WITH agent_route_stats AS (
  SELECT
    o.Route_ID,
    o.Agent_ID,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END) AS on_time_orders,
    ROUND(100 * SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
  FROM orders o
  GROUP BY o.Route_ID, o.Agent_ID
)
SELECT
  Route_ID,
  Agent_ID,
  total_orders,
  on_time_orders,
  on_time_pct,
  RANK() OVER (PARTITION BY Route_ID ORDER BY on_time_pct DESC) AS route_agent_rank
FROM agent_route_stats
ORDER BY Route_ID, route_agent_rank;



-- 5.2 Find agents with on-time % < 80%
SELECT
  Agent_ID,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN Actual_Delivery_Date IS NOT NULL AND Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) AS on_time_orders,
  ROUND(100 * SUM(CASE WHEN Actual_Delivery_Date IS NOT NULL AND Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
FROM orders
GROUP BY Agent_ID
HAVING on_time_pct < 80
ORDER BY on_time_pct ASC;



-- 5.3 Compare average "route speed" of top 5 vs bottom 5 agents 
WITH agent_speed AS (
  SELECT
    o.Agent_ID,
    ROUND(AVG(CASE WHEN r.Average_Travel_Time_Min IS NULL OR r.Average_Travel_Time_Min = 0 THEN NULL ELSE r.Distance_KM / r.Average_Travel_Time_Min END), 4) AS avg_km_per_min,
    ROUND(100 * SUM(CASE WHEN o.Actual_Delivery_Date IS NOT NULL AND o.Actual_Delivery_Date <= o.Expected_Delivery_Date THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
  FROM orders o
  LEFT JOIN routes r ON o.Route_ID = r.Route_ID
  GROUP BY o.Agent_ID
),
ranked_agents AS (
  SELECT
    Agent_ID,
    avg_km_per_min,
    on_time_pct,
    ROW_NUMBER() OVER (ORDER BY on_time_pct DESC) AS rn_desc,
    ROW_NUMBER() OVER (ORDER BY on_time_pct ASC)  AS rn_asc
  FROM agent_speed
)
SELECT
  (SELECT ROUND(AVG(avg_km_per_min),4) FROM ranked_agents WHERE rn_desc <= 5) AS avg_speed_top5_agents,
  (SELECT ROUND(AVG(avg_km_per_min),4) FROM ranked_agents WHERE rn_asc <= 5)  AS avg_speed_bottom5_agents,
  (SELECT COUNT(*) FROM ranked_agents WHERE avg_km_per_min IS NULL) AS agents_with_no_speed_data;
