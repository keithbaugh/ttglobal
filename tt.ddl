DROP TABLE languages cascade constraints;
DROP TABLE translation_status cascade constraints;
DROP TABLE category cascade constraints;
DROP TABLE category_info cascade constraints;
DROP TABLE book cascade constraints;
DROP TABLE book_info cascade constraints;
DROP TABLE book_categories cascade constraints;
DROP TABLE address cascade constraints;
DROP TABLE customer cascade constraints;

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



CREATE TABLE book_categories(
   book_id    NUMBER(10) NOT NULL,
   cat_id     NUMBER(5)  NOT NULL
);

ALTER TABLE book_categories ADD CONSTRAINT book_categories_pk PRIMARY KEY (book_id, cat_id);

ALTER TABLE book_categories ADD CONSTRAINT book_cat_cat_fk FOREIGN KEY(cat_id) 
REFERENCES category(cat_id);


ALTER TABLE book_categories ADD CONSTRAINT book_cat_book_id_fk FOREIGN KEY(book_id) 
REFERENCES book(book_id);


CREATE TABLE address(
   address_id   NUMBER(10) NOT NULL,
   -- Check for Boiler or shipping address types
   address_type CHAR(1) CHECK(address_type  IN ('B','S')) NOT NULL
);












































