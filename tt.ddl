-- Source environment parameters...
@@envs.sql


connect &&MASTERUSERNAME/&&MASTERPASSWORD@&&MASTERDB

CREATE DATABASE LINK &&READONLYDB connect to &&READONLYUSERNAME identified by &&READONLYPASSWORD USING 'TNS:&&READONLYDB';



CREATE TABLE languages(
   lang_id NUMBER(3)           NOT NULL,
   language_name  VARCHAR2(30) NOT NULL,
   domain_id VARCHAR2(20)      NOT NULL
);


ALTER TABLE languages ADD CONSTRAINT languages_pk PRIMARY KEY (lang_id);

CREATE TABLE translation_status(
   status_id          NUMBER(2)    NOT NULL,
   translation_status VARCHAR2(30)
);

ALTER TABLE translation_status ADD CONSTRAINT xlation_status_pk PRIMARY KEY (status_id);

CREATE TABLE category(
   cat_id  NUMBER(5) NOT NULL,
   parent_cat_id  NUMBER(5)
);

ALTER TABLE category ADD CONSTRAINT category_pk PRIMARY KEY (cat_id);

ALTER TABLE category ADD CONSTRAINT category_parent_fk FOREIGN KEY (parent_cat_id)
REFERENCES category(cat_id);

CREATE INDEX category_parent_idx ON category(parent_cat_id);


CREATE TABLE category_info(
   cat_id             NUMBER(5) NOT NULL,
   lang_id                 NUMBER(3) NOT NULL,
   uv_category_title       VARCHAR2(100) NOT NULL,
   uv_category_description VARCHAR2(100),
   translation_status_id   NUMBER(2) NOT NULL
);


ALTER TABLE category_info ADD CONSTRAINT category_info_pk PRIMARY KEY (cat_id, lang_id);

ALTER TABLE category_info ADD CONSTRAINT cat_info_lang_id_fk FOREIGN KEY (lang_id)
REFERENCES languages(lang_id);

ALTER TABLE category_info ADD CONSTRAINT cat_info_xlat_stat_fk FOREIGN KEY(translation_status_id) 
REFERENCES translation_status(status_id);

ALTER TABLE category_info ADD CONSTRAINT cat_info_cat_id_fk FOREIGN KEY (cat_id) 
REFERENCES category(cat_id);



CREATE TABLE book(
   book_id       NUMBER(10)   NOT NULL,
   sales_status  VARCHAR2(10) DEFAULT 'ONSALE' CHECK(sales_status IN ('ONSALE','BACKORDER','WITHDRAWN')) NOT NULL,
   isbn          VARCHAR2(17) NOT NULL,
   cat_id        NUMBER(10)   NOT NULL,
   uv_author     VARCHAR2(100) NOT NULL
);

ALTER TABLE book ADD CONSTRAINT book_pk PRIMARY KEY (book_id);

ALTER TABLE book ADD CONSTRAINT book_cat_fk FOREIGN KEY(cat_id)
REFERENCES category(cat_id);




CREATE TABLE book_info(
   book_id            NUMBER(10) NOT NULL,
   lang_id            NUMBER(3)  NOT NULL,
   sale_status        VARCHAR2(9) CHECK (sale_status IN ('ONSALE','AVAILABLE','OFFLINE')),
   translation_status_id  NUMBER(2),
   --
   -- User Visible Columns - (UV prefix)
   --
   uv_title           VARCHAR2(255) NOT NULL,
   uv_description     VARCHAR2(4000),
   uv_description_big CLOB
);

ALTER TABLE book_info ADD CONSTRAINT book_info_pk PRIMARY KEY (book_id,lang_id);

ALTER TABLE book_info ADD CONSTRAINT book_info_lang_id_fK FOREIGN KEY(lang_id) 
REFERENCES languages(lang_id);

ALTER TABLE book_info ADD CONSTRAINT book_info_book_id_fk FOREIGN KEY(book_id) 
REFERENCES book(book_id);

ALTER TABLE book_info ADD CONSTRAINT book_info_xlat_stat_fk FOREIGN KEY(translation_status_id) 
REFERENCES translation_status(status_id);


CREATE TABLE recomm_books(
   book_id            NUMBER(10) NOT NULL,
   recomm_book_id    NUMBER(10) NOT NULL,
   recomm_score   NUMBER(1)  NOT NULL
);

ALTER TABLE recomm_books ADD CONSTRAINT recomm_books_pk PRIMARY KEY (book_id,recomm_book_id);

ALTER TABLE recomm_books ADD CONSTRAINT recomm_books_src_fk FOREIGN KEY(book_id) 
REFERENCES book(book_id);

ALTER TABLE recomm_books ADD CONSTRAINT recomm_books_trg_fk FOREIGN KEY(recomm_book_id) 
REFERENCES book(book_id);



CREATE TABLE prices(
   book_id               NUMBER(10)  NOT NULL,
   uv_price              NUMBER(8,2) NOT NULL,
   price_valid_from      DATE        NOT NULL
);


ALTER TABLE prices ADD CONSTRAINT prices_pk 
PRIMARY KEY(book_id,price_valid_from);

ALTER TABLE prices ADD CONSTRAINT prices_book_fk FOREIGN KEY(book_id)
REFERENCES book(book_id);


CREATE TABLE customer(
   cust_id        NUMBER(10) NOT NULL,
   username       VARCHAR2(50) NOT NULL,
   password_hash  VARCHAR2(50),
   account_created    DATE DEFAULT SYSDATE NOT NULL,
   account_status VARCHAR2(20) CHECK(account_status IN ('REGISTERED','CONFIRMED','VERIFIED','QUARANTINED')) NOT NULL,
   email_address  VARCHAR2(150) NOT NULL,
   ue_title       VARCHAR2(20) NULL,
   ue_first_name  VARCHAR2(50) NOT NULL,
   ue_middle_initials  VARCHAR2(20),
   ue_last_name   VARCHAR2(50) NOT NULL,
   ue_review_pseudonym   VARCHAR2(50) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY (cust_id);
ALTER TABLE customer ADD CONSTRAINT customer_uk UNIQUE (username);
CREATE UNIQUE INDEX customer_pseudoym_idx ON customer(ue_review_pseudonym);





CREATE TABLE customer_addresses(
   addr_id      NUMBER(10) NOT NULL,
   cust_id      NUMBER(10) NOT NULL,
   display_order   NUMBER(5)  NOT NULL,
   address_type CHAR(1) CHECK(address_type  IN ('B','S')) NOT NULL,
   default_address CHAR(1) CHECK(default_address IN ('Y','N')),
   ue_address_line_1        VARCHAR2(100),
   ue_address_line_2        VARCHAR2(100),
   ue_address_line_3        VARCHAR2(100),
   ue_address_line_4        VARCHAR2(100),
   ue_address_city          VARCHAR2(100),
   ue_address_region        VARCHAR2(100),
   ue_address_country       VARCHAR2(100),
   ue_address_postzip_code  VARCHAR2(100)
);

ALTER TABLE customer_addresses ADD CONSTRAINT cust_pk 
PRIMARY KEY (addr_id);

ALTER TABLE customer_addresses ADD CONSTRAINT cust_add_cust_fk
FOREIGN KEY (cust_id) REFERENCES customer(cust_id);


CREATE TABLE payment_methods(
   payment_method_id        NUMBER(5) NOT NULL,
   payment_method_code      VARCHAR2(6) NOT NULL,
   uv_payment_method_name   VARCHAR2(30) NOT NULL
);

ALTER TABLE payment_methods ADD CONSTRAINT payment_methods_pk
PRIMARY KEY (payment_method_id);


CREATE TABLE customer_orders(
   order_id NUMBER(10)    NOT NULL,
   cust_id  NUMBER(10)    NOT NULL,
   date_order_placed      TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
   total_order_price      NUMBER(8,2) NOT NULL,
   payment_method_id      NUMBER(5) NOT NULL,
   payment_status         VARCHAR2(20) NOT NULL,
   card_number            VARCHAR2(64) NOT NULL,
   expiry_date            VARCHAR2(4) NOT NULL,
   shipping_addr_id       NUMBER(10) NOT NULL,
   billing_addr_id        NUMBER(10) NOT NULL
);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_pk 
PRIMARY KEY (order_id);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_cust_fk
FOREIGN KEY (cust_id) REFERENCES customer(cust_id);

ALTER TABLE customer_orders ADD CONSTRAINT customer_orderd_paymet_fk
FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_ship_add_fk
FOREIGN KEY (shipping_addr_id) REFERENCES customer_addresses(addr_id);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_bill_add_fk
FOREIGN KEY (billing_addr_id) REFERENCES customer_addresses(addr_id);


CREATE TABLE order_items(
   order_id NUMBER(10)    NOT NULL,
   item_id  NUMBER(5)     NOT NULL,
   book_id  NUMBER(10)    NOT NULL,
   quantity_ordered NUMBER(5)     NOT NULL,
   price_when_ordered     NUMBER(8,2) NOT NULL
);

ALTER TABLE order_items ADD CONSTRAINT order_items_pk
PRIMARY KEY (order_id, item_id);

ALTER TABLE order_items ADD CONSTRAINT order_items_order_id_fk
FOREIGN KEY (order_id) REFERENCES customer_orders(order_id);

ALTER TABLE order_items ADD CONSTRAINT order_items_book_id_fk
FOREIGN KEY (book_id) REFERENCES book(book_id);


CREATE TABLE customer_reviews(
   cust_id  NUMBER(10)    NOT NULL,
   book_id  NUMBER(10)    NOT NULL,
   moderation_status      VARCHAR2(10) DEFAULT 'PENDING' CHECK (moderation_status IN ('PENDING','CLEARED','REJECTED')) NOT NULL,
   moderation_comment     VARCHAR2(255) NULL,
   date_last_edited       DATE DEFAULT SYSDATE NOT NULL,
   ue_review_text   VARCHAR2(4000) NOT NULL
);


ALTER TABLE customer_reviews ADD CONSTRAINT customer_reviews_pk
PRIMARY KEY (book_id, cust_id);

CREATE INDEX customer_reviews_cust_id ON customer_reviews(cust_id);

ALTER TABLE customer_reviews ADD CONSTRAINT customer_reviews_book_fk
FOREIGN KEY (book_id) REFERENCES book(book_id);

ALTER TABLE customer_reviews ADD CONSTRAINT customer_reviews_cust_fk
FOREIGN KEY (cust_id) REFERENCES customer(cust_id);



















@schema/master_ss_logs.sql




create sequence seq_book_id  start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_cust_id  start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_cat_id   start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_item_id  start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_lang_id  start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_order_id start with 1 increment by 1 nomaxvalue nocycle;
create sequence seq_addr_id  start with 1 increment by 1 nomaxvalue nocycle;


@schema/func_get_books_recomm.sql
@schema/func_get_book_price_at_time.sql




connect &&READONLYUSERNAME/&&READONLYPASSWORD@&&READONLYDB




CREATE DATABASE LINK &&MASTERDB connect to &&MASTERUSERNAME identified by &&MASTERPASSWORD USING 'TNS:&&MASTERDB';

@schema/read_only_ss.sql

connect &&MASTERUSERNAME/&&MASTERPASSWORD@&&MASTERDB
