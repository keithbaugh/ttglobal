CREATE SNAPSHOT book REFRESH FAST AS SELECT * FROM book@schmast;
CREATE SNAPSHOT book_categories REFRESH FAST AS SELECT * FROM book_categories@schmast;
CREATE SNAPSHOT book_info REFRESH FAST AS SELECT * FROM book_info@schmast;
CREATE SNAPSHOT category REFRESH FAST AS SELECT * FROM category@schmast;
CREATE SNAPSHOT category_info REFRESH FAST AS SELECT * FROM category_info@schmast;
CREATE SNAPSHOT customer REFRESH FAST AS SELECT * FROM customer@schmast;
CREATE SNAPSHOT customer_addresses REFRESH FAST AS SELECT * FROM customer_addresses@schmast;
CREATE SNAPSHOT customer_orders REFRESH FAST AS SELECT * FROM customer_orders@schmast;
CREATE SNAPSHOT customer_reviews REFRESH FAST AS SELECT * FROM customer_reviews@schmast;
CREATE SNAPSHOT languages REFRESH FAST AS SELECT * FROM languages@schmast;
CREATE SNAPSHOT order_items REFRESH FAST AS SELECT * FROM order_items@schmast;
CREATE SNAPSHOT payment_methods REFRESH FAST AS SELECT * FROM payment_methods@schmast;
CREATE SNAPSHOT prices REFRESH FAST AS SELECT * FROM prices@schmast;
CREATE SNAPSHOT recomm_books REFRESH FAST AS SELECT * FROM recomm_books@schmast;
CREATE SNAPSHOT translation_status REFRESH FAST AS SELECT * FROM translation_status@schmast;

BEGIN
   dbms_refresh.destroy(
      name=> 'bookstore_copy_group'
   );
EXCEPTION WHEN OTHERS THEN
   NULL;
END;
/

BEGIN

   dbms_refresh.make(
      name => 'bookstore_copy_group',
      list => 'BOOK,BOOK_CATEGORIES,BOOK_INFO,CATEGORY,CATEGORY_INFO,CUSTOMER,CUSTOMER_ADDRESSES,CUSTOMER_ORDERS,CUSTOMER_REVIEWS,LANGUAGES,ORDER_ITEMS,PAYMENT_METHODS,PRICES,RECOMM_BOOKS,TRANSLATION_STATUS',
      next_date => SYSDATE,
      interval => 'SYSDATE+1/1440');

END;
/

