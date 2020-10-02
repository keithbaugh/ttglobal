#!/usr/bin/ksh


function get_order
{
sqlplus keith/keith@schmast <<EOF

create table temp_refs as select table_name, constraint_name, CAST(NULL as VARCHAR2(30)) as r_constraint_name   from user_constraints b
where constraint_type like 'P'
/

insert into temp_refs select table_name, constraint_name, r_constraint_name from user_constraints where constraint_type like 'R'
/

set pages 100
PROMPT  Load Order of Table Set, this will also set the snapshot refresh group ordering...
select 'RESULT' as flag, max(lvl), table_name
FROM (
   select level as lvl, t.* from temp_refs t
   start with t.r_constraint_name IS NULL
   connect by prior t.constraint_name = t.r_constraint_name
) 
GROUP BY table_name
ORDER BY 3 
/

drop table temp_refs
/

purge recyclebin
/

exit
EOF
}

TABLIST=$(get_order |grep '^RESULT' |awk '{print $3}')

rm -f schema/read_only_ss.sql schema/master_ss_logs.sql

COMTAB=''
COMMA=''
for TAB in $TABLIST
do
   grep -i "CREATE TABLE $TAB(" tt.ddl |sed 's/CREATE TABLE \(.*\)(/CREATE SNAPSHOT \1 REFRESH FAST AS SELECT * FROM \1\@schmast;/' >> schema/read_only_ss.sql
   grep -i "CREATE TABLE $TAB(" tt.ddl |sed 's/CREATE TABLE \(.*\)(/CREATE SNAPSHOT LOG ON \1;/' >> schema/master_ss_logs.sql
   COMTAB=$(echo "$COMTAB$COMMA$TAB")
   COMMA=','
done

echo "
BEGIN

   dbms_refresh.make(
      name => 'bookstore_copy_group',
      list => '$COMTAB',
      next_date => SYSDATE,
      interval => 'SYSDATE+1/1440');

END;
/
" >> schema/read_only_ss.sql
