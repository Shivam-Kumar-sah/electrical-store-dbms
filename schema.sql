-- ============================================
-- Electricity Material Stock Management System
-- schema.sql : Database + Tables
-- ============================================

DROP DATABASE IF EXISTS store_db;
CREATE DATABASE store_db;
USE store_db;

-- ---------- Employees ----------
CREATE TABLE employees(
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    designation VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------- Materials ----------
CREATE TABLE materials(
    material_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    unit VARCHAR(10) NOT NULL,
    minimum_stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------- Areas (Feeder Locations) ----------
CREATE TABLE areas(
    fl_id VARCHAR(10) PRIMARY KEY,
    area_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------- Stock Inward ----------
CREATE TABLE stock_in(
    stockin_id INT PRIMARY KEY AUTO_INCREMENT,
    material_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    supplier_name VARCHAR(50),
    date_in DATE NOT NULL,
    FOREIGN KEY(material_id) REFERENCES materials(material_id)
);

-- ---------- Material Usage ----------
CREATE TABLE material_usage(
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    material_id INT NOT NULL,
    fl_id VARCHAR(10) NOT NULL,
    quantity_used INT NOT NULL CHECK (quantity_used > 0),
    usage_date DATE NOT NULL,
    work_type VARCHAR(50),
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY(material_id) REFERENCES materials(material_id),
    FOREIGN KEY(fl_id) REFERENCES areas(fl_id)
);
