# SQL_database
Project title: Supply Chain Database

Short project description:
This database schema is designed to manage a retail supply chain system, encompassing countries, suppliers, products, retailers, orders, and order details.
  •	COUNTRY Table: Stores country names and unique country codes.
  •	SUPPLIERS Table: Contains supplier details including their ID, name, and registered country.
  •	PRODUCTS Table: Holds information about products, including their category, name, unit price, origin country, and associated supplier.
  •	RETAILERS Table: Keeps retailer information such as store ID, name, country, and channel level.
  •	ORDERS Table: Records orders placed by retailers, including order date, store ID, and total order amount.
  •	ORDER_DETAILS Table: Details each order's items, including product ID, unit price, quantity, and total amount.
Relationships are established through foreign keys connecting suppliers, products, and retailers to their respective countries, and linking orders and products to order details.
A trigger named UpdateOrderAmount ensures that the total order amount in the ORDERS table is automatically updated whenever changes occur in the ORDER_DETAILS table. 
For further information and database queries, please refer to the “project description” file.
