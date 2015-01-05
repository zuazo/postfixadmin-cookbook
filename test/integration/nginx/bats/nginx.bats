#!/usr/bin/env bats

@test "should return nginx server header" {
  wget -q -S 'postfixadmin.local' -O- 2>&1 | grep -qF 'Server: nginx'
}
