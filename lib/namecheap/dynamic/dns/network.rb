# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is designed for all network related functions.
      module Network
        def external_ip
          self.ip = nil
          begin
            self.ip = open('http://whatismyip.akamai.com').read
          rescue StandardError => err
            logger.warn('Failed to retrieve external I.P.')
            logger.debug(err)
          end
        end

        def host_to_ip(host_name)
          Resolv.getaddress(host_name)
        rescue Resolv::ResolvError => err
          logger.fatal(err.message)
          logger.debug("Host Name: #{host_name}")
          logger.error(err)

          self.report_memory[:error] = true
          self.report_memory[:message] = err.message
          store_report_memory
          save_report

          return host_name
        rescue StandardError => err
          logger.fatal('Failed to retrieve host I.P. address')
          logger.debug("Host Name: #{host_name}")
          logger.error(err)

          self.report_memory[:error] = true
          self.report_memory[:message] = err.message
          store_report_memory
          save_report

          return host_name
        end

        def an_ip?(host_name)
          IPAddress.valid?(host_name)
        end

        def extract_ip(ip_or_host)
          if an_ip?(ip_or_host)
            ip_or_host
          else
            host_to_ip(ip_or_host)
          end
        end

        def host_ip_match?(domain, target, target_ip)
          self.report_memory[:action] = 'checking current domain\'s ip address'
          host = %w(@ *).include?(target) ? domain : [target, domain].join('.')
          current_ip = host_to_ip(host)
          self.report_memory[:from_ip] = current_ip
          current_ip == target_ip
        end

        def valid_domain?(target_domain)
          !target_domain.match(/\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,16}\z/ix).nil?
        end

        def got_external_ip?
          return true unless ip.nil?
          logger.error('No external ip detected. Aborting!!')
          false
        end
      end
    end
  end
end
