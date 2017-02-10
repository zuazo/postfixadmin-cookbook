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

case node['platform']
when 'centos', 'redhat', 'scientific', 'fedora', 'amazon'
  if node['platform_version'].to_f < 6.0
    default['postfixadmin']['packages']['requirements'] =
      %w(php53-imap php53-mbstring)
    default['postfixadmin']['packages']['mysql'] = %w(php53-mysql)
    default['postfixadmin']['packages']['postgresql'] = %w(php53-pgsql)
  else
    default['postfixadmin']['packages']['requirements'] =
      %w(php-imap php-mbstring)
    default['postfixadmin']['packages']['mysql'] = %w(php-mysql)
    default['postfixadmin']['packages']['postgresql'] = %w(php-pgsql)
  end
when 'ubuntu'
  if node['platform_version'].to_f < 16.0
    default['postfixadmin']['packages']['requirements'] = %w(php5-imap)
    default['postfixadmin']['packages']['mysql'] = %w(php5-mysql)
    default['postfixadmin']['packages']['postgresql'] = %w(php5-pgsql)
  else
    default['postfixadmin']['packages']['requirements'] = %w(php-imap)
    default['postfixadmin']['packages']['mysql'] = %w(php-mysql)
    default['postfixadmin']['packages']['postgresql'] = %w(php-pgsql)
  end
else
  default['postfixadmin']['packages']['requirements'] = %w(php5-imap)
  default['postfixadmin']['packages']['mysql'] = %w(php5-mysql)
  default['postfixadmin']['packages']['postgresql'] = %w(php5-pgsql)
end
