--
-- Main DBA activies for building the Bookshop Schemas and granting system privileges...
--

-- Source all the run-time build parameters...

@@envs.sql

set verify off

--                  _                _ _       
--    _ __  __ _ __| |_ ___ _ _   __(_) |_ ___ 
--   | '  \/ _` (_-<  _/ -_) '_| (_-< |  _/ -_)
--   |_|_|_\__,_/__/\__\___|_|   /__/_|\__\___|
--  


connect sys/&&SYSPASSMASTER@&&MASTERDB as sysdba;

drop user &&MASTERUSERNAME cascade;

create user &&MASTERUSERNAME identified by &&MASTERPASSWORD default tablespace &&DEFTABLESPACE;

grant create session        to  &&MASTERUSERNAME;
grant create table          to  &&MASTERUSERNAME;
grant create procedure      to  &&MASTERUSERNAME;
grant create database link  to  &&MASTERUSERNAME;
grant create sequence       to  &&MASTERUSERNAME;
alter user &&MASTERUSERNAME quota unlimited on &&DEFTABLESPACE;


--                    _            _           _ _       
--    _ _ ___ __ _ __| |  ___ _ _ | |_  _   __(_) |_ ___ 
--   | '_/ -_) _` / _` | / _ \ ' \| | || | (_-< |  _/ -_)
--   |_| \___\__,_\__,_| \___/_||_|_|\_, | /__/_|\__\___|
--                                   |__/    

connect sys/&&SYSPASSREADONLY@&&READONLYDB as sysdba;

drop user &&READONLYUSERNAME cascade;

create user &&READONLYUSERNAME identified by &&READONLYPASSWORD default tablespace &&DEFTABLESPACE;

grant create session        to  &&READONLYUSERNAME;
grant create table          to  &&READONLYUSERNAME;
grant create procedure      to  &&READONLYUSERNAME;
grant create snapshot       to  &&READONLYUSERNAME;
grant create database link  to  &&READONLYUSERNAME;
grant create sequence       to  &&READONLYUSERNAME;
alter user &&READONLYUSERNAME quota unlimited on &&DEFTABLESPACE;



