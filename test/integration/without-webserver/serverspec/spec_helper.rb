# encoding: UTF-8
# encoding: UTF-8

require 'serverspec'

include Serverspec::Helper::Ssh
include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec
include Serverspec::Helper::Properties

properties = {}
properties[:os] =
  Backend.backend_for('exec').check_os

set_property properties
