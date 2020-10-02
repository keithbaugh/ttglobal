set lines 200
col title format a150
set pages 200

select 
   level,
   c.cat_id, c.parent_cat_id ,
   LPAD('  ',level-1)||i.uv_category_title as title
from 
   category c, category_info i
where 
   c.cat_id = i.cat_id 
start with c.parent_cat_id IS NULL
connect by prior c.cat_id = c.parent_cat_id
/
