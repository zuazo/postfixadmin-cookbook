#!/usr/bin/env bats

@test "postgresql is running" {
  ps axu | grep -q 'postgre[s]'
}

@test "creates an admin user" {
  echo "SELECT 'OK' FROM admin WHERE username = 'admin@admin.org'" \
    | PGPASSWORD=postfix_pass psql -h 127.0.0.1 -U postfix \
    | grep -Fq OK
}

@test "creates a domain" {
  echo "SELECT 'OK' FROM domain WHERE domain = 'foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h 127.0.0.1 -U postfix \
    | grep -Fq OK
}

@test "creates a mailbox" {
  echo "SELECT 'OK' FROM mailbox WHERE username = 'postmaster@foobar.com' AND domain = 'foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h 127.0.0.1 -U postfix \
    | grep -Fq OK
}

@test "creates an alias" {
  echo "SELECT 'OK' FROM alias WHERE address = 'admin@foobar.com' AND goto = 'postmaster@foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h 127.0.0.1 -U postfix \
    | grep -Fq OK
}
