-- ============================================
-- views_triggers.sql : Automation logic
-- Run this AFTER sample_data.sql
-- ============================================

USE store_db;

-- --------------------------------------------
-- VIEW 1: Current available stock per material
-- (Total stock IN minus total usage)
-- --------------------------------------------
CREATE OR REPLACE VIEW current_stock AS
SELECT
    m.material_id,
    m.name AS material_name,
    m.unit,
    m.minimum_stock,
    COALESCE(stock_totals.total_in, 0) AS total_stock_in,
    COALESCE(usage_totals.total_used, 0) AS total_used,
    COALESCE(stock_totals.total_in, 0) - COALESCE(usage_totals.total_used, 0) AS available_qty
FROM materials m
LEFT JOIN (
    SELECT material_id, SUM(quantity) AS total_in
    FROM stock_in
    GROUP BY material_id
) AS stock_totals ON m.material_id = stock_totals.material_id
LEFT JOIN (
    SELECT material_id, SUM(quantity_used) AS total_used
    FROM material_usage
    GROUP BY material_id
) AS usage_totals ON m.material_id = usage_totals.material_id;

-- --------------------------------------------
-- VIEW 2: Low stock alert
-- Materials where available quantity < minimum_stock
-- --------------------------------------------
CREATE OR REPLACE VIEW low_stock_alert AS
SELECT
    material_id,
    material_name,
    unit,
    minimum_stock,
    available_qty,
    (minimum_stock - available_qty) AS shortfall
FROM current_stock
WHERE available_qty < minimum_stock;

-- --------------------------------------------
-- TRIGGER: Prevent recording usage if it would
-- take stock into negative (data integrity)
-- --------------------------------------------
DELIMITER $$

CREATE TRIGGER before_material_usage_insert
BEFORE INSERT ON material_usage
FOR EACH ROW
BEGIN
    DECLARE available INT;

    SELECT COALESCE(SUM(si.quantity),0) - COALESCE(SUM(mu.quantity_used),0)
    INTO available
    FROM materials m
    LEFT JOIN stock_in si ON m.material_id = si.material_id
    LEFT JOIN material_usage mu ON m.material_id = mu.material_id
    WHERE m.material_id = NEW.material_id;

    IF available < NEW.quantity_used THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock: usage exceeds available quantity';
    END IF;
END$$

DELIMITER ;
