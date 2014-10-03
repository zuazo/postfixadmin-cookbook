#!/usr/bin/env bats

@test "postgresql should be running" {
  ps axu | grep -q 'postgre[s]'
}

@test "should create an admin user" {
  echo "SELECT 'OK' FROM admin WHERE username = 'admin@admin.org'" \
    | PGPASSWORD=postfix_pass psql -h localhost -U postfix \
    | grep -Fq OK
}

@test "should create a domain" {
  echo "SELECT 'OK' FROM domain WHERE domain = 'foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h localhost -U postfix \
    | grep -Fq OK
}

@test "should create a mailbox" {
  echo "SELECT 'OK' FROM mailbox WHERE username = 'postmaster@foobar.com' AND domain = 'foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h localhost -U postfix \
    | grep -Fq OK
}

@test "should create an alias" {
  echo "SELECT 'OK' FROM alias WHERE address = 'admin@foobar.com' AND goto = 'postmaster@foobar.com'" \
    | PGPASSWORD=postfix_pass psql -h localhost -U postfix \
    | grep -Fq OK
}
