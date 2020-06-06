# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'namecheap/dynamic/dns/version'

Gem::Specification.new do |spec|
  spec.name          = 'namecheap-dynamic-dns'
  spec.version       = Namecheap::Dynamic::Dns::VERSION
  spec.authors       = ['Saimon Lovell']
  spec.email         = ['staysynchronize@gmail.com']

  spec.summary       = %q{NameCheap Dynamic DNS}
  spec.description   = %q{If you host your services from home your wan I.P can change over time.
                          This gem will help you by making sure the subdomains always point to your home wan ip.}
  spec.homepage      = 'https://github.com/SaimonL/namecheap-dynamic-dns'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'oj'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'xml-to-hash'
  spec.add_dependency 'ipaddress'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
end
