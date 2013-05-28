#!/usr/bin/env bats

@test "setup.php should return that everything is fine" {
  wget --no-check-certificate -qO- 'https://localhost/setup.php' | grep -qF 'Everything seems fine'
}

@test "setup.php should create the database" {
  wget --no-check-certificate -qO- 'https://localhost/setup.php' | grep -qF 'Database is up to date'
}

