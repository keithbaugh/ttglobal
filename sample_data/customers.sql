INSERT INTO customer(cust_id, username, password_hash, account_created, account_status, email_address, ue_title, ue_first_name, ue_middle_initials, ue_last_name, ue_review_pseudonym)
VALUES(seq_cust_id.nextval, 'keithbaugh', NULL, sysdate, 'REGISTERED','kjbaugh@gmail.com','Mr','Keith','J','Baugh','MrBoffo');
INSERT INTO customer(cust_id, username, password_hash, account_created, account_status, email_address, ue_title, ue_first_name, ue_middle_initials, ue_last_name, ue_review_pseudonym)
VALUES(seq_cust_id.nextval, 'millymoppit', NULL, sysdate, 'REGISTERED','millmoppit@gmail.com','Miss','Millie','M','Moppit','MilloM');
INSERT INTO customer(cust_id, username, password_hash, account_created, account_status, email_address, ue_title, ue_first_name, ue_middle_initials, ue_last_name, ue_review_pseudonym)
VALUES(seq_cust_id.nextval, 'fredsmith', NULL, sysdate, 'REGISTERED','freddys@gmail.com','Dr','Frederick','LJC','Smithson','DrFred');
INSERT INTO customer(cust_id, username, password_hash, account_created, account_status, email_address, ue_title, ue_first_name, ue_middle_initials, ue_last_name, ue_review_pseudonym)
VALUES(seq_cust_id.nextval, 'hopper', NULL, sysdate, 'REGISTERED','Hopper@gmail.com','Sgt','David',NULL,'Hopper','LtHopper');


INSERT INTO customer
SELECT seq_cust_id.nextval, username||to_char(seq_cust_id.nextval), password_hash, sysdate, account_status, email_address, ue_title, ue_first_name, ue_middle_initials, ue_last_name, ue_review_pseudonym 
FROM  customer
/
/
/
/
/


INSERT INTO customer_addresses(addr_id, cust_id, display_order, address_type, default_address, ue_address_line_1, ue_address_line_2, ue_address_line_3, ue_address_line_4, ue_address_city, ue_address_region, ue_address_country, ue_address_postzip_code)
SELECT seq_addr_id.nextval, cust_id, 1, 'S','Y', to_char(trunc(dbms_random.value(1,1000)))||' '||to_char(sysdate+dbms_random.value(0,1000),'Day')||' Street','Lorem Ipsum Village','Dolor Sit Amet',NULL,'Lorem City','Romeenicus','USA','LE33 2TD' 
FROM customer
/

INSERT INTO customer_addresses(addr_id, cust_id, display_order, address_type, default_address, ue_address_line_1, ue_address_line_2, ue_address_line_3, ue_address_line_4, ue_address_city, ue_address_region, ue_address_country, ue_address_postzip_code)
SELECT seq_addr_id.nextval, cust_id, 1, 'B','Y', to_char(trunc(dbms_random.value(1,1000)))||' '||to_char(sysdate+dbms_random.value(0,1000),'Day')||' Street','Lorem Ipsum Village','Dolor Sit Amet',NULL,'Lorem City','Romeenicus','USA','LE33 2TD' 
FROM customer
/

INSERT INTO customer_addresses(addr_id, cust_id, display_order, address_type, default_address, ue_address_line_1, ue_address_line_2, ue_address_line_3, ue_address_line_4, ue_address_city, ue_address_region, ue_address_country, ue_address_postzip_code)
SELECT seq_addr_id.nextval, cust_id, 2, 'S','Y', to_char(trunc(dbms_random.value(1,1000)))||' '||to_char(sysdate+dbms_random.value(0,1000),'Day')||' Street','Lorem Ipsum Village','Dolor Sit Amet',NULL,'Lorem City','Romeenicus','USA','LE33 2TD' 
FROM customer
/




BEGIN
   FOR rec IN (
      SELECT rowid as rid, cust_id, ROW_NUMBER() over (partition by cust_id order by rowid) as new_display_order
      FROM customer_addresses 
      ORDER BY cust_id, display_order
   ) LOOP
      UPDATE customer_addresses SET display_order = rec.new_display_order WHERE rowid = rec.rid;
   END LOOP;
END;
/
