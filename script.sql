SELECT * FROM customers
LIMIT 10;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM books
LIMIT 10;

-- List indexes for the "customers" table
SELECT indexname FROM pg_indexes WHERE tablename = 'customers';

-- List indexes for the "orders" table
SELECT indexname FROM pg_indexes WHERE tablename = 'orders';

-- List indexes for the "books" table
SELECT indexname FROM pg_indexes WHERE tablename = 'books';

--Step 3 
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE quantity > 18;
--11 ms

--Step 4 
CREATE INDEX idx_high_quantity_orders ON orders (customer_id, quantity)
WHERE quantity > 18;

--Step 5 
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE quantity > 18;
--3ms

--Step 6
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE customer_id < 100;
--11.491 ms

ALTER TABLE customers
ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);

EXPLAIN ANALYZE SELECT *
FROM customers
WHERE customer_id < 100;
--0.139 ms

--Step 7
CLUSTER customers USING customers_pk;
SELECT * FROM customers LIMIT 10;

--Step 8
CREATE INDEX idx_customer_book ON orders (customer_id, book_id);

--Step 9
DROP INDEX idx_customer_book;

EXPLAIN ANALYZE
SELECT customer_id, book_id, quantity
FROM orders;
--15.091ms

CREATE INDEX idx_customer_book_quantity ON orders (customer_id, book_id, quantity);

EXPLAIN ANALYZE
SELECT customer_id, book_id, quantity
FROM orders;
--15.249

--Step 10
CREATE INDEX idx_author_title ON books (author, title);

--Step 11 
EXPLAIN ANALYZE
SELECT order_id, customer_id, quantity, price_base
FROM orders
WHERE (quantity * price_base) > 100;
--37.182 ms

--Step 12
CREATE INDEX idx_total_price_filter ON orders ((quantity * price_base)) WHERE (quantity * price_base) > 100;

--Step 13
EXPLAIN ANALYZE
SELECT order_id, customer_id, quantity, price_base
FROM orders
WHERE (quantity * price_base) > 100;
--16.882 ms

--Step 14

SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;

DROP INDEX IF EXISTS books_author_idx;

DROP INDEX IF EXISTS orders_customer_id_quantity;

CREATE INDEX customers_last_name_first_name_email_address ON customers (last_name, first_name, email_address);

SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;

