#!/usr/bin/env bats

@test "postgresql should be running" {
  ps axu | grep -q 'postgre[s]'
}
