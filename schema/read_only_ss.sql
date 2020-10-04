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
CREATE SNAPSHOT translation_status REFRESH FAST AS SELECT * FROM translation_status@schmast;

BEGIN

   dbms_refresh.make(
      name => 'bookstore_copy_group',
      list => 'BIN$sLsASMa3AhbgUwo1QA7ZwA==$0,BIN$sLsASMa8AhbgUwo1QA7ZwA==$0,BIN$sLsASMazAhbgUwo1QA7ZwA==$0,BIN$sLsASMb0AhbgUwo1QA7ZwA==$0,BIN$sLsASMb9AhbgUwo1QA7ZwA==$0,BIN$sLsASMbDAhbgUwo1QA7ZwA==$0,BIN$sLsASMbLAhbgUwo1QA7ZwA==$0,BIN$sLsASMbSAhbgUwo1QA7ZwA==$0,BIN$sLsASMbYAhbgUwo1QA7ZwA==$0,BIN$sLsASMbdAhbgUwo1QA7ZwA==$0,BIN$sLsASMbsAhbgUwo1QA7ZwA==$0,BIN$sLsASMcFAhbgUwo1QA7ZwA==$0,BIN$sLsASMcLAhbgUwo1QA7ZwA==$0,BIN$sLsASMcRAhbgUwo1QA7ZwA==$0,BIN$sLsASMcbAhbgUwo1QA7ZwA==$0,BIN$sLsDNX++AdLgUwo1QA7u/w==$0,BIN$sLsDNX+1AdLgUwo1QA7u/w==$0,BIN$sLsDNX+5AdLgUwo1QA7u/w==$0,BIN$sLsDNX//AdLgUwo1QA7u/w==$0,BIN$sLsDNX/2AdLgUwo1QA7u/w==$0,BIN$sLsDNX/FAdLgUwo1QA7u/w==$0,BIN$sLsDNX/NAdLgUwo1QA7u/w==$0,BIN$sLsDNX/UAdLgUwo1QA7u/w==$0,BIN$sLsDNX/aAdLgUwo1QA7u/w==$0,BIN$sLsDNX/fAdLgUwo1QA7u/w==$0,BIN$sLsDNX/uAdLgUwo1QA7u/w==$0,BIN$sLsDNYAHAdLgUwo1QA7u/w==$0,BIN$sLsDNYANAdLgUwo1QA7u/w==$0,BIN$sLsDNYATAdLgUwo1QA7u/w==$0,BIN$sLsDNYAdAdLgUwo1QA7u/w==$0,BOOK,BOOK_CATEGORIES,BOOK_INFO,CATEGORY,CATEGORY_INFO,CUSTOMER,CUSTOMER_ADDRESSES,CUSTOMER_ORDERS,CUSTOMER_REVIEWS,LANGUAGES,ORDER_ITEMS,PAYMENT_METHODS,PRICES,SIMILAR_BOOKS,TRANSLATION_STATUS',
      next_date => SYSDATE,
      interval => 'SYSDATE+1/1440');

END;
/

