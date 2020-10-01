-- As sys...
connect sys/port@schmast as sysdba;

create or replace directory strrep_scripts   AS '/u01/app/oracle/db_dirs/strrep_scripts';

create or replace directory strrep_data_pump_out AS '/u01/app/oracle/db_dirs/strrep_datapump_out';


create user str_admin identified by str_admin default tablespace adapt_data;


grant read  on directory strrep_scripts to str_admin;
grant write on directory strrep_scripts to str_admin;

grant read  on directory strrep_data_pump_out to str_admin;
grant write on directory strrep_data_pump_out to str_admin;

grant execute on dbms_streams_adm to str_admin;

grant create session       to str_admin;
grant create database link to str_admin;


connect str_admin/str_admin@schmast

create database link sch11.emea.hays.loc connect to keith identified by keith using '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = hrraxdv2032.emea.hays.loc)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = SCH11.emea.hays.loc)))'
/


