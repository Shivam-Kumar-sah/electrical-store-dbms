Electricity Store Material Tracking System (Mini DBMS Project)

📌 Project Description

This is a mini DBMS project developed using MySQL.
The project simulates a real electricity subdivision store where daily material usage is recorded.

The system keeps record of:

* Which employee used the material
* In which FL (Function Location) area the material was used
* How much quantity was used
* How much stock is currently available in store

The goal of this project is to understand how relational databases work in real-life scenarios instead of only theoretical examples.

---

🗄 Database Tables Used

1. **employees** – stores lineman/helper details
2. **materials** – list of store items (cable, fuse, pole etc.)
3. **areas** – FL ID mapped to area name
4. **stock_in** – material received in store
5. **material_usage** – material issued and used in field work

---

⚙️ Features

* Record inward material entry
* Record field usage of materials
* Area-wise material usage tracking
* Employee work record
* Current stock calculation (Inward − Used)

---

🧠 DBMS Concepts Implemented

* Primary Key & Foreign Key
* Relational Mapping
* Data Normalization
* INNER JOIN
* LEFT JOIN
* Aggregate Functions (SUM, GROUP BY)
* NULL Handling (IFNULL)

---
🛠 Technology Used

* MySQL
* SQL Queries

---

## 🎯 Learning Outcome

Through this project I learned how to:

* Design relational database schema
* Connect multiple tables using foreign keys
* Generate reports using JOIN queries
* Calculate current stock using SQL aggregation

---

👨‍💻 Author

Shivam Kumar
