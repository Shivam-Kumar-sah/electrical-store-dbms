-- ============================================
-- queries.sql : Business insight queries
-- Run this AFTER views_triggers.sql
-- These are the queries you show in your README / demo
-- ============================================

USE store_db;

-- 1. View current stock of ALL materials
SELECT * FROM current_stock;

-- 2. Which materials need reordering right now?
SELECT * FROM low_stock_alert;

-- 3. Area-wise material consumption (which area uses the most material)
SELECT
    a.area_name,
    m.name AS material_name,
    SUM(mu.quantity_used) AS total_used
FROM material_usage mu
JOIN areas a ON mu.fl_id = a.fl_id
JOIN materials m ON mu.material_id = m.material_id
GROUP BY a.area_name, m.name
ORDER BY total_used DESC;

-- 4. Employee-wise usage report (who is consuming the most material)
SELECT
    e.name AS employee_name,
    e.designation,
    COUNT(mu.usage_id) AS total_tasks,
    SUM(mu.quantity_used) AS total_material_used
FROM material_usage mu
JOIN employees e ON mu.employee_id = e.employee_id
GROUP BY e.name, e.designation
ORDER BY total_material_used DESC;

-- 5. Monthly stock inward vs outward comparison
SELECT
    DATE_FORMAT(date_in, '%Y-%m') AS month,
    SUM(quantity) AS stock_received
FROM stock_in
GROUP BY month
UNION ALL
SELECT
    DATE_FORMAT(usage_date, '%Y-%m') AS month,
    SUM(quantity_used) AS stock_used
FROM material_usage
GROUP BY month;

-- 6. Which work_type consumes the most materials overall?
SELECT
    work_type,
    SUM(quantity_used) AS total_used
FROM material_usage
GROUP BY work_type
ORDER BY total_used DESC;

-- 7. Full usage history with all details (JOIN across all tables)
SELECT
    mu.usage_date,
    e.name AS employee_name,
    m.name AS material_name,
    mu.quantity_used,
    m.unit,
    a.area_name,
    mu.work_type
FROM material_usage mu
JOIN employees e ON mu.employee_id = e.employee_id
JOIN materials m ON mu.material_id = m.material_id
JOIN areas a ON mu.fl_id = a.fl_id
ORDER BY mu.usage_date DESC;

-- 8. Test the trigger (this should FAIL with an error - proves data integrity works)
-- Try inserting usage of 999 Poles when only ~5 are available
-- INSERT INTO material_usage(employee_id, material_id, fl_id, quantity_used, usage_date, work_type)
-- VALUES (1, 4, 'JCD055', 999, '2026-07-19', 'Test Overuse');
