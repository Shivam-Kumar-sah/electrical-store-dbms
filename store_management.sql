CREATE DATABASE store_db;
USE store_db;

-- Employees
CREATE TABLE employes(
    employe_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    phone VARCHAR(20),
    Designation VARCHAR(20)
);

INSERT INTO employes(name,Designation,phone) VALUES
("Balram","Lineman","9810236543"),
("Ravi","Lineman","9876543210"),
("Amit","Lineman","9123456780"),
("Suresh","Helper","9012345678"),
("Deepak","Helper","9988776655");

-- Materials
CREATE TABLE materials(
    material_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    unit VARCHAR(10),
    minimum_stock INT
);

INSERT INTO materials(name,unit,minimum_stock) VALUES
('Cable','meter',100),
('Fuse','Nos',20),
('Insulator','Nos',30),
('Pole','Nos',10);

-- Areas
CREATE TABLE areas(
    fl_id VARCHAR(10) PRIMARY KEY,
    area_name VARCHAR(50)
);

INSERT INTO areas(fl_id,area_name) VALUES
('JCD055','Brahmapuri'),
('JCD056','Mohan Nagar'),
('JCD057','Prem Nagar'),
('JCD058','D1B Janakpuri');

-- Stock Inward
CREATE TABLE stock_in(
    stockin_id INT PRIMARY KEY AUTO_INCREMENT,
    material_id INT,
    quantity INT,
    date_in DATE,
    FOREIGN KEY(material_id) REFERENCES materials(material_id)
);

-- Material Usage
CREATE TABLE material_usage(
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    employe_id INT,
    material_id INT,
    fl_id VARCHAR(10),
    quantity_used INT,
    usage_date DATE,
    work_type VARCHAR(50),
    FOREIGN KEY(employe_id) REFERENCES employes(employe_id),
    FOREIGN KEY(material_id) REFERENCES materials(material_id),
    FOREIGN KEY(fl_id) REFERENCES areas(fl_id)
);
