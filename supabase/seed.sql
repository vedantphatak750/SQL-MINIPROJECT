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

insert into public.customers(customer_code,customer_name,email,phone,address,city) values
 ('CUST-001','Aarav Mehta','customer01@smartstock.demo','+91 90000 10000','10 Demo Avenue','Bengaluru'),
 ('CUST-002','Aanya Shah','customer02@smartstock.demo','+91 90000 10001','11 Demo Avenue','Mumbai'),
 ('CUST-003','Advait Kulkarni','customer03@smartstock.demo','+91 90000 10002','12 Demo Avenue','Pune'),
 ('CUST-004','Anaya Iyer','customer04@smartstock.demo','+91 90000 10003','13 Demo Avenue','Delhi'),
 ('CUST-005','Arjun Nair','customer05@smartstock.demo','+91 90000 10004','14 Demo Avenue','Hyderabad'),
 ('CUST-006','Diya Menon','customer06@smartstock.demo','+91 90000 10005','15 Demo Avenue','Bengaluru'),
 ('CUST-007','Ishaan Kapoor','customer07@smartstock.demo','+91 90000 10006','16 Demo Avenue','Mumbai'),
 ('CUST-008','Isha Rao','customer08@smartstock.demo','+91 90000 10007','17 Demo Avenue','Pune'),
 ('CUST-009','Kabir Bansal','customer09@smartstock.demo','+91 90000 10008','18 Demo Avenue','Delhi'),
 ('CUST-010','Kavya Joshi','customer10@smartstock.demo','+91 90000 10009','19 Demo Avenue','Hyderabad'),
 ('CUST-011','Krish Malhotra','customer11@smartstock.demo','+91 90000 10010','20 Demo Avenue','Bengaluru'),
 ('CUST-012','Meera Desai','customer12@smartstock.demo','+91 90000 10011','21 Demo Avenue','Mumbai'),
 ('CUST-013','Nikhil Verma','customer13@smartstock.demo','+91 90000 10012','22 Demo Avenue','Pune'),
 ('CUST-014','Nisha Reddy','customer14@smartstock.demo','+91 90000 10013','23 Demo Avenue','Delhi'),
 ('CUST-015','Omkar Patil','customer15@smartstock.demo','+91 90000 10014','24 Demo Avenue','Hyderabad'),
 ('CUST-016','Pallavi Sen','customer16@smartstock.demo','+91 90000 10015','25 Demo Avenue','Bengaluru'),
 ('CUST-017','Pranav Sethi','customer17@smartstock.demo','+91 90000 10016','26 Demo Avenue','Mumbai'),
 ('CUST-018','Rhea Kapoor','customer18@smartstock.demo','+91 90000 10017','27 Demo Avenue','Pune'),
 ('CUST-019','Rohan Das','customer19@smartstock.demo','+91 90000 10018','28 Demo Avenue','Delhi'),
 ('CUST-020','Saanvi Jain','customer20@smartstock.demo','+91 90000 10019','29 Demo Avenue','Hyderabad'),
 ('CUST-021','Sameer Khan','customer21@smartstock.demo','+91 90000 10020','30 Demo Avenue','Bengaluru'),
 ('CUST-022','Shreya Bose','customer22@smartstock.demo','+91 90000 10021','31 Demo Avenue','Mumbai'),
 ('CUST-023','Siddharth Roy','customer23@smartstock.demo','+91 90000 10022','32 Demo Avenue','Pune'),
 ('CUST-024','Tanvi Pillai','customer24@smartstock.demo','+91 90000 10023','33 Demo Avenue','Delhi'),
 ('CUST-025','Varun Chawla','customer25@smartstock.demo','+91 90000 10024','34 Demo Avenue','Hyderabad'),
 ('CUST-026','Vedika Ghosh','customer26@smartstock.demo','+91 90000 10025','35 Demo Avenue','Bengaluru'),
 ('CUST-027','Vihaan Arora','customer27@smartstock.demo','+91 90000 10026','36 Demo Avenue','Mumbai'),
 ('CUST-028','Yash Thakur','customer28@smartstock.demo','+91 90000 10027','37 Demo Avenue','Pune'),
 ('CUST-029','Zara Fernandes','customer29@smartstock.demo','+91 90000 10028','38 Demo Avenue','Delhi'),
 ('CUST-030','Zubin Contractor','customer30@smartstock.demo','+91 90000 10029','39 Demo Avenue','Hyderabad')
on conflict (customer_code) do nothing;
