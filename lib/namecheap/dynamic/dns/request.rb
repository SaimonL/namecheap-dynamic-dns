# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is for handling all requests
      module Request
        def base_url
          'https://dynamicdns.park-your-domain.com/update?'
        end

        def generate_url(host, domain, password, ip = nil)
          url = base_url
          url += [:host, host].join('=')
          url += ['&', :domain, '=', domain].join
          url += ['&', :password, '=', password].join
          url += ['&', :ip, '=', ip].join unless ip.nil?
          url
        end

        def request(url)
          self.xml_response = Nokogiri::XML(open(url))
          self.response = xml_response.root.to_hash
        end
      end
    end
  end
end
