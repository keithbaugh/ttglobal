CREATE OR REPLACE FUNCTION func_get_book_price_at_time(
   pin_book_id    IN book.book_id%TYPE,
   pin_check_date IN DATE
) RETURN prices.uv_price%TYPE
IS
   return_price prices.uv_price%TYPE;
BEGIN
   --
   -- Return the price of a book that it would cost at time of the check_date
   --

   return_price := NULL;

   FOR rec IN (
      SELECT uv_price FROM (
            SELECT 
               p.uv_price,
               ROW_NUMBER() OVER (PARTITION BY book_id ORDER BY price_valid_from DESC) as priority
            FROM
               prices p
            WHERE
               p.price_valid_from < pin_check_date AND
               p.book_id = pin_book_id
      ) WHERE priority = 1
   ) LOOP
      return_price := rec.uv_price;
   END LOOP;


   RETURN return_price;

END;
/

show errors
