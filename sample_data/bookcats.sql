DECLARE
   n_max_books NUMBER;
   n_max_cats  NUMBER;
BEGIN
   SELECT max(book_id) INTO n_max_books FROM book;
   SELECT max(cat_id)  INTO n_max_cats  FROM category;

   FOR i IN 1..5 
   LOOP

      FOR rec IN (SELECT book_id FROM book)
      LOOP
         BEGIN
            INSERT INTO book_categories (book_id, cat_id)
            VALUES(rec.book_id, trunc(dbms_random.value(1,n_max_cats)));
         EXCEPTION WHEN OTHERS THEN
            NULL; 
            -- Ignore the failure scenario as pushing random categrories into books will 
            -- geneate some duplicates..  - Not a problem for this sample data...
         END;
      END LOOP;
   END LOOP;

END;
/
