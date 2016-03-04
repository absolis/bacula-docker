#!/bin/sh

cd /opt/bacula/etc

sed -i 's/^\s*\(dbname\s*=\s*\).*\(user\s*=\s*\).*\(password\s*=\s*\).*$/
\1$DB_NAME \2$DB_USER \3$DB_PASS/' bacula-dir.conf

grep -q 'DB Address' bacula-dir.conf &&  sed -i 's/\(DB\sAddress\s*=\s*\).*/\1$DB_HOST/' bacula-dir.conf || \
	sed -i 's/\(^.*dbname.*$\)/\1\nDB Address = $DB_HOST/' bacula-dir.conf

grep -q 'DB Port' bacula-dir.conf &&  sed -i 's/\(DB\sPort\s*=\s*\).*/\1$DB_PORT/' bacula-dir.conf || \
	sed -i 's/\(^.*DB\sAddress.*$\)/\1\nDB Port = $DB_PORT/' bacula-dir.conf


# add mysql creation of db if not exists

bacula start