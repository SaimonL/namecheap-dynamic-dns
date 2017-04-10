# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module puts it all together and the main functions are here.
      module Processor
        def process_domains
          return unless domains?
          domains.each do |domain, attr|
            next unless subdomains?(attr)
            password = attr[:password]
            next unless password
            target_ip = attr[:ip] ||= ip

            puts "Checking domain: #{domain}"
            process_subdomains(domain, attr[:subdomains], password, target_ip)
            puts ''
          end
        end

        private

        def process_subdomains(domain, subdomains, password, target_ip)
          subdomains.each do |subdomain|
            target = subdomain[:target]
            target_ip = process_ip(target_ip, subdomain)
            next unless target

            if host_ip_match?(domain, target, target_ip)
              puts "  - Host '#{target}' is Valid."
              next
            end

            # Keep in mind that DNS change can takes from 1 min 24 hours
            puts "  - Updating host '#{target}' !!"
            request generate_url(target, domain, password, target_ip)
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
