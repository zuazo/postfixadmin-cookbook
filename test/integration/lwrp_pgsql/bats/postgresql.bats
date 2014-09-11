#!/usr/bin/env bats

@test "postgresql should be running" {
  LSOF="$(which lsof || true)"
  [ x"${LSOF}" = x ] && LSOF='/usr/sbin/lsof'
  "${LSOF}" -cpostmaster -a -iTCP:postgres
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
