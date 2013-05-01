def load_current_resource
  require 'pathname'
  require 'ript/dsl'
  node.run_state[:ript] ||= Mash.new
  node.run_state[:ript][:rules] ||= Mash.new
  node.run_state[:ript][:rules][new_resource.group] ||= []
  unless(@writer = new_resource.run_context.resource_collection.lookup("ript_writer[#{new_resource.group}]"))
    @writer = Chef::Resource.RiptWriter.new(new_resource.group, new_resource.run_context)
    @writer.action :nothing
    new_resource.run_context.resource_collection << @writer
  end
end

action :add do
  writer = @writer
  ript_rule = new_resource.ript.call
  # HACK: ript spits everything to stdout so
  # lets grab it and use it until we can get
  # a pull req upstream to make this a proper
  # library
  ruby_block "Ript rule generation G:#{new_resource.group} N:#{new_resource.name}" do
    block do
      orig_stdout = $stdout
      $stdout = capture = StringIO.new
      begin
        ript_rule.map(&:to_iptables)
      ensure
        $stdout = orig_stdout
      end
      node.run_state[:ript][:rules][new_resource.group] << capture.string
    end
    notifies :write, writer, :delayed
  end
end

action :delete do
  writer = @writer
  ruby_block "Ript rule removal G:#{new_resource.group} N:#{new_resource.name}" do
    block do
      true # noop
    end
    notifies :write, writer, :delayed
  end
end
