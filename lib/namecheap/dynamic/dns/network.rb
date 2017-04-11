# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is designed for all network related functions.
      module Network
        def external_ip
          binding.pry
          self.ip = open('http://whatismyip.akamai.com').read
        end

        def host_to_ip(host_name)
          Resolv.getaddress(host_name)
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
          host = %w(@ *).include?(target) ? domain : [target, domain].join('.')
          host_to_ip(host) == target_ip
        end

        def valid_domain?(target_domain)
          !target_domain.match(/\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,16}\z/ix).nil?
        end
      end
    end
  end
end
