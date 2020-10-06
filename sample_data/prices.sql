INSERT INTO prices (book_id, uv_price, price_valid_from)
SELECT book_id, 100*MOD(rownum,10) + 6.99, trunc(sysdate) FROM book;

INSERT INTO prices (book_id, uv_price, price_valid_from)
SELECT book_id, uv_price-1.50, 1+trunc(sysdate+mod(rownum,14)) FROM prices;

INSERT INTO prices (book_id, uv_price, price_valid_from) 
SELECT book_id, uv_price-1.99, trunc(sysdate+21+mod(rownum,21)) FROM prices;

