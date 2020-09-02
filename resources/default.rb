actions :run
default_action :run

attribute :base_dir, kind_of: String
attribute :output_file, kind_of: String, default: '/var/lib/ript/iptables.state'
