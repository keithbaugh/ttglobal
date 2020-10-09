alter session set nls_date_format = 'DD-MONYYYY HH24:MI:SS'
/


select 
   mview_name,
   FAST_REFRESHABLE,
   LAST_REFRESH_TYPE,
   LAST_REFRESH_DATE
FROM 
   user_mviews
/

PROMPT current time
select sysdate from dual;
