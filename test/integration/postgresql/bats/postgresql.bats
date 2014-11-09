#!/usr/bin/env bats

@test "postgresql is running" {
  ps axu | grep -q 'postgre[s]'
}
