#!/bin/sh

#configure DB_PORT on default

if [[-z  $DB_PORT]] && [[-n $DB_HOST]] && [[$DB_HOST != localhost]] && [[$DB_HOST != 127.0.0.1]]; then
	case ${DB_TYPE}
		mysql)
			$DB_PORT=3306
			;;
		postgresql)
			$DB_PORT=5432
			;;
	esac
fi

# Change config settings on bacula-dir.conf

sed -i 's/^\s*\(dbname\s*=\s*\).*\(user\s*=\s*\).*\(password\s*=\s*\).*$/
\1$DB_NAME \2$DB_USER \3$DB_PASS/' /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Address' /opt/bacula/etc/bacula-dir.conf &&  sed -i 's/\(DB\sAddress\s*=\s*\).*/\1$DB_HOST/' /opt/bacula/etc/bacula-dir.conf || sed -i 's/\(^.*dbname.*$\)/\1\nDB Address = $DB_HOST/' /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Port' /opt/bacula/etc/bacula-dir.conf &&  sed -i 's/\(DB\sPort\s*=\s*\).*/\1$DB_PORT/' /opt/bacula/etc/bacula-dir.conf || sed -i 's/\(^.*DB\sAddress.*$\)/\1\nDB Port = $DB_PORT/' /opt/bacula/etc/bacula-dir.conf



# add mysql creation of db if not exists
$db_name = $DB_NAME
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

# Change message settings

sed -i '/s/Messages\s{.*!skipped$^}/
Messages {
  Name = Standard
  mailcommand = "/home/bacula/bin/bsmtp -h ${SMTP_HOST:-localhost}
                -f \"\(Bacula\) %r\"
                -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/home/bacula/bin/bsmtp -h localhost
                -f \"\(Bacula\) %r\"
                -s \"Bacula: Intervention needed for %j\" %r"
  Mail = ${ADMIN_EMAIL} = all, !skipped, !terminate
  append = "/home/bacula/bin/log" = all, !skipped, !terminate
  operator = ${ADMIN_EMAIL} = mount
  console = all, !skipped, !saved/
}'

bacula start