
DECLARE
    v_revtext   VARCHAR2(4000);
    n_max_book  book.book_id%TYPE;
    n_revcount  NUMBER;

BEGIN

   v_revtext := 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu nibh eget ipsum accumsan suscipit. Sed vulputate sed turpis sed volutpat. Donec commodo nulla dui, eget pulvinar arcu bibendum et. Mauris sit amet nunc ut metus volutpat tincidunt sed sed metus. Praesent pretium, dui sit amet imperdiet dictum, leo neque tristique risus, vel pulvinar lectus dui eget justo. Quisque at gravida dui. Praesent eu quam quis dui tincidunt fringilla. Quisque molestie justo non nibh cursus, eu faucibus nibh auctor. Nulla accumsan feugiat fringilla. Aenean in convallis velit. Aliquam scelerisque sem sit amet massa sollicitudin, euismod molestie odio sodales. Cras non nisi quis nisl hendrerit efficitur ac nec dolor. Vivamus eu sollicitudin nulla. Duis mattis lacinia risus, et mollis dolor interdum vitae.

Ut et finibus augue. In ac mattis sem, sed bibendum lorem. Vivamus nec orci sem. Aenean rhoncus vulputate sapien, ac interdum diam venenatis in. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Phasellus eget ante convallis, pulvinar metus eget, maximus felis. In hac habitasse platea dictumst. Donec ornare metus quam, sed convallis nibh pharetra sit amet. Proin ac mattis enim. Integer venenatis rutrum neque, ac ornare quam auctor vel.

Quisque eu justo at mi eleifend imperdiet eget a augue. Cras eget odio euismod, consequat ex eu, gravida odio. Suspendisse potenti. Suspendisse convallis ullamcorper consectetur. Donec hendrerit laoreet arcu, id rutrum enim dapibus a. Phasellus lobortis dolor lectus, ac cursus felis pulvinar quis. Cras est odio, gravida nec consectetur sed, ullamcorper vitae dui. Aliquam tincidunt placerat magna, eu mattis nunc. Ut vitae egestas urna, vitae congue libero. Praesent gravida diam in nulla viverra tincidunt dapibus vitae orci. Aenean interdum eros ut leo molestie, nec viverra metus maximus. Proin vel nunc nec metus luctus tincidunt. Cras eu accumsan urna, id blandit augue. Suspendisse potenti. Donec aliquam aliquet nibh sed commodo.

Nullam urna justo, pharetra ac augue vel, placerat posuere ex. Morbi egestas nisi vel metus hendrerit, eu scelerisque enim finibus. Vestibulum fringilla, odio sit amet sagittis pretium, urna neque facilisis tellus, eget feugiat mauris massa viverra nisi. Aenean varius nulla rhoncus arcu elementum efficitur. Nullam ultricies gravida metus eget sagittis. Suspendisse vitae dui at nulla vehicula lobortis a id elit. Nullam dapibus arcu ipsum, ac hendrerit justo commodo at. Suspendisse potenti. Integer porttitor faucibus fringilla.

Phasellus dui arcu, accumsan sed molestie nec, elementum sed lectus. Aenean vel pretium nulla. Praesent efficitur blandit nibh, at viverra arcu semper in. Pellentesque dictum ultricies dolor sed viverra. Aenean eget nibh justo. Nam massa est, ultrices a pretium eu, tincidunt pulvinar erat. Cras eu viverra nibh, in fringilla risus. Morbi id pulvinar risus, eu condimentum tellus. Nulla consectetur aliquam elementum. Praesent id neque scelerisque, malesuada justo eget, congue metus.';


   SELECT MAX(book_id) INTO n_max_book FROM book;

   FOR cust IN (SELECT cust_id FROM customer) 
   LOOP
      -- Decide how many reviews this customer will have made...
      SELECT trunc(dbms_random.value(0,10)) INTO n_revcount FROM DUAL;

      -- Create n_revcount book_ids randomly chosen from the set of available books...
      FOR randombooks IN (
         SELECT book_id FROM (
            SELECT book_id FROM (
               SELECT book_id, dbms_random.value(0,100) as rand FROM book
            ) ORDER BY rand
         ) WHERE rownum < n_revcount
      ) LOOP
         -- Create a book review item for this customer against the randomly chosen book...

         INSERT INTO customer_reviews(cust_id, book_id, moderation_status, moderation_comment, date_last_edited, ue_review_text)
         VALUES(cust.cust_id, randombooks.book_id, 'CLEARED', NULL, SYSDATE, v_revtext);

      END LOOP;

   END LOOP;

END;
/
