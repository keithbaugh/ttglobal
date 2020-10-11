set lines 200

select 
   trunc(co.date_order_placed,'MONTH') as month, 
   sum(price_when_ordered*quantity_ordered), 
   sum(price_when_ordered), 
   sum(quantity_ordered)
FROM 
   customer_orders co,
   order_items     oi,
   book            bk
where 
   oi.order_id = co.order_id AND
   oi.book_id  = bk.book_id AND
   bk.cat_id = 136
group by trunc(co.date_order_placed,'MONTH')
/
