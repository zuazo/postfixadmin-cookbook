# encoding: UTF-8

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
