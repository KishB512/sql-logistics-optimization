# 🚚 Logistics Optimization for Delivery Routes
SQL-Based Supply Chain & Operations Analytics

<p align="left">
  <img src="https://img.shields.io/badge/Database-MySQL-blue" />
  <img src="https://img.shields.io/badge/Domain-Logistics%20Analytics-green" />
  <img src="https://img.shields.io/badge/Level-Intermediate-orange" />
</p>

## 📌 Project Overview

This project focuses on analyzing logistics and delivery operations data for a large-scale
e-commerce organization to identify delivery delays, route inefficiencies, and operational
bottlenecks.

Using MySQL, the project extracts actionable insights to optimize delivery routes, improve
warehouse and agent performance, and enhance overall shipment efficiency.

## 🎯 Business Objectives

Identify root causes of delivery delays across routes and regions  

Analyze route efficiency and traffic impact on delivery timelines  

Evaluate warehouse processing performance and bottlenecks  

Assess delivery agent efficiency and on-time delivery rates  

Support data-driven decisions for logistics optimization  

## 🛠 Tools & Technical Skills

MySQL  

SQL Joins (INNER, LEFT, RIGHT)  

Window Functions (RANK, DENSE_RANK, ROW_NUMBER)  

Common Table Expressions (CTEs)  

Subqueries & Aggregations  

Date & Time Functions  

KPI Calculation & Performance Analysis  

## 📂 Dataset Overview

The analysis uses relational logistics datasets, including:

Orders data (order dates, delivery dates, status, order value)  

Routes data (distance, travel time, traffic delays)  

Warehouse data (processing capacity and processing time)  

Delivery agent performance metrics  

Shipment tracking and checkpoint data  

## 🔍 Analytical Approach

1️⃣ Data Cleaning & Preparation  

Identified and removed duplicate order records  

Handled missing traffic delay values using route-level averages  

Standardized date formats using SQL functions  

Flagged logically inconsistent delivery records  

2️⃣ Delivery Delay Analysis  

Calculated delivery delays at order level  

Identified top delayed routes using aggregations  

Applied window functions to rank delays within warehouses  

3️⃣ Route Optimization Insights  

Calculated average delivery time and traffic delay per route  

Computed distance-to-time efficiency ratios  

Identified inefficient routes and high-delay shipment routes  

4️⃣ Warehouse Performance Evaluation  

Analyzed average processing time across warehouses  

Identified bottleneck warehouses using CTEs  

Ranked warehouses based on on-time delivery percentage  

5️⃣ Delivery Agent Performance Analysis  

Ranked agents by on-time delivery performance per route  

Identified low-performing agents  

Compared top and bottom agents using subqueries  

6️⃣ Shipment Tracking & KPI Analysis  

Analyzed shipment checkpoints and delay reasons  

Calculated key KPIs such as:
- Average delivery delay per region  
- On-time delivery percentage  
- Average traffic delay per route  

## 📊 Key Insights

Specific routes showed consistently high delays due to traffic and inefficiency  

Certain warehouses emerged as processing bottlenecks  

Agent performance varied significantly across routes  

Optimizing route selection and workload distribution can improve delivery SLAs  
