#
# Cookbook:: transmission
# Library:: matchers
#
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Copyright:: 2016, Chef Software, Inc.
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

if defined?(ChefSpec)
  #################
  # transmission_torrent_file
  #################
  ChefSpec.define_matcher :transmission_torrent_file

  def create_transmission_torrent_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:transmission_torrent_file, :install, resource_name)
  end
end
