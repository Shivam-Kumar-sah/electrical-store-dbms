"""
Electricity Material Stock Management - CLI Application
----------------------------------------------------------
This is the "application layer" on top of the MySQL database.
A field employee (lineman/helper) can use this WITHOUT knowing any SQL.
They just answer simple questions, and the script safely inserts
data into the database - respecting the trigger that blocks
invalid entries (usage > available stock).
"""

import mysql.connector
from mysql.connector import Error
from datetime import date

# ---------------------------------------------------------
# STEP 1: Database connection settings
# Change these if your MySQL username/password is different
# ---------------------------------------------------------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "Shiv@1911",   # <-- change this
    "database": "store_db"
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


def list_employees(cursor):
    cursor.execute("SELECT employee_id, name, designation FROM employees")
    return cursor.fetchall()


def list_materials(cursor):
    cursor.execute("SELECT material_id, name, unit FROM materials")
    return cursor.fetchall()


def list_areas(cursor):
    cursor.execute("SELECT fl_id, area_name FROM areas")
    return cursor.fetchall()


def print_menu():
    print("\n" + "=" * 50)
    print("  ELECTRICITY STOCK MANAGEMENT - MAIN MENU")
    print("=" * 50)
    print("1. Record today's material usage")
    print("2. Record new stock arrival (stock-in)")
    print("3. View low stock alert")
    print("4. View current stock of all materials")
    print("5. Exit")
    print("=" * 50)


def choose_from_list(items, label_fn, prompt):
    """Show a numbered list and let the user pick by number - no typing IDs."""
    for i, item in enumerate(items, start=1):
        print(f"  {i}. {label_fn(item)}")
    while True:
        choice = input(prompt).strip()
        if choice.isdigit() and 1 <= int(choice) <= len(items):
            return items[int(choice) - 1]
        print("  Invalid choice, try again.")


def record_usage(conn):
    cursor = conn.cursor()

    print("\n--- Record Material Usage ---")

    employees = list_employees(cursor)
    emp = choose_from_list(
        employees, lambda e: f"{e[1]} ({e[2]})", "Select employee number: "
    )

    materials = list_materials(cursor)
    mat = choose_from_list(
        materials, lambda m: f"{m[1]} ({m[2]})", "Select material number: "
    )

    areas = list_areas(cursor)
    area = choose_from_list(
        areas, lambda a: f"{a[1]} ({a[0]})", "Select area number: "
    )

    qty = input(f"Quantity used ({mat[2]}): ").strip()
    work_type = input("Work type (e.g. Fuse Replacement, New Connection): ").strip()
    usage_date = input(f"Date [press Enter for today = {date.today()}]: ").strip()
    if not usage_date:
        usage_date = str(date.today())

    try:
        cursor.execute(
            """INSERT INTO material_usage
               (employee_id, material_id, fl_id, quantity_used, usage_date, work_type)
               VALUES (%s, %s, %s, %s, %s, %s)""",
            (emp[0], mat[0], area[0], int(qty), usage_date, work_type)
        )
        conn.commit()
        print(f"\n✅ Saved! {emp[1]} used {qty} {mat[2]} of {mat[1]} at {area[1]}.")
    except Error as e:
        # This is where the database TRIGGER protects us automatically
        if "Insufficient stock" in str(e):
            print(f"\n❌ Cannot save: not enough {mat[1]} in stock right now.")
        else:
            print(f"\n❌ Error: {e}")
    finally:
        cursor.close()


def record_stock_in(conn):
    cursor = conn.cursor()

    print("\n--- Record New Stock Arrival ---")

    materials = list_materials(cursor)
    mat = choose_from_list(
        materials, lambda m: f"{m[1]} ({m[2]})", "Select material number: "
    )

    qty = input(f"Quantity received ({mat[2]}): ").strip()
    supplier = input("Supplier name: ").strip()
    date_in = input(f"Date [press Enter for today = {date.today()}]: ").strip()
    if not date_in:
        date_in = str(date.today())

    try:
        cursor.execute(
            """INSERT INTO stock_in (material_id, quantity, supplier_name, date_in)
               VALUES (%s, %s, %s, %s)""",
            (mat[0], int(qty), supplier, date_in)
        )
        conn.commit()
        print(f"\n✅ Saved! {qty} {mat[2]} of {mat[1]} added to stock.")
    except Error as e:
        print(f"\n❌ Error: {e}")
    finally:
        cursor.close()


def view_low_stock(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM low_stock_alert")
    rows = cursor.fetchall()
    cursor.close()

    print("\n--- LOW STOCK ALERT ---")
    if not rows:
        print("✅ All materials are above minimum stock level.")
        return

    print(f"{'Material':<28}{'Unit':<8}{'Min':<6}{'Available':<10}{'Shortfall'}")
    print("-" * 65)
    for r in rows:
        # r = (material_id, material_name, unit, minimum_stock, available_qty, shortfall)
        print(f"{r[1]:<28}{r[2]:<8}{r[3]:<6}{r[4]:<10}{r[5]}")


def view_current_stock(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT material_name, unit, available_qty FROM current_stock")
    rows = cursor.fetchall()
    cursor.close()

    print("\n--- CURRENT STOCK (ALL MATERIALS) ---")
    print(f"{'Material':<28}{'Unit':<8}{'Available'}")
    print("-" * 45)
    for r in rows:
        print(f"{r[0]:<28}{r[1]:<8}{r[2]}")


def main():
    try:
        conn = get_connection()
    except Error as e:
        print(f"❌ Could not connect to database: {e}")
        print("Check your DB_CONFIG password at the top of this file.")
        return

    while True:
        print_menu()
        choice = input("Enter choice (1-5): ").strip()

        if choice == "1":
            record_usage(conn)
        elif choice == "2":
            record_stock_in(conn)
        elif choice == "3":
            view_low_stock(conn)
        elif choice == "4":
            view_current_stock(conn)
        elif choice == "5":
            print("Goodbye!")
            break
        else:
            print("Invalid choice, please enter 1-5.")

    conn.close()


if __name__ == "__main__":
    main()
