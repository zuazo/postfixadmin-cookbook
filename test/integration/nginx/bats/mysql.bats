#!/usr/bin/env bats

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

@test "mysql is running" {
  lsof -cmysqld -a -iTCP:mysql
}
