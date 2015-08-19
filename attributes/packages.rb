# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Attributes:: packages
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['postfixadmin']['packages']['requirements'] =
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'fedora', 'amazon'
    if node['platform_version'].to_f < 6.0
      %w(php53-imap php53-mbstring)
    else
      %w(php-imap php-mbstring)
    end
  else
    %w(php5-imap)
  end

default['postfixadmin']['packages']['mysql'] =
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'fedora', 'amazon'
    node['platform_version'].to_f < 6.0 ? %w(php53-mysql) : %w(php-mysql)
  else
    %w(php5-mysql)
  end
default['postfixadmin']['packages']['postgresql'] =
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'fedora', 'amazon'
    node['platform_version'].to_f < 6.0 ? %w(php53-pgsql) : %w(php-pgsql)
  else
    %w(php5-pgsql)
  end
