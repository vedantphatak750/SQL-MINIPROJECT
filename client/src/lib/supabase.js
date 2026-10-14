import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

export const supabaseConfigured = Boolean(url && key);
export const supabase = supabaseConfigured ? createClient(url, key) : null;

const notConfigured = () => ({ data: null, error: new Error('Supabase is not configured') });

export async function fetchProducts() {
  if (!supabase) return notConfigured();
  return supabase.from('products').select('product_id, product_name, sku, unit_price, stock_qty, reorder_level, categories(category_name), suppliers(supplier_name)').order('product_name');
}

export async function fetchCustomers() {
  if (!supabase) return notConfigured();
  return supabase.from('customers').select('customer_id, customer_code, customer_name, email, phone, address, city, created_at').order('customer_name');
}

export async function createCustomer(customer) {
  if (!supabase) return notConfigured();
  return supabase.from('customers').insert({ customer_code: customer.code, customer_name: customer.name, email: customer.email, phone: customer.phone, address: customer.address, city: customer.city }).select().single();
}

export async function saveProduct(product) {
  if (!supabase) return notConfigured();
  const payload = { product_name: product.name, sku: product.sku, unit_price: product.unitPrice, stock_qty: product.stockQty, reorder_level: product.reorderLevel };
  return product.id ? supabase.from('products').update(payload).eq('product_id', product.id).select().single() : supabase.from('products').insert(payload).select().single();
}

export async function restockProduct(productId, quantity, reference = 'DEMO-RESTOCK') {
  if (!supabase) return notConfigured();
  return supabase.rpc('restock_product', { p_product_id: productId, p_quantity: quantity, p_reference: reference });
}

export async function recordSale({ customer, customerId = null, payment, productId, quantity, sellingPrice }) {
  if (!supabase) return notConfigured();
  return supabase.rpc('record_sale', { p_customer_name: customer, p_customer_id: customerId, p_payment_method: payment, p_product_id: productId, p_quantity: quantity, p_selling_price: sellingPrice });
}
