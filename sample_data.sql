-- ============================================
-- sample_data.sql : Dummy data for testing
-- Run this AFTER schema.sql
-- ============================================

USE store_db;

-- ---------- Employees ----------
INSERT INTO employees(name, designation, phone) VALUES
('Balram','Lineman','9810236543'),
('Ravi','Lineman','9876543210'),
('Amit','Lineman','9123456780'),
('Suresh','Helper','9012345678'),
('Deepak','Helper','9988776655');

-- ---------- Materials ----------
INSERT INTO materials(name, unit, minimum_stock) VALUES
('Cable','meter',100),
('Fuse','Nos',20),
('Insulator','Nos',30),
('Pole','Nos',10);

-- ---------- Areas ----------
INSERT INTO areas(fl_id, area_name) VALUES
('JCD055','Brahmapuri'),
('JCD056','Mohan Nagar'),
('JCD057','Prem Nagar'),
('JCD058','D1B Janakpuri');

-- ---------- Stock Inward (jo pehle missing tha) ----------
INSERT INTO stock_in(material_id, quantity, supplier_name, date_in) VALUES
(1, 500, 'Havells Cables Pvt Ltd', '2026-06-01'),
(2, 100, 'Bajaj Electricals', '2026-06-02'),
(3, 150, 'Modern Insulators Ltd', '2026-06-03'),
(4, 40, 'UP Pole Industries', '2026-06-05'),
(1, 200, 'Havells Cables Pvt Ltd', '2026-06-20'),
(2, 30, 'Bajaj Electricals', '2026-06-25');

-- ---------- Material Usage (jo pehle missing tha) ----------
INSERT INTO material_usage(employee_id, material_id, fl_id, quantity_used, usage_date, work_type) VALUES
(1, 1, 'JCD055', 120, '2026-06-10', 'New Connection'),
(2, 2, 'JCD056', 15, '2026-06-11', 'Fuse Replacement'),
(1, 3, 'JCD057', 40, '2026-06-12', 'Insulator Repair'),
(3, 1, 'JCD058', 300, '2026-06-15', 'Line Extension'),
(4, 4, 'JCD055', 35, '2026-06-18', 'Pole Installation'),
(2, 2, 'JCD056', 90, '2026-06-22', 'Fuse Replacement'),
(3, 3, 'JCD057', 100, '2026-06-24', 'Insulator Repair');
