# Retail Sales SQL Analysis

A self-contained SQL project analyzing a small retail sales dataset (customers, orders, order items, products, categories). Built to practice and demonstrate core SQL skills: joins, aggregations, CTEs, window functions, subqueries, and date-based grouping.

## Files
- `schema_and_data.sql` — table definitions + sample data (10 customers, 10 products across 4 categories, 15 orders, 20 order line items)
- `queries.sql` — 6 annotated queries, each answering a specific business question

## Schema

```
customers (customer_id, first_name, last_name, city, signup_date)
categories (category_id, category_name)
products (product_id, product_name, category_id, price)
orders (order_id, customer_id, order_date)
order_items (order_item_id, order_id, product_id, quantity, unit_price)
```

Relationships: `customers` 1—N `orders` 1—N `order_items` N—1 `products` N—1 `categories`

## Queries and what they demonstrate

| # | Business question | SQL concept |
|---|---|---|
| 1 | Which customers have spent the most overall? | Multi-table JOIN + GROUP BY + aggregation |
| 2 | What are the top 3 categories by revenue? | CTE (WITH clause) |
| 3 | How do products rank by revenue within their category? | Window function (RANK() OVER PARTITION BY) |
| 4 | Which customers spent more than the average customer? | Subquery in HAVING clause |
| 5 | What is total revenue by month? | Date functions + GROUP BY |
| 6 | Are there any orders with no line items? | LEFT JOIN for data quality checks |

## How to run it

1. Install SQLite (or use any SQL environment — PostgreSQL/MySQL with minor syntax tweaks)
2. `sqlite3 retail.db < schema_and_data.sql`
3. Run any query from `queries.sql`, e.g. `sqlite3 retail.db < queries.sql`

## Sample result (Query 1 — top customers by spend)

| customer_name | total_spent |
|---|---|
| Priya Nair | 11693 |
| Meera Iyer | 7496 |
| Asha Rao | 6394 |

## Notes

This uses a small synthetic dataset built for practicing SQL fundamentals, not a real company's data. The value is in the query logic (joins, CTEs, window functions, subqueries) which transfers directly to real-world schemas of the same shape.
