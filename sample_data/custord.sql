INSERT INTO 
customer_orders(
   order_id,
   cust_id,
   date_order_placed,
   total_order_price,
   payment_method_id,
   payment_status,
   card_number,
   expiry_date,
   shipping_addr_id,
   billing_addr_id)
SELECT 
   seq_order_id.nextval, 
   sa.cust_id, 
   SYSDATE - dbms_random.value(0,60),
   0.00,
   TRUNC(dbms_random.value(1,5)),
   'APPROVED', 
   '1111222233334444',
   '0'||to_char(trunc(dbms_random.value(1,9)))||'21',
   sa.addr_id,
   ba.addr_id 
FROM
   customer_addresses sa,
   customer_addresses ba
WHERE
   sa.cust_id = ba.cust_id AND
   sa.default_address = 'Y' AND
   sa.address_type LIKE 'S' AND
   ba.default_address = 'Y' AND
   ba.address_type LIKE 'B' 
/


DECLARE
   v_item_id NUMBER;
BEGIN

   -- For every customer_order created (above), create some items... (some random books)...
   FOR custord IN (
      SELECT * FROM customer_orders
   ) LOOP
  
      -- For each order, create a random set of books with a few qunatities > 1.
      v_item_id := 1;
      FOR bks IN (
         SELECT bookord.book_id, count(*) as qty FROM (
            SELECT book_id FROM book WHERE book_id = trunc(dbms_random.value(1,37))
            UNION ALL
            SELECT book_id FROM book WHERE book_id = trunc(dbms_random.value(1,37))
            UNION ALL
            SELECT book_id FROM book WHERE book_id = trunc(dbms_random.value(1,37))
            UNION ALL
            SELECT book_id FROM book WHERE book_id = trunc(dbms_random.value(1,37))
            UNION ALL
            SELECT book_id FROM book WHERE book_id = trunc(dbms_random.value(1,37))
         ) bookord GROUP BY book_id
      ) LOOP
      
         -- Create the order, item, fetching the price from the prices table at the time the sample order was created....
         -- use the function func_get_book_price_at_time to collect the price data.
         INSERT INTO order_Items 
            (order_id, item_id, book_id, quantity_ordered, price_when_ordered)
         VALUES (custord.order_id, v_item_id, bks.book_id, bks.qty, func_get_book_price_at_time(bks.book_id, custord.date_order_placed));

         v_item_id := v_item_id + 1;

      END LOOP;

      -- Having made a number of items in the order, it is not time to update the total order price in the customer_orders table...

      UPDATE customer_orders final
      SET final.total_order_price = (SELECT SUM(oi.price_when_ordered) FROM order_items oi WHERE oi.order_id = custord.order_id)
      WHERE order_id = custord.order_id;

   END LOOP;
END;
/

