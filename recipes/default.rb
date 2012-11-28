# Install dependencies!
include_recipe 'iptables'
chef_gem 'ript'

directory node[:ript][:ript_dir] do
  recursive true
end

execute 'ript[process files]' do
  action :nothing
  notifies :run, 'execute[rebuild-iptables]'
end
