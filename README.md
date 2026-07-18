# Electricity Material Stock Management System

A relational database system to track material inventory, usage, and stock movement
across operational areas for an electricity distribution utility — inspired by
real-world inventory challenges observed during a data internship at BSES Rajdhani
Power Limited.

## Problem Statement
Field teams (linemen, helpers) consume materials like cables, fuses, insulators,
and poles across different areas daily. Without a tracking system, it's hard to know:
- What stock is currently available
- Which materials are running low and need reordering
- Which area/employee is consuming the most material
- Whether recorded usage is even physically possible (data integrity)

This project solves that with a normalized MySQL schema, automated views, a
trigger for data integrity, and reporting queries.

## Tech Stack
- MySQL 8.0
- SQL (DDL, DML, Views, Triggers)

## Database Design
5 tables, 4 foreign-key relationships:

- `employees` — field staff (linemen, helpers)
- `materials` — inventory items with minimum stock threshold
- `areas` — feeder locations (fl_id based)
- `stock_in` — incoming stock records
- `material_usage` — material consumed per employee, per area, per task

*(Add your ER diagram image here — draw.io or MySQL Workbench reverse engineer)*

## Key Features
- **`current_stock` view** — real-time available quantity per material
  (total stock in − total used), no manual calculation needed
- **`low_stock_alert` view** — auto-flags materials below minimum threshold
- **Trigger (`before_material_usage_insert`)** — blocks any usage entry that
  would push stock negative, enforcing data integrity at the database level
- **7 reporting queries** — area-wise consumption, employee performance,
  monthly trends, work-type analysis (see `queries.sql`)

## How to Run
```bash
mysql -u root -p < schema.sql
mysql -u root -p < sample_data.sql
mysql -u root -p < views_triggers.sql
mysql -u root -p < queries.sql
```
Or run each file in order inside MySQL Workbench.

## Sample Output
*(Paste a screenshot here of `SELECT * FROM low_stock_alert;` output — this is
the single most impressive query to screenshot for your README)*

## Future Improvements
- Python/Streamlit dashboard on top of this schema
- REST API layer for stock-in and usage entry
- Email/SMS alert automation on low stock

## Author
Shivam Kumar Sah — [GitHub](https://github.com/Shivam-Kumar-sah)
