-- 6.1 Last checkpoint (most recent) per order
WITH last_ck AS (
  SELECT
    Tracking_ID,
    Order_ID,
    Checkpoint,
    Checkpoint_Time,
    Delay_Reason,
    Delay_Minutes,
    ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Checkpoint_Time DESC) AS rn
  FROM shipmenttracking
)
SELECT
  Order_ID,
  Tracking_ID,
  Checkpoint,
  Checkpoint_Time,
  Delay_Reason,
  Delay_Minutes
FROM last_ck
WHERE rn = 1
ORDER BY Checkpoint_Time DESC;



-- 6.2 Top delay reasons — safe with ONLY_FULL_GROUP_BY
SELECT
  cleaned_reason AS delay_reason,
  COUNT(*) AS reason_count
FROM (
  SELECT LOWER(TRIM(Delay_Reason)) AS cleaned_reason
  FROM shipmenttracking
  WHERE Delay_Reason IS NOT NULL
) AS t
WHERE cleaned_reason NOT IN ('', 'none', 'na', 'n/a', 'null')
GROUP BY cleaned_reason
ORDER BY reason_count DESC
LIMIT 10;



-- 6.3 Orders with >2 delayed checkpoints (Delay_Minutes > 0)
SELECT
  Order_ID,
  COUNT(*) AS delayed_checkpoints_count,
  SUM(COALESCE(Delay_Minutes,0)) AS total_delay_minutes
FROM shipmenttracking
WHERE Delay_Minutes IS NOT NULL AND Delay_Minutes > 0
GROUP BY Order_ID
HAVING delayed_checkpoints_count > 2
ORDER BY delayed_checkpoints_count DESC, total_delay_minutes DESC;

