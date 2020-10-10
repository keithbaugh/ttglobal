
-- Source the run-time environment parameters...

@envs.sql

set verify off

PROMPT 
PROMPT ...............................................
PROMPT Table Name....                  Master ReadOnly
PROMPT ...............................................


set serveroutput on
DECLARE
   v_master_count NUMBER;
   v_readonly_count NUMBER;
BEGIN
   FOR tab IN (SELECT table_name from user_tables WHERE table_name NOT LIKE '%$%' ORDER BY table_name)
   LOOP
      execute immediate 'select count(*) from '||tab.table_name INTO v_master_count;
      execute immediate 'select count(*) from '||tab.table_name||'@&&READONLYDB' INTO v_readonly_count;
      dbms_output.put_line(RPAD(tab.table_name,30,' ')||LPAD(to_char(v_master_count),8,' ')||LPAD(to_char(v_readonly_count),8,' '));
   END LOOP;
END;
/
