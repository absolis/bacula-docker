#!/bin/sh

#configure DB_PORT on default

if [ -z $DB_PORT ] && [ -n $DB_HOST ] && [ $DB_HOST != localhost ] && [ $DB_HOST != 127.0.0.1 ]; then
	case ${DB_TYPE} in
		mysql)
			export DB_PORT=3306
			;;
		postgresql)
			export DB_PORT=5432
			;;
	esac
fi

# Change config settings on bacula-dir.conf

sed -i "s/\(Director\s*{\s*\n\s*Name\s=\s\).*$/\1$DIR_NAME/" /opt/bacula/etc/bacula-dir.conf

sed -i "s/\(^\s*dbname\s*=\s*\).*\s*\(user\s*=\s*\).*\s*\(password\s*=\s*\).*$/\1$DB_NAME\ \2$DB_USER\ \3$DB_PASS/" /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Address' /opt/bacula/etc/bacula-dir.conf &&  sed -i "s/\(DB\sAddress\s*=\s*\).*/\1$DB_HOST/" /opt/bacula/etc/bacula-dir.conf || sed -i "s/\(^.*dbname.*$\)/\1\n  DB Address = $DB_HOST/" /opt/bacula/etc/bacula-dir.conf

grep -q 'DB Port' /opt/bacula/etc/bacula-dir.conf &&  sed -i "s/\(DB\sPort\s*=\s*\).*/\1$DB_PORT/" /opt/bacula/etc/bacula-dir.conf || sed -i "s/\(^.*DB\sAddress.*$\)/\1\n  DB Port = $DB_PORT/" /opt/bacula/etc/bacula-dir.conf



# add mysql creation of db if not exists
export db_name=$DB_NAME
case ${DB_TYPE} in
	mysql)
		/opt/bacula/etc/create_bacula_database mysql -u $DB_USER ${DB_PASS:+-p$DB_PASS} ${DB_HOST:+-h $DB_HOST} ${DB_PORT:+-P $DB_PORT}
		/opt/bacula/etc/make_bacula_tables mysql -u $DB_USER ${DB_PASS:+-p$DB_PASS} ${DB_HOST:+-h $DB_HOST} ${DB_PORT:+-P $DB_PORT}
		;;
	postgresql)
		/opt/bacula/etc/create_bacula_database postgresql -U $DB_USER ${DB_PASS:+-W$DB_PASS} ${DB_HOST:+-h $DB_HOST} ${DB_PORT:+-p $DB_PORT}
		/opt/bacula/etc/make_bacula_tables postgresql -U $DB_USER ${DB_PASS:+-W$DB_PASS} ${DB_HOST:+-h $DB_HOST} ${DB_PORT:+-p $DB_PORT}
		;;
	sqlite)
		/opt/bacula/etc/create_bacula_database sqlite
		/opt/bacula/etc/make_bacula_tables sqlite 
		;;
esac
# Change message settings

Messages="Messages {\n"
Messages="$Messages   Name = Standard\n"
Messages="$Messages   mailcommand = \"/home/bacula/bin/bsmtp -h ${SMTP_HOST:-localhost}\n"
Messages="$Messages                 -f \\\"\\(Bacula\\) %r\\\"\n"
Messages="$Messages                 -s \\\"Bacula: %t %e of %c %l\\\" %r\"\n"
Messages="$Messages   operatorcommand = \"/home/bacula/bin/bsmtp -h localhost\n"
Messages="$Messages                 -f \\\"\\(Bacula\\) %r\\\"\n"
Messages="$Messages                 -s \\\"Bacula: Intervention needed for %j\\\" %r\"\n"
Messages="$Messages   Mail = ${ADMIN_EMAIL} = all, !skipped, !terminate\n"
Messages="$Messages   append = \"/home/bacula/bin/log\" = all, !skipped, !terminate\n"
Messages="$Messages   operator = ${ADMIN_EMAIL} = mount\n"
Messages="$Messages   console = all, !skipped, !saved/\n"
Messages="$Messages }\n"

sed -i 's/Messages\s*{\s*Name = Standard.*!skipped$^}/$Messages/' /opt/bacula/etc/bacula-dir.conf

bacula start -d