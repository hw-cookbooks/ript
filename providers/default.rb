def load_current_resource
  new_resource.base_dir node['ript']['base_dir'] unless new_resource.base_dir
  unless (@ript_service = new_resource.run_context.lookup('service[ript]'))
    @ript_service = Chef::Resource::Service.new('ript', new_resource.run_context)
    @ript_service.action :nothing
    new_resource.run_context.run_collection << @ript_service
  end
end

action :run do
  ript_service = @ript_service

  directory ::File.dirname(new_resource.output_file) do
    recursive true
  end

  ruby_block 'Ript -> iptables' do
    block do
      cmd = "ript rules generate #{new_resource.base_dir}"
      node.run_context[:ript][:output] = `#{cmd}`
    end
  end

  file new_resource.output_file do
    content node.run_context[:ript][:output]
    mode '644'
    notifies :restart, ript_service, :delayed
  end
end
