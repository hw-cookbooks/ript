actions :create, :delete
default_action :create

attribute :path, :kind_of => String
attribute :base_dir, :kind_of => String
attribute :ript, :kind_of => Proc, :required => true
