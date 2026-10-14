-- SMARTSTOCK DBMS SYLLABUS QUERY REFERENCE
-- PostgreSQL / Supabase syntax. Every section uses the real SmartStock schema.
-- Read-only examples are safe to run. DML/function examples are wrapped in ROLLBACK.

/* ================================================================
   1. DDL AND TABLE CONSTRAINTS
   ================================================================ */
-- List the actual tables used by the project.
select table_schema, table_name
from information_schema.tables
where table_schema = 'public'
  and table_name in ('categories','suppliers','products','purchases','purchase_items','customers','sales','sale_items','stock_movements')
order by table_name;

-- Show primary keys, foreign keys, UNIQUE, CHECK and other table constraints.
select table_name, constraint_name, constraint_type
from information_schema.table_constraints
where table_schema = 'public'
  and table_name in ('categories','suppliers','products','purchases','purchase_items','customers','sales','sale_items','stock_movements')
order by table_name, constraint_type, constraint_name;

-- Show which real columns are NOT NULL, have DEFAULT values, or are identity columns.
select table_name, column_name, data_type, is_nullable, column_default, is_identity
from information_schema.columns
where table_schema = 'public'
  and table_name in ('categories','suppliers','products','purchases','purchase_items','customers','sales','sale_items','stock_movements')
order by table_name, ordinal_position;

-- Show CHECK and FOREIGN KEY definitions exactly as PostgreSQL stores them.
select conrelid::regclass as table_name, conname as constraint_name, pg_get_constraintdef(oid) as definition
from pg_constraint
where connamespace = 'public'::regnamespace
  and contype in ('c','f','p','u')
order by table_name, constraint_name;

-- The executable DDL definitions are in supabase/schema.sql and the existing-database
-- customer migration is supabase/migrations/20261014_add_customers.sql.

/* ================================================================
   2. DML: INSERT, UPDATE AND SAFE DELETE
   ================================================================ */
-- INSERT / UPDATE / DELETE demonstration. The transaction is rolled back, so no data remains changed.
begin;
insert into public.customers(customer_code, customer_name, email, phone, address, city)
select 'CUST-900', 'DBMS Demo Customer', 'dbms.demo.customer@smartstock.demo', '+91 90000 90000', '900 Query Lane', 'Bengaluru'
where not exists (select 1 from public.customers where customer_code = 'CUST-900');

update public.customers
set phone = '+91 90000 90001'
where customer_code = 'CUST-900'
  and email = 'dbms.demo.customer@smartstock.demo';

-- The identifying conditions make this DELETE safe and narrowly scoped.
delete from public.customers
where customer_code = 'CUST-900'
  and email = 'dbms.demo.customer@smartstock.demo';
rollback;

-- Read-only UPDATE preview: inspect rows that would be affected before changing prices.
select product_id, product_name, sku, unit_price, round(unit_price * 1.05, 2) as proposed_price
from public.products
where sku = 'ST-003';

/* ================================================================
   3. BASIC SELECT, WHERE, ORDER BY, DISTINCT AND FILTERING
   ================================================================ */
-- Basic SELECT with explicit columns.
select product_id, product_name, sku, unit_price, stock_qty, reorder_level
from public.products;

-- WHERE filters for low stock and case-insensitive product search.
select product_name, sku, stock_qty, reorder_level
from public.products
where stock_qty <= reorder_level
  and (product_name ilike '%pen%' or sku ilike '%pen%');

-- ORDER BY shows the lowest-stock products first.
select product_name, stock_qty, unit_price
from public.products
order by stock_qty asc, product_name asc;

-- DISTINCT returns each city represented in the customer directory.
select distinct city
from public.customers
where city <> ''
order by city;

-- PostgreSQL filtering with IN and BETWEEN.
select product_name, unit_price
from public.products
where category_id in (select category_id from public.categories where category_name in ('Stationery','Electronics'))
  and unit_price between 10 and 400
order by unit_price desc;

/* ================================================================
   4. AGGREGATE FUNCTIONS: COUNT, SUM, AVG, MIN, MAX, ROUND
   ================================================================ */
-- One-row inventory summary using all requested aggregate functions.
select count(*) as product_count,
       sum(stock_qty) as total_units,
       round(avg(unit_price), 2) as average_unit_price,
       min(unit_price) as minimum_price,
       max(unit_price) as maximum_price,
       round(sum(stock_qty * unit_price), 2) as inventory_value
from public.products;

-- Customer and transaction counts are useful DBMS report metrics.
select (select count(*) from public.customers) as customer_count,
       (select count(*) from public.sales) as sale_count,
       (select count(*) from public.purchases) as purchase_count;

/* ================================================================
   5. GROUP BY AND HAVING
   ================================================================ */
-- Category-wise stock and inventory value, including categories with no products.
select c.category_name,
       count(p.product_id) as product_count,
       coalesce(sum(p.stock_qty), 0) as units_in_stock,
       round(coalesce(sum(p.stock_qty * p.unit_price), 0), 2) as category_inventory_value
from public.categories c
left join public.products p on p.category_id = c.category_id
group by c.category_id, c.category_name
order by units_in_stock desc;

-- HAVING keeps only categories with at least one product and more than 10 units.
select c.category_name, count(p.product_id) as product_count, sum(p.stock_qty) as units_in_stock
from public.categories c
join public.products p on p.category_id = c.category_id
group by c.category_id, c.category_name
having count(p.product_id) > 0 and sum(p.stock_qty) > 10
order by units_in_stock desc;

/* ================================================================
   6. STRING FUNCTIONS: UPPER, LOWER, LENGTH, CONCAT
   ================================================================ */
-- Format product and customer labels using PostgreSQL string functions.
select product_name,
       upper(sku) as sku_upper,
       lower(product_name) as product_lower,
       length(product_name) as name_length,
       concat(product_name, ' / ', sku) as product_label
from public.products
order by product_name;

select customer_code,
       upper(customer_name) as customer_upper,
       lower(email) as email_lower,
       length(customer_name) as name_length,
       concat(customer_name, ' — ', city) as customer_label
from public.customers
order by customer_name;

/* ================================================================
   7. NUMERIC AND DATE/TIME FUNCTIONS
   ================================================================ */
-- Numeric expressions calculate retail value and a rounded 5% price scenario.
select product_name, unit_price,
       round(unit_price * 1.05, 2) as price_plus_five_percent,
       round(stock_qty * unit_price, 2) as stock_value,
       abs(stock_qty - reorder_level) as distance_from_reorder_level
from public.products
order by stock_value desc;

-- Date/time functions inspect transaction dates and age in days.
select sale_id,
       sale_date,
       sale_date::date as sale_day,
       extract(year from sale_date) as sale_year,
       extract(month from sale_date) as sale_month,
       current_date - sale_date::date as days_since_sale
from public.sales
order by sale_date desc;

select purchase_id,
       purchase_date,
       to_char(purchase_date, 'YYYY-MM-DD HH24:MI') as formatted_purchase_time
from public.purchases
order by purchase_date desc;

/* ================================================================
   8. INNER JOIN AND LEFT JOIN
   ================================================================ */
-- INNER JOIN: each product with its category and supplier.
select p.product_name, p.sku, c.category_name, s.supplier_name, p.stock_qty
from public.products p
inner join public.categories c on c.category_id = p.category_id
inner join public.suppliers s on s.supplier_id = p.supplier_id
order by p.product_name;

-- INNER JOIN across purchases, purchase_items, products and suppliers.
select pu.purchase_id, pu.invoice_no, pu.purchase_date, s.supplier_name,
       p.product_name, pi.quantity, pi.cost_price,
       round(pi.quantity * pi.cost_price, 2) as line_cost
from public.purchases pu
inner join public.suppliers s on s.supplier_id = pu.supplier_id
inner join public.purchase_items pi on pi.purchase_id = pu.purchase_id
inner join public.products p on p.product_id = pi.product_id
order by pu.purchase_date desc;

-- LEFT JOIN keeps customers with no sales in the result.
select c.customer_code, c.customer_name, c.city,
       sa.sale_id, sa.sale_date, sa.payment_method,
       si.quantity, si.selling_price, p.product_name
from public.customers c
left join public.sales sa on sa.customer_id = c.customer_id
left join public.sale_items si on si.sale_id = sa.sale_id
left join public.products p on p.product_id = si.product_id
order by c.customer_name, sa.sale_date desc nulls last;

-- LEFT JOIN shows every category, including an empty category if one exists.
select c.category_name, p.product_name, p.stock_qty
from public.categories c
left join public.products p on p.category_id = c.category_id
order by c.category_name, p.product_name;

/* ================================================================
   9. SUBQUERIES, EXISTS AND NOT EXISTS
   ================================================================ */
-- Scalar subquery: products priced above the catalogue average.
select product_name, unit_price
from public.products
where unit_price > (select avg(unit_price) from public.products)
order by unit_price desc;

-- Correlated subquery: products with stock below their category average.
select p.product_name, p.stock_qty, p.category_id
from public.products p
where p.stock_qty < (
  select avg(p2.stock_qty)
  from public.products p2
  where p2.category_id = p.category_id
);

-- EXISTS: suppliers that have at least one product.
select s.supplier_id, s.supplier_name
from public.suppliers s
where exists (select 1 from public.products p where p.supplier_id = s.supplier_id)
order by s.supplier_name;

-- NOT EXISTS: customers who have never been attached to a sale.
select c.customer_id, c.customer_code, c.customer_name
from public.customers c
where not exists (select 1 from public.sales sa where sa.customer_id = c.customer_id)
order by c.customer_name;

-- NOT EXISTS: products that have no recorded stock movement.
select p.product_id, p.product_name, p.sku
from public.products p
where not exists (select 1 from public.stock_movements m where m.product_id = p.product_id);

/* ================================================================
   10. EXISTING DATABASE FUNCTIONS
   ================================================================ */
-- restock_product is an implemented PL/pgSQL function. This call is rolled back.
begin;
select public.restock_product(
  (select product_id from public.products where sku = 'ST-001'),
  1,
  'DBMS-ROLLBACK-RESTOCK'
);
rollback;

-- record_sale is implemented atomically. This call is rolled back and leaves no sale.
begin;
select public.record_sale(
  'DBMS Rollback Customer',
  'Cash',
  (select product_id from public.products where sku = 'ST-001'),
  1,
  (select unit_price from public.products where sku = 'ST-001'),
  (select customer_id from public.customers where customer_code = 'CUST-001')
);
rollback;

-- Inspect the installed function definitions; this does not execute them.
select n.nspname as schema_name, p.proname as function_name,
       pg_get_function_identity_arguments(p.oid) as arguments,
       pg_get_functiondef(p.oid) as definition
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in ('restock_product','record_sale');

/* ================================================================
   11. VIEW FOR A USEFUL INVENTORY REPORT
   ================================================================ */
-- This executable definition creates or replaces one non-destructive report view.
-- It is not claimed to exist until this statement is run in the SQL Editor.
create or replace view public.inventory_report as
select p.product_id, p.product_name, p.sku,
       c.category_name, s.supplier_name,
       p.unit_price, p.stock_qty, p.reorder_level,
       case when p.stock_qty = 0 then 'OUT OF STOCK'
            when p.stock_qty <= p.reorder_level then 'LOW STOCK'
            else 'IN STOCK' end as stock_status,
       round(p.stock_qty * p.unit_price, 2) as inventory_value
from public.products p
join public.categories c on c.category_id = p.category_id
join public.suppliers s on s.supplier_id = p.supplier_id;

-- Query the report view after the definition above has been executed.
select * from public.inventory_report order by stock_status, product_name;

/* ================================================================
   12. TRIGGERS: HONEST STATUS
   ================================================================ */
-- No custom SmartStock trigger is defined in schema.sql or the migration.
-- This query lists user-defined triggers and will return zero SmartStock rows
-- unless a future migration explicitly adds one.
select event_object_schema, event_object_table, trigger_name, action_timing, event_manipulation
from information_schema.triggers
where event_object_schema = 'public'
  and trigger_name not like 'RI_ConstraintTrigger%'
order by event_object_table, trigger_name;
