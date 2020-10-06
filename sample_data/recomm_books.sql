INSERT INTO recomm_books(book_id, recomm_book_id, recomm_score)
SELECT book_id, TRUNC(dbms_random.value(1,39)), trunc(dbms_random.value(0,9)) from book
/




BEGIN
   FOR rec IN (SELECT book_id, TRUNC(dbms_random.value(1,39)) as recomm_book_id, trunc(dbms_random.value(0,9)) as recomm_score from book) 
   LOOP
      -- We cannot just insert a random recommended book as it may already be listed.  So, we run within this loop to allow us to check each
      -- potential insert.  
      --
      INSERT INTO recomm_books(book_id, recomm_book_id, recomm_score) 
      SELECT rec.book_id, rec.recomm_book_id, rec.recomm_score FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM recomm_books WHERE book_id = rec.book_id and recomm_book_id = rec.recomm_book_id);
   END LOOP;
END;
/
/
/
/
/

