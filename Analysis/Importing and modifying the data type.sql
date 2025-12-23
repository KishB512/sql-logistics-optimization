USE flipkart_logistic_project;

ALTER TABLE deliveryagents
MODIFY Agent_ID VARCHAR(20),
MODIFY Agent_Name VARCHAR(100),
MODIFY Route_ID VARCHAR(20),
MODIFY Avg_Speed_KMPH DOUBLE,
MODIFY On_Time_Delivery_Percentage DOUBLE,
MODIFY Experience_Years DOUBLE;

ALTER TABLE orders
MODIFY Order_ID VARCHAR(50),
MODIFY Warehouse_ID VARCHAR(20),
MODIFY Route_ID VARCHAR(20),
MODIFY Agent_ID VARCHAR(20),
MODIFY Status VARCHAR(50),
MODIFY Order_Date DATE,
MODIFY Expected_Delivery_Date DATE,
MODIFY Actual_Delivery_Date DATE,
MODIFY Order_Value DOUBLE;

ALTER TABLE routes
MODIFY Route_ID VARCHAR(20),
MODIFY Start_Location VARCHAR(100),
MODIFY End_Location VARCHAR(100),
MODIFY Distance_KM INT,
MODIFY Average_Travel_Time_Min INT,
MODIFY Traffic_Delay_Min INT;

ALTER TABLE shipmenttracking
MODIFY Tracking_ID VARCHAR(30),
MODIFY Order_ID VARCHAR(50),
MODIFY Checkpoint VARCHAR(150),
MODIFY Checkpoint_Time DATETIME,
MODIFY Delay_Reason VARCHAR(100),
MODIFY Delay_Minutes INT;

ALTER TABLE warehouses
MODIFY Warehouse_ID VARCHAR(20),
MODIFY Warehouse_Name VARCHAR(150),
MODIFY City VARCHAR(100),
MODIFY Processing_Capacity INT,
MODIFY Average_Processing_Time_Min INT;

