# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

# Copied from https://github.com/burtlo/ark
# Until f6f9650 release.

if defined?(ChefSpec)
  def install_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :install, resource_name)
  end

  def dump_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :dump, resource_name)
  end

  def cherry_pick_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :cherry_pick, resource_name)
  end

  def put_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
  end

  def install_with_make_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :ark, :install_with_make, resource_name
    )
  end

  def configure_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :configure, resource_name)
  end

  def setup_py_build_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :ark, :setup_py_build, resource_name
    )
  end

  def setup_py_install_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :ark, :setup_py_install, resource_name
    )
  end

  def setup_py_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :setup_py, resource_name)
  end

  def unzip_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :unzip, resource_name)
  end
end
