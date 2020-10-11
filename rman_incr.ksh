#!/usr/bin/ksh

ORACLE_SID=SCHMAST
NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'
HOME=/home/oracle

NLSPATH=/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/en_US/%N:/usr/lib/nls/msg/%L/%N.cat:/usr/lib/nls/msg/en_US/%N.cat:/usr/lib/nls/msg/%l.%c/%N:/usr/lib/nls/msg/%l.%c/%N.cat

ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
PATH=$ORACLE_HOME/bin/:/usr/local/bin:/home/oracle/adapt_2010/sch/release_1_0/bin:/u01/app/oracle/product/11.2.0/database/bin:/home/oracle/adapt_2010/bin:/u01/app/oracle/product/11.2.0/database/jre/1.4.2/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/home/oracle/bin:/usr/bin/X11:/sbin:.

export ORACLE_SID NLS_DATE_FORMAT ORACLE_HOME NLS_PATH


rman <<EOF
connect target /
@backup_incr.rman
EOF

