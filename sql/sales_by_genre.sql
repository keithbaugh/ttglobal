PROMPT Sales by Genre for a given month and previous month...

WHENEVER SQLERROR EXIT 1;
set verify off

PROMPT Please enter the moth of interest in the format: YYYYMM

define MONTH=&&MONTH

PROMPT Testing input value: &&MONTH....

VARIABLE d_month_1 VARCHAR2(6);
VARIABLE d_month_2 VARCHAR2(6);

BEGIN
   FOR rec IN ( 
      SELECT 
         to_date('&&MONTH','YYYYMM') as dummy,
         to_char(ADD_MONTHS(to_date('&&MONTH','YYYYMM'),-1),'YYYYMM') prev_month
      FROM DUAL
   ) LOOP
      :d_month_1 := rec.prev_month;
   END LOOP;

   EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line('Invalid Month, please express in the format: YYYYMM');
      RAISE_APPLICATION_ERROR(-20000, 'Invalid user input');
END;
/
WHENEVER SQLERROR CONTINUE;


PROMPT Will produce are report detailing sales figures by genre for the month of &&MONTH and the previous month.
PROMPT


col category_name format a50
set lines 200


SELECT 
   cat_id, 
   (SELECT ci.uv_category_title FROM category_info ci WHERE ci.cat_id = x.cat_id)    as category_name,
   SUM(DECODE(to_char(sales_month,'YYYYMM'),'&&MONTH',total_sales,0))                as total_sales_for_month,
   SUM(DECODE(to_char(sales_month,'YYYYMM'),'&&MONTH',qty_sales,0))                  as total_qty_for_month,
   SUM(DECODE(to_char(sales_month,'YYYYMM'),'&&MONTH',0,total_sales))                as total_sales_for_prev_month,
   SUM(DECODE(to_char(sales_month,'YYYYMM'),'&&MONTH',0,qty_sales))                  as total_qty_for_prev_month
FROM 
   (
      SELECT 
         cat.cat_id, 
         TRUNC(co.date_order_placed,'MONTH') as sales_month,
         SUM(oi.price_when_ordered * oi.quantity_ordered) total_sales, 
         SUM(oi.quantity_ordered)   qty_sales
      FROM
         -- Going to join from categories in the first place as there may be categories that are not selling at all.
         -- we will need to perform outer joins into the ordering tables to find these...
         category cat
         LEFT OUTER JOIN book            bk ON cat.cat_id = bk.cat_id
         LEFT OUTER JOIN order_items     oi ON bk.book_id = oi.book_id
         LEFT OUTER JOIN customer_orders co ON co.order_id = oi.order_id
      WHERE
            TRUNC(co.date_order_placed,'MONTH') BETWEEN ADD_MONTHS(TO_DATE('&&MONTH','YYYYMM'),-1) AND TO_DATE('&&MONTH','YYYYMM') 
      GROUP BY
         TRUNC(co.date_order_placed,'MONTH'), cat.cat_id
      ORDER BY 
         TRUNC(co.date_order_placed,'MONTH'), cat.cat_id
   ) x
GROUP BY x.cat_id
ORDER BY x.cat_id
/


