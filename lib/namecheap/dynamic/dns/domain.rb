# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      class Domain
        def initialize(domain)
          @domain = domain
          @subdomains = @domain.dig(:subdomains)
        end

        def process
          return false if settings[:password].nil? || settings[:password].length < 32

          process_root
          process_sub_domains
        end

        def process_root
          return if settings[:ip].nil?
        end

        def process_sub_domains
          @subdomains.each do |name, subdomain|

          end
        end

        def settings
          @settings ||= @domain.dig(:settings)
        end

        
      end
    end
  end
end
