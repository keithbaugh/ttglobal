DROP TABLE languages cascade constraints;
DROP TABLE translation_status cascade constraints;
DROP TABLE category cascade constraints;
DROP TABLE category_info cascade constraints;
DROP TABLE book cascade constraints;
DROP TABLE book_info cascade constraints;
DROP TABLE book_prices cascade constraints;
DROP TABLE book_categories cascade constraints;
DROP TABLE customer cascade constraints;
DROP TABLE customer_addresses cascade constraints;
DROP TABLE customer_orders cascade constraints;
DROP TABLE order_items cascade constraints;
DROP TABLE shipment_items cascade constraints;




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
   cat_id  NUMBER(5)
);

ALTER TABLE category ADD CONSTRAINT category_pk PRIMARY KEY (cat_id);

CREATE TABLE category_info(
   cat_id             NUMBER(5) NOT NULL,
   lang_id                 NUMBER(3) NOT NULL,
   uv_category_description VARCHAR2(100) NOT NULL,
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
   book_id   NUMBER(10)   NOT NULL,
   isbn      VARCHAR2(17) NOT NULL
);

ALTER TABLE book ADD CONSTRAINT book_pk PRIMARY KEY (book_id);


CREATE TABLE book_info(
   book_id            NUMBER(10) NOT NULL,
   lang_id            NUMBER(3)  NOT NULL,
   sale_status        VARCHAR2(9) CHECK (sale_status IN ('AVAILABLE','OFFLINE')),
   translation_status_id  NUMBER(2),
   --
   -- User Visible Columns - (UV prefix)
   --
   uv_title           VARCHAR2(100) NOT NULL,
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



CREATE TABLE book_prices(
   book_id               NUMBER(10)  NOT NULL,
   uv_price              NUMBER(8,2) NOT NULL,
   price_valid_from      DATE        NOT NULL
);


ALTER TABLE book_prices ADD CONSTRAINT book_prices_pk 
PRIMARY KEY(book_id,price_valid_from);


CREATE TABLE book_categories(
   book_id    NUMBER(10) NOT NULL,
   cat_id     NUMBER(5)  NOT NULL
);

ALTER TABLE book_categories ADD CONSTRAINT book_categories_pk PRIMARY KEY (book_id, cat_id);

ALTER TABLE book_categories ADD CONSTRAINT book_cat_cat_fk FOREIGN KEY(cat_id) 
REFERENCES category(cat_id);


ALTER TABLE book_categories ADD CONSTRAINT book_cat_book_id_fk FOREIGN KEY(book_id) 
REFERENCES book(book_id);


CREATE TABLE customer(
   cust_id        NUMBER(10) NOT NULL,
   username       VARCHAR2(50) NOT NULL,
   password_hash  VARCHAR2(50) NOT NULL,
   account_created    DATE NOT NULL,
   account_status VARCHAR2(20) CHECK(account_status IN ('REGISTERED','CONFIRMED','VERIFIED','QUARANTINED')) NOT NULL,
   email_address  VARCHAR2(150) NOT NULL,
   uv_title       VARCHAR2(20) NULL,
   uv_first_name  VARCHAR2(50) NULL,
   uv_middle_initials  VARCHAR2(20) NOT NULL,
   uv_last_name   VARCHAR2(50) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY (cust_id);
ALTER TABLE customer ADD CONSTRAINT customer_uq UNIQUE (username);


CREATE TABLE customer_addresses(
   cust_id      NUMBER(10) NOT NULL,
   view_order   NUMBER(5)  NOT NULL,
   address_type CHAR(1) CHECK(address_type  IN ('B','S')) NOT NULL,
   default_address CHAR(1) CHECK(default_address IN ('Y','N'))
);

ALTER TABLE customer_addresses ADD CONSTRAINT cust_pk 
PRIMARY KEY (cust_id, view_order) 
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE customer_addresses ADD CONSTRAINT cust_add_cust_fk
FOREIGN KEY (cust_id) REFERENCES customer(cust_id);

CREATE TABLE customer_orders(
   order_id NUMBER(10)    NOT NULL,
   cust_id  NUMBER(10)    NOT NULL,
   date_order_placed      DATE NOT NULL,
   payment_status         VARCHAR2(20) NOT NULL
);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_pk 
PRIMARY KEY (order_id);

ALTER TABLE customer_orders ADD CONSTRAINT cust_ord_cust_fk
FOREIGN KEY (cust_id) REFERENCES customer(cust_id);


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




CREATE TABLE shipment_items(
   shipment_id            NUMBER(10),
   shipment_status        VARCHAR2(10),
   shipment_date          DATE,
   order_id NUMBER(10)    NOT NULL,
   item_id  NUMBER(5)     NOT NULL,
   quantity_shipped NUMBER(5)     NOT NULL
);

ALTER TABLE shipment_items ADD CONSTRAINT shipment_items_pk
PRIMARY KEY (shipment_id)

ALTER TABLE shipment_items ADD CONSTRAINT ship_items_ord_itm_fk
FOREIGN KEY (order_id, item_id) REFERENCES order_items(order_id, item_id);




































