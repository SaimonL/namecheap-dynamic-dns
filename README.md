# Namecheap Dynamic Dns

Imagine you want to host your development server from home. So you buy a domain from namecheap and point the sub-domains to your home I.P address. Now the problem is every couple of months or on every power failure (how ever rare they might be) you external I.P ends up changing. Now you have to login to your domain host and change the I.P for all of them.

This gem allows you to automatically easily change the I.P address of the subdomains that are pointing to your home Internet. It does this by checking your external I.P address with each specified subdomains to see if they match. Then if they don't match a call is made to namecheap to change it.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'namecheap-dynamic-dns'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install namecheap-dynamic-dns

## Usage

In order to use this gem you must first go to Namecheap and set the "Type" to "A + Dynamic DNS Record" and then enable "DYNAMIC DNS" below in the "Advanced DNS" section. Second you will need to create a YML file that tells this gem information about what are the domain/s to target and some additional information. You control the run time interval either through ruby script via cronjob or by rails. I recommend 1 hour gap in-between checks since I.P don't really change that often. Some DNS takes time to update. 

You will need to have connection to Internet.If you are in highly secure site then the following domains needs to be white listed:  
* dynamicdns.park-your-domain.com
* whatismyip.akamai.com

### YML

The file you are about to create can have any name. I named mine `domains.yml`. As long as you specify the file path you should be fine.

Create a YML file with the following:

```yaml
---
domains:
  # Will not touch root domain "example.com" and subdomain "staging"
  example.com:
    subdomains:
      staging:

  # Will change the root domain "foo.com" to I.P "2.4.6.8"
  # Will NOT change the subdomain "bar" at all since "ip" is missing.     
  # Subdomain donkey the ip will change to the domain aaa.com I.P address
  foo.com:
    password: 3fj987jg0wi4u9e84fh0342jghjd
    ip: 2.4.6.8

    subdomains:
      bar:
      donkey:
        ip: aaa.com 

  # Will change the root domain I.P to the current computer's WAN (external) I.P address
  # Same goes for the subdomain home
  bar.com:
    password: 701982jg0w08b9e84fh0628jghab
    ip: !self

    subdomains:
      home:
        ip: !self
  
```
_NOTE: Make sure that you git ignore this file since it has your password in it._

#### Password
The `password` here you will get from NameCheap when you select a domain and under `Advanced DNS` and enable `DYNAMIC DNS` and you will see `Dynamic DNS Password`.

#### I.P
I.P can be an i.p or host name as well. By default if you don't specify any I.P anywhere then nothing will happen for that subdomain or root domain. If you want to use the external I.P (wan) of the computer this gem is running from then for "ip" set it to "!self". One thing to note which is if you are using a host name that uses load balancers then you may get different I.P address on every call.


## Using Script

In your ruby script include the modules.

```ruby
require 'namecheap/dynamic/dns'

include Namecheap::Dynamic::Dns

setup('domains.yml')
process_domains
```

## Using Rails

In you class enter the following.

```ruby
class Example
  include Namecheap::Dynamic::Dns

  def initialize(config_file)
    setup(config_file)
  end
end
```

Then to process the domains
```ruby
foo = Example.new('config/domains.yml')
foo.process_domains
```

## Other Methods
These methods you won't need to use but can be useful for you in other way.

```ruby
# Get external I.P
external_ip

# Get IP from hostname
host_to_ip('google.com')

# Valid IP?
an_ip?('1.2.3.4')

# Get list of domains
domains

# Chack is domain specified is valid
valid_domain?('google.com')

# Force reload config YML file
load_config

# See raw response
xml_response

# See JSON response
response
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/namecheap-dynamic-dns.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
