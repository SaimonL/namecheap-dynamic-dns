# Namecheap::Dynamic::Dns

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/namecheap/dynamic/dns`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

In order to use this gem you must first create a YML file that tells this gem information about what are the domain/s to target and some additional information.

### YML

Create a YML file with the following:

```yaml
---
domains:
  example.com:
    password: 74gh9j3eufh86gh39jygh9f8h3f4

    subdomains:
      home:
      test:
        ip: 1.2.3.4

  foo.com:
    password: 3fj987jg0wi4u9e84fh0342jghjd
    ip: 2.4.6.8

    subdomains:
      bar:
      donkey:
        ip: 1.3.5.7    
```

Make sure that you git ignore this file since it has your password in it.

### Using Ruby

In your ruby script include the modules.

```ruby
require 'namecheap-dynamic-dns'

include Namecheap::Dynamic::Dns
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/namecheap-dynamic-dns.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
