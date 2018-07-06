# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module puts it all together and the main functions are here.
      module Processor
        def process_domains
          return unless pre_check_domain

          new_report
          clear_report_memory
          self.updated_domains = []

          domains.each do |domain, attr|
            
            next unless pre_check_sub_domains(domain, attr)
            logger.info("Checking domain: #{domain}")
            process_subdomains(domain,
                               attr[:subdomains],
                               attr[:password],
                               extract_ip(attr[:ip] ||= ip))
          end
        end

        private

        def pre_check_domain
          return false unless got_external_ip?
          domains?
        end

        def pre_check_sub_domains(domain, attr)
          return unless valid_domain?(domain)
          return unless password?(attr)
          return unless subdomains?(attr)
          return if attr[:ip].nil? && ip.nil?
          true
        end

        def process_subdomains(domain, subdomains, password, target_ip)
          subdomains.each do |subdomain, attributes|
            ip = process_ip(target_ip, attributes)

            next unless valid_domain?([subdomain, domain].join('.'))

            if host_ip_match?(domain, subdomain, ip)
              logger.info("  - Host '#{subdomain}' is Valid.")
              next
            else
              process_subdomain(domain, subdomain, password, ip)
            end
          end
        end

        def process_subdomain(domain, subdomain, password, ip)
          logger.info("  - Updating host '#{subdomain}' !!")
          request generate_url(subdomain, domain, password, ip)
          updated_domains.push [subdomain, domain].join('.')
        end

        def process_ip(target_ip, attributes)
          if attributes && attributes.key?(:ip) && !attributes[:ip].strip.empty?
            target_ip = attributes[:ip]
          end
          extract_ip(target_ip)
        end
      end
    end
  end
end
