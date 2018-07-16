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
            self.report_memory[:domain] = domain
            next unless pre_check_sub_domains(domain, attr)

            logger.info("Checking domain: #{domain}")
            self.report_memory[:action] = 'processing subdomain domains'
            process_subdomains(domain,
                               attr[:subdomains],
                               attr[:password],
                               extract_ip(attr[:ip] ||= ip))
          end

          save_report
        end

        private

        def pre_check_domain
          return false unless got_external_ip?
          domains?
        end

        def pre_check_sub_domains(domain, attr)
          self.report_memory[:action] = 'validating domain'
          return unless valid_domain?(domain)

          self.report_memory[:action] = 'checking password'
          return unless password?(attr)

          self.report_memory[:action] = 'checking subdomains'
          return unless subdomains?(attr)

          self.report_memory[:action] = 'checking ip address'
          return if attr[:ip].nil? && ip.nil?
          true
        end

        def process_subdomains(domain, subdomains, password, target_ip)
          self.report_memory[:action] = 'processing domain'
          master_report = self.report_memory.clone

          subdomains.each do |subdomain, attributes|
            self.report_memory = master_report.clone
            self.report_memory[:sub_domain] = subdomain

            ip = process_ip(target_ip, attributes)
            self.report_memory[:to_ip] = ip

            next unless valid_domain?([subdomain, domain].join('.'))

            if host_ip_match?(domain, subdomain, ip)
              logger.info("  - Host '#{subdomain}' is Valid.")
              self.report_memory[:action] = 'No change detected skipping'
              store_report_memory
              next
            else
              self.report_memory[:action] = 'Change detected calling Name cheap'
              self.report_memory[:processed] = true
              process_subdomain(domain, subdomain, password, ip)
            end

            store_report_memory
          end
        end

        def process_subdomain(domain, subdomain, password, ip)
          logger.info("  - Updating host '#{subdomain}' !!")
          self.report_memory[:action] = "Updating host '#{subdomain}'"
          request generate_url(subdomain, domain, password, ip)
          updated_domains.push [subdomain, domain].join('.')
          self.report_memory[:action] = 'Host updated'
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
