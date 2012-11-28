def load_current_resource
  require 'pathname'
  require 'ript/dsl'
  unless(new_resource.path)
    new_resource.path ::File.join(
      node[:ript][:base_dir],
      new_resource.name
    )
  end
end

action :create do
  ript_rule = new_resource.ript.call
  # HACK: ript spits everything to stdout so
  # lets grab it and use it until we can get
  # a pull req upstream to make this a proper
  # library
  orig_stdout = $stdout
  $stdout = capture = StringIO.new
  begin
    ript_rule.map(&:to_iptables)
  ensure
    $stdout = orig_stdout
  end
  ript_file = file new_resource.path do
    content capture.string
    mode 0644
  end
  ript_file.run_action(:create)
  if(ript_file.updated_by_last_action?)
    new_resource.updated_by_last_action(true)
    ruby_block "ript notifiers[#{new_resource.name}]" do
      block{ true }
      notifies :run, 'execute[ript[process files]]'
    end
  end
end

action :delete do
  ript_file = file new_resource.path
  ript_file.run_action(:delete)
  if(ript_file.updated_by_last_action?)
    new_resource.updated_by_last_action(true)
    ruby_block "ript notifiers[#{new_resource.name}]" do
      block{ true }
      notifies :run, 'execute[ript[process files]]'
    end
  end
end
