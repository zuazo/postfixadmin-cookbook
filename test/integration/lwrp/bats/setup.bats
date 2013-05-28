#!/usr/bin/env bats

@test "setup.php should return that everything is fine" {
  wget -qO- 'localhost/setup.php' | grep -qF 'Everything seems fine'
}

@test "setup.php should create the database" {
  wget -qO- 'localhost/setup.php' | grep -qF 'Database is up to date'
}

