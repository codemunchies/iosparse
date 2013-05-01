IOSParse will parse Cisco IOS configuration files, more functionality coming.

# How do I use it?
Good question.  First install it using `gem install iosparse`.  
Then use it.  Create a new IOSParse object and pass it filename of the Cisco IOS config file (usually a show all type of dump file).  Then ask it questions:

````
config = IOSParse.new('path/to/ios.conf')
puts config.interfaces
````
````
Output:

[0] => ["interface Ethernet0/0\n ip address 1.1.2.1 255.255.255.0\n no cdp enable\n"]
[1] => ["interface Serial1/0\n encapsulation ppp\n ip address 1.1.1.1 255.255.255.252\n"]
[2] => ["interface Serial1/1\n encapsulation ppp\n ip address 1.1.1.5 255.255.255.252\n service-policy output QOS_1\n"]
[3] => ["interface Serial1/2\n encapsulation hdlc\n ip address 1.1.1.9 255.255.255.252\n"] 
````

All objects returned are arrays that can be further manipulated and parsed.  "Human readable" format coming soon, maybe even a CLI.
