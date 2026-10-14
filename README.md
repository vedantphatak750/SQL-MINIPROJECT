# SMARTSTOCK

**Know your stock. Control your business.**

SMARTSTOCK is a premium editorial-industrial inventory management dashboard for a college DBMS mini-project. The frontend is Vite/React and the database layer is Supabase PostgreSQL.

## Run locally

```bash
pnpm install
cp .env.example .env.local
pnpm dev
```

Open the Vite URL shown in the terminal. For a production build:

```bash
pnpm build
pnpm start
```

## Supabase setup (manual, required for live data)

1. Create a Supabase project.
2. In Supabase **SQL Editor**, run `supabase/schema.sql` first.
3. Run `supabase/seed.sql` second.
4. Copy the Project URL and publishable/anon browser key into `.env.local`:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_PUBLISHABLE_KEY`
5. Restart `pnpm dev` and confirm the sidebar changes from `Local demo · configure Supabase` to `Supabase connected · live data`.
6. Use `supabase/queries.sql` to inspect products, low-stock rows, totals, joins, transactions, movements, and safe updates.

No credentials are included in this repository. The browser client never uses a service-role key. If Supabase is not configured, the dashboard explicitly stays in local demo mode; it does not claim a live connection.

## Database model

- `categories` and `suppliers` are parent tables.
- `products` references both and enforces non-negative prices, stock, and reorder levels.
- `purchases` → `purchase_items` and `sales` → `sale_items` model transactions.
- `stock_movements` records opening stock, purchases, sales, restocks, and adjustments.
- Indexes support category/supplier lookups and movement history.
- RLS is enabled on all exposed tables. The included anonymous policies are intentionally permissive for a classroom demo and must be replaced with authenticated policies before production use.

## Functional features

- Computed metrics: 6 products, 115 units, 2 low-stock products, and ₹9,230 initial inventory value.
- Overview, Inventory, Categories, Suppliers, Purchases, Sales, Stock Movements, and Reports navigation.
- Product search across name/SKU/supplier; category and stock-status filters; sortable inventory columns.
- Add/edit products, local restock, purchase-entry simulation, and sale-entry simulation.
- `record_sale` locks the product row, checks stock, creates the sale and sale item, deducts stock, and records one negative SALE movement atomically.
- `restock_product` validates positive quantity, updates stock, and records one RESTOCK movement.
- localStorage demo fallback, reset demo data control, empty states, toast feedback, keyboard Escape modal close, focus styles, responsive mobile layout, and reduced-motion support.

## Known limitations

- The current UI reads live products when Supabase is configured. Product edit/restock/sale controls retain the local demo state path unless the corresponding helper in `client/src/lib/supabase.js` is wired into the UI action; the secure database RPCs are provided and ready for that final wiring step.
- The anonymous RLS policy is for a college demonstration only.
- No real authentication, payments, or production hosting is claimed.
