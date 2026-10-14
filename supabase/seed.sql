-- Run after schema.sql. Safe to rerun for the same demo records.
insert into public.categories(category_name,description) values
 ('Stationery','Writing and desk essentials'),('Electronics','Practical study and work tools'),('Accessories','Useful everyday goods') on conflict(category_name) do update set description=excluded.description;
insert into public.suppliers(supplier_name,phone,email,address) values
 ('Bright Office Supplies','+91 80 4123 8820','hello@bright.demo','Bengaluru, Karnataka'),('TechSource Distributors','+91 22 4011 2288','hello@techsource.demo','Mumbai, Maharashtra'),('Everyday Wholesale','+91 11 4880 1919','hello@everyday.demo','New Delhi, Delhi') on conflict(supplier_name) do nothing;
insert into public.products(product_name,category_id,supplier_id,sku,unit_price,stock_qty,reorder_level)
select v.name,c.category_id,s.supplier_id,v.sku,v.price,v.qty,v.reorder_level from (values
 ('Ball Pen','Stationery','Bright Office Supplies','ST-001',10::numeric,50,10),('Notebook','Stationery','Bright Office Supplies','ST-002',45,30,8),('Scientific Calculator','Electronics','TechSource Distributors','EL-001',350,10,3),('USB Drive 32GB','Electronics','TechSource Distributors','EL-002',400,4,5),('Water Bottle','Accessories','Everyday Wholesale','AC-001',120,15,5),('Marker Set','Stationery','Bright Office Supplies','ST-003',80,6,6)
) v(name,category,supplier,sku,price,qty,reorder_level) join public.categories c on c.category_name=v.category join public.suppliers s on s.supplier_name=v.supplier where not exists(select 1 from public.products p where p.sku=v.sku);
insert into public.stock_movements(product_id,movement_type,quantity_change,reference_type,reference_id,remarks)
select p.product_id,'OPENING STOCK',p.stock_qty,'DEMO','DEMO-OPEN','Opening stock / demo activity' from public.products p where not exists(select 1 from public.stock_movements m where m.product_id=p.product_id and m.reference_id='DEMO-OPEN');
