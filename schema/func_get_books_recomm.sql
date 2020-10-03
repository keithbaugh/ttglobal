CREATE OR REPLACE FUNCTION fnc_get_books_recomm(
   pin_book_id IN book.book_id%TYPE,
   pin_language_id IN languages.lang_id%TYPE
) RETURN REFCURSOR
IS
BEGIN
   --
   -- Return all user visible, singular information for books recommended against the 
   -- input value of pin_book_id.
   -- Here we will also return the book_id of the recommended book for application-reference
   -- as this will be required by the application if the book is subsequently selected.
   --
   CURSOR cur_recomm_books (curp_book_id) IS
   SELECT 
      rb.recomm_book_id as book_id,
      bi.uv_title,
      bi.uv_description,
      bi.uv_description_big,
      vetted_prices.uv_current_price
   FROM
      recomm_books rb 
      INNER JOIN book_info bi 
         ON rb.recomm_book_id = bi.book_id AND bi.translation_status = 'PUBLISHED'
      INNER JOIN (
         -- We cannot join directly to the prices table on book_id as this table holds
         -- potentially many entries, we have to determine the price with the most
         -- recent 'price_valid_from' value.  This is a achieved using an inline view 'vetted_prices'
         -- where the set of possible 'price_valid_from' dates are ordered in descending order
         -- and we then use the analytical function ROW_NUMBER() to rank these in order with the
         -- highest date ranked as '1'.  This is the one value we are interested in using.
         -- To prevent 'future' dates being returned, the inner query calls that 
         -- price_valid_from < SYSDATE.
         -- Oracle will PUSH predicates from outside this query into the inline expression to
         -- facilitate performant execution.
         SELECT 
            valid_prices.book_id, valid_prices.uv_price as current_price
         FROM (
            SELECT 
               p.*, 
               ROWNUM() OVER (PARITION BY book_id ORDER BY price_valid_from DESC) as priority
            FROM
               prices p
            WHERE
               p.price_valid_from < SYSDATE
         ) valid_prices
         WHERE 
           valid_prices.priority = 1
      ) vetted_prices
         ON rb.recom_book_id = vetted_prices.book_id
   WHERE
      rb.book_id = curp_book_id
   ORDER BY 
      rb.recomm_score DESC;


   OPEN cur_recomm_books(pin_book_id);

   RETURN(cur_recomm_books);

END;
/
