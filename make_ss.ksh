#!/usr/bin/ksh


function get_order
{
sqlplus keith/keith@schmast @rep <<EOF
exit
EOF
}

TABLIST=$(get_order |grep '^RESULT' |awk '{print $3}')

rm read_only_ss.sql master_ss_logs.sql

COMTAB=''
COMMA=''
for TAB in $TABLIST
do
   grep -i "CREATE TABLE $TAB(" tt.ddl |sed 's/CREATE TABLE \(.*\)(/CREATE SNAPSHOT \1 REFRESH FAST AS SELECT * FROM \1\@schmast;/' >> read_only_ss.sql
   grep -i "CREATE TABLE $TAB(" tt.ddl |sed 's/CREATE TABLE \(.*\)(/CREATE SNAPSHOT LOG ON \1;/' >> master_ss_logs.sql
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
" >> read_only_ss.sql
