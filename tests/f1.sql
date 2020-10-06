
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS'
/

PROMPT Set of recommended books for book_id: 20...
SELECT * FROM recomm_books WHERE book_id = 20 order by recomm_score DESC;

PROMPT Set of ALL PRICES for recommended books for book_id: 20...
SELECT * 
FROM prices 
WHERE book_id IN (
   SELECT recomm_book_id 
   FROM recomm_books WHERE book_id = 20) 
   OR book_id IN (20)
ORDER BY book_id, price_valid_from;


VARIABLE crec_books REFCURSOR;

BEGIN

   :crec_books := func_get_books_recomm(20,1);

END;
/




col uv_title       format a80
col uv_description format a100
col uv_description_big format a10
col uv_current_price format 9999.99

set lines 300

print crec_books;
