import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

export const supabaseConfigured = Boolean(url && key);
export const supabase = supabaseConfigured ? createClient(url, key) : null;

export async function fetchProducts() {
  if (!supabase) return { data: null, error: new Error('Supabase is not configured') };
  return supabase.from('products').select('product_id, product_name, sku, unit_price, stock_qty, reorder_level, categories(category_name), suppliers(supplier_name)').order('product_name');
}

export async function saveProduct(product) {
  if (!supabase) return { data: null, error: new Error('Supabase is not configured') };
  const payload = { product_name: product.name, sku: product.sku, unit_price: product.unitPrice, stock_qty: product.stockQty, reorder_level: product.reorderLevel };
  return product.id ? supabase.from('products').update(payload).eq('product_id', product.id).select().single() : supabase.from('products').insert(payload).select().single();
}

export async function restockProduct(productId, quantity, reference = 'DEMO-RESTOCK') {
  if (!supabase) return { data: null, error: new Error('Supabase is not configured') };
  return supabase.rpc('restock_product', { p_product_id: productId, p_quantity: quantity, p_reference: reference });
}

export async function recordSale({ customer, payment, productId, quantity, sellingPrice }) {
  if (!supabase) return { data: null, error: new Error('Supabase is not configured') };
  return supabase.rpc('record_sale', { p_customer_name: customer, p_payment_method: payment, p_product_id: productId, p_quantity: quantity, p_selling_price: sellingPrice });
}
