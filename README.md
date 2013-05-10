IOSParse will parse Cisco IOS configuration files, more functionality coming.

# How do I use it?
Good question.  First install it using `gem install iosparse`.  Then use it.  Create a new IOSParse object passing it the filename of the Cisco IOS config file (usually a show all type of dump file, I have included a mock config spec/etc/cisco_asa.config).  Then ask it questions:

````
config = IOSParse.new('path/to/ios.conf')
puts config.find_all('interface')
````
````
Output:

[0] => interface GigabitEthernet0/0\n description PHYSICAL_INTERFACE_0\n no nameif\n no security-level\n no ip address
[1] => interface GigabitEthernet0/0.74\n description VIRTUAL_INTERFACE_0.74\n vlan 74\n nameif INTERNAL\n security-level 70\n ip address 192.168.1.3 255.255.255.0 standby 10.10.1.3
[2] => interface GigabitEthernet0/0.82\n description VIRTUAL_INTERFACE_0.82\n vlan 82\n nameif DMZ\n security-level 30\n ip address 192.168.1.4 255.255.255.0 standby 10.10.1.4
[3] => interface GigabitEthernet0/0.83\n description VIRTUAL_INTERFACE_0.83\n vlan 83\n nameif WEB\n security-level 30\n ip address 192.168.1.5 255.255.255.0 standby 10.10.1.5
[4] => interface GigabitEthernet0/1\n description PHYSICAL_INTERFACE_1\n no nameif\n no security-level\n no ip address
````

All objects returned are arrays that can be further manipulated and parsed.  "Human readable" format coming soon, maybe even a CLI.  Please note the mock Cisco ASA config file in the spec test is completely fabricated and is not intended to be a correct configuration, it is only to be used for it's syntax.

All '\n' are injected as delimiters to show where children lines separate from the parent and inteded to be used for easy String#gsub to parse and print in other formats.  Feel free to look at the documentation link on the <a href="http://rubygems.org/gems/iosparse">rubygems</a> site.

Current methods:

`find_all` used to find all specific rules, interface, object-group, route, name, etc.
`has` used to find any rule that includes a specific string.
`group_has_ip` returns group(s) that include a specific IP.