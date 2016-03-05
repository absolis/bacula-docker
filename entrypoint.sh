#!/bin/sh

sed -i 's/^\s*\(dbname\s*=\s*\).*\(user\s*=\s*\).*\(password\s*=\s*\).*$/
\1$DB_NAME \2$DB_USER \3$DB_PASS/' /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Address' /opt/bacula/etc/bacula-dir.conf &&  sed -i 's/\(DB\sAddress\s*=\s*\).*/\1$DB_HOST/' /opt/bacula/etc/bacula-dir.conf || sed -i 's/\(^.*dbname.*$\)/\1\nDB Address = $DB_HOST/' /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Port' /opt/bacula/etc/bacula-dir.conf &&  sed -i 's/\(DB\sPort\s*=\s*\).*/\1$DB_PORT/' /opt/bacula/etc/bacula-dir.conf || sed -i 's/\(^.*DB\sAddress.*$\)/\1\nDB Port = $DB_PORT/' /opt/bacula/etc/bacula-dir.conf

$db_name = $DB_NAME

# add mysql creation of db if not exists
case ${DB_TYPE} in
	mysql)
		/opt/bacula/etc/create_bacula_database mysql -u $DB_USER ${DB_PASS:+"-p $DB_PASS"} ${DB_HOST:+"-h $DB_HOST"} ${DB_PORT:+"-P $DB_PORT"}
		/opt/bacula/etc/make_bacula_tables mysql -u $DB_USER ${DB_PASS:+"-p $DB_PASS"} ${DB_HOST:+"-h $DB_HOST"} ${DB_PORT:+"-P $DB_PORT"}
		;;
	postgresql)
		/opt/bacula/etc/create_bacula_database postgresql -U $DB_USER ${DB_PASS:+"-W $DB_PASS"} ${DB_HOST:+"-h $DB_HOST"} ${DB_PORT:+"-p $DB_PORT"}
		/opt/bacula/etc/make_bacula_tables postgresql -U $DB_USER ${DB_PASS:+"-W $DB_PASS"} ${DB_HOST:+"-h $DB_HOST"} ${DB_PORT:+"-p $DB_PORT"}
		;;
	sqlite)
		/opt/bacula/etc/create_bacula_database sqlite
		/opt/bacula/etc/make_bacula_tables sqlite 
		;;
else if [[$DB_TYPE==]]

bacula start