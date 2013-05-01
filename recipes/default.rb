include 'digest/sha256'

# Install dependencies!
node[:ript][:package_dependencies].each do |pkg|
  package pkg
end

node[:ript][:dependencies][:gems].each do |g_pkg|
  chef_gem g_pkg
end

# Install service!
ruby_block 'install ript service' do
  block do
    FileUtils.cp(Gem::Specification.find_by_name('ript').full_gem_path, '/etc/init.d/ript')
  end
  not_if do
    begin
      s_p = Gem::Specification.find_by_name('ript').full_gem_path
      d_p = '/etc/init.d/ript'
      if(File.exists?(s_p) && File.exists?(d_p))
        s_sha = Digest::SHA256.new << File.read(s_p)
        d_sha = Digest::SHA256.new << File.read(d_p)
        s_sha == d_sha
      end
    rescue
      false
    end
  end
end

service 'ript' do
  action [:enable, :start]
end

# Done! \o/
