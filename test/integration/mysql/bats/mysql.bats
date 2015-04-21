#!/usr/bin/env bats

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

@test "mysql is running" {
  lsof -cmysqld -a -iTCP:mysql
}

@test "creates an admin user" {
  echo "SELECT 'OK' FROM admin WHERE username = 'admin@admin.org'" \
    | mysql -h127.0.0.1 -upostfix -ppostfix_pass postfix \
    | grep -Fq OK
}

@test "creates a domain" {
  echo "SELECT 'OK' FROM domain WHERE domain = 'foobar.com'" \
    | mysql -h127.0.0.1 -upostfix -ppostfix_pass postfix \
    | grep -Fq OK
}

@test "creates a mailbox" {
  echo "SELECT 'OK' FROM mailbox WHERE username = 'postmaster@foobar.com' AND domain = 'foobar.com'" \
    | mysql -h127.0.0.1 -upostfix -ppostfix_pass postfix \
    | grep -Fq OK
}

@test "creates an alias" {
  echo "SELECT 'OK' FROM alias WHERE address = 'admin@foobar.com' AND goto = 'postmaster@foobar.com'" \
    | mysql -h127.0.0.1 -upostfix -ppostfix_pass postfix \
    | grep -Fq OK
}
