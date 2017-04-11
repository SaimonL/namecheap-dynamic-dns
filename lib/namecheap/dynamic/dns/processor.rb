# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module puts it all together and the main functions are here.
      module Processor
        def process_domains
          return unless pre_check_domain
          self.updated_domains = []

          domains.each do |domain, attr|
            next unless pre_check_sub_domains(domain, attr)
            password = attr[:password]
            target_ip = attr[:ip] ||= ip

            puts "Checking domain: #{domain}"
            process_subdomains(domain, attr[:subdomains], password, extract_ip(target_ip))
            puts ''
          end
        end

        private

        def pre_check_domain
          return if ip.nil?
          return unless domains?
          true
        end

        def pre_check_sub_domains(domain, attr)
          return unless valid_domain?(domain)
          return unless subdomains?(attr)
          return unless attr.key?(:password)
          return if attr[:ip].nil? && ip.nil?
          true
        end

        def process_subdomains(domain, subdomains, password, target_ip)
          subdomains.each do |subdomain, attributes|
            ip = target_ip
            unless attributes.nil?
              ip = extract_ip(attributes[:ip]) if attributes.key?(:ip) && !attributes[:ip].strip.empty?
            end

            next unless valid_domain?([subdomain, domain].join('.'))

            if host_ip_match?(domain, subdomain, ip)
              puts "  - Host '#{subdomain}' is Valid."
              next
            end

            puts "  - Updating host '#{subdomain}' !!"
            request generate_url(subdomain, domain, password, ip)
            self.updated_domains.push [subdomain, domain].join('.')
          end
        end

        def process_ip(target_ip, subdomain)
          if subdomain.key?(:ip) && !subdomain[:ip].strip.empty?
            target_ip = subdomain[:ip]
          end
          extract_ip(target_ip)
        end
      end
    end
  end
end
