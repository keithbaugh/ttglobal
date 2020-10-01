CREATE SNAPSHOT book REFRESH FAST AS SELECT * FROM book@schmast;
CREATE SNAPSHOT book_info REFRESH FAST AS SELECT * FROM book_info@schmast;
CREATE SNAPSHOT book_categories REFRESH FAST AS SELECT * FROM book_categories@schmast;
CREATE SNAPSHOT translation_status REFRESH FAST AS SELECT * FROM translation_status@schmast;
CREATE SNAPSHOT customer REFRESH FAST AS SELECT * FROM customer@schmast;
CREATE SNAPSHOT customer_addresses REFRESH FAST AS SELECT * FROM customer_addresses@schmast;
CREATE SNAPSHOT customer_orders REFRESH FAST AS SELECT * FROM customer_orders@schmast;
CREATE SNAPSHOT languages REFRESH FAST AS SELECT * FROM languages@schmast;
CREATE SNAPSHOT category REFRESH FAST AS SELECT * FROM category@schmast;
CREATE SNAPSHOT category_info REFRESH FAST AS SELECT * FROM category_info@schmast;
CREATE SNAPSHOT order_items REFRESH FAST AS SELECT * FROM order_items@schmast;
CREATE SNAPSHOT shipment_items REFRESH FAST AS SELECT * FROM shipment_items@schmast;
CREATE SNAPSHOT category_info REFRESH FAST AS SELECT * FROM category_info@schmast;
CREATE SNAPSHOT customer_orders REFRESH FAST AS SELECT * FROM customer_orders@schmast;
CREATE SNAPSHOT book_categories REFRESH FAST AS SELECT * FROM book_categories@schmast;
CREATE SNAPSHOT prices REFRESH FAST AS SELECT * FROM prices@schmast;
CREATE SNAPSHOT customer_addresses REFRESH FAST AS SELECT * FROM customer_addresses@schmast;
CREATE SNAPSHOT book_info REFRESH FAST AS SELECT * FROM book_info@schmast;

BEGIN

   dbms_refresh.make(
      name => 'bookstore_copy_group',
      list => 'BOOK,TRANSLATION_STATUS,CUSTOMER,LANGUAGES,CATEGORY,ORDER_ITEMS,SHIPMENT_ITEMS,CATEGORY_INFO,CUSTOMER_ORDERS,BOOK_CATEGORIES,PRICES,CUSTOMER_ADDRESSES,BOOK_INFO',
      next_date => SYSDATE,
      interval => 'SYSDATE+1/1440');

END;
/

