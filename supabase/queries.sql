-- SMARTSTOCK query reference (PostgreSQL / Supabase)
select p.*, c.category_name, s.supplier_name from products p join categories c using(category_id) join suppliers s using(supplier_id) order by p.product_name;
select * from products where product_name ilike '%pen%' or sku ilike '%pen%';
select * from products where category_id=:category_id and stock_qty <= reorder_level order by stock_qty;
select count(*) product_count, coalesce(sum(stock_qty),0) units_in_stock, coalesce(sum(stock_qty*unit_price),0) inventory_value, count(*) filter(where stock_qty <= reorder_level and stock_qty > 0) low_stock_products from products;
select c.category_name,count(p.product_id) product_count,coalesce(sum(p.stock_qty),0) units from categories c left join products p using(category_id) group by c.category_name order by c.category_name;
select pu.purchase_id,pu.invoice_no,pu.purchase_date,s.supplier_name,pi.quantity,pi.cost_price,p.product_name from purchases pu join suppliers s using(supplier_id) join purchase_items pi using(purchase_id) join products p using(product_id) order by pu.purchase_date desc;
select sa.sale_id,sa.sale_date,sa.customer_name,sa.payment_method,si.quantity,si.selling_price,p.product_name from sales sa join sale_items si using(sale_id) join products p using(product_id) order by sa.sale_date desc;
select m.*,p.product_name from stock_movements m join products p using(product_id) order by m.movement_date desc;
update products set unit_price=75, reorder_level=7, updated_at=now() where sku='ST-003';
select * from products where stock_qty=0 or stock_qty <= reorder_level;
