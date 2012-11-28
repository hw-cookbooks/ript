class Chef
  class Resource
    class RiptFile < File
      def initialize(*)
        super
        @provider = Chef::Provider::RiptFile
        @path = nil
        notifies(:run, 'execute[ript[process files]]')
      end
    end
  end
end

class Chef
  class Provider
    class RiptFile < File
      def load_current_resource
        unless(@new_resource.path)
          @new_resource.path ::File.join(
            run_context.node[:ript][:base_dir],
            @new_resource.name
          )
        end
        super
      end
    end
  end
end
