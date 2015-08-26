#!/bin/sh

if [ -z "$DB_ADDRESS" ]; then
	echo "FOO is empty"
else
	echo "FOO is $FOO"
fi

if [ -z "$DB_PASS" ]; then
        echo "FOO is empty"
else
        echo "FOO is $FOO"
fi

if [ -z "$SMTP_HOST" ]; then
        echo "FOO is empty"
else
        echo "FOO is $FOO"
fi

if [ -z "$ADMIN_EMAIL" ]; then
        echo "FOO is empty"
else
        echo "FOO is $FOO"
fi

