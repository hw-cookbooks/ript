# Ript for Chef

This cookbook provides easy iptables configuration using the
ript library to provide a few custom Chef resources.

## Resources

### ript_rule

```ruby
ript_rule 'my_rule' do
  ript do
    partition "joeblogsco" do
      label "www.joeblogsco.com", :address => "172.19.56.216"
      label "app-01",             :address => "192.168.5.230"
      label "bad guys",           :address => "10.0.0.0/8"

      rewrite "public website + ssh access", :log => true do
        ports 80, 22
        dnat  "www.joeblogsco.com" => "app-01"
      end

      reject "bad guys", :log => true do
        protocols "udp"
        from      "bad guys"
        to        "www.joeblogsco.com"
      end
    end
  end
end
```

### ript_file

```ruby
ript_file 'my_file' do
  content "some content"
end
```

### ript_template

```ruby
ript_template 'my_template' do
  source 'custom.ript.erb'
end
```

### ript_rule

```ruby
ript_rule 'allow ssh from office' do
  ript do
    label 'office', :address => '127.0.0.121'
    accept 'office' do
      from 'office'
      ports 22
    end
  end
end

## Attributes

* `node[:ript][:base_dir] = '/etc/ript.d'` # Storage location for ript files and templates

## Dependencies

* iptables cookbook: http://community.opscode.com/cookbooks/iptables

## Resources

* Repo: https://github.com/hw-cookbooks/ript
* IRC: Freenode @ #heavywater