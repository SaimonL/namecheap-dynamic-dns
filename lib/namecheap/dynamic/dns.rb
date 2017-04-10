# frozen_string_literal: true

require 'xml/to/hash'

require 'open-uri'
require 'oj'
require 'active_support/core_ext/hash/indifferent_access'
require 'yaml'
require 'open-uri'
require 'resolv'
require 'ipaddress'

require 'namecheap/dynamic/dns/version'
require 'namecheap/dynamic/dns/processor'
require 'namecheap/dynamic/dns/request'
require 'namecheap/dynamic/dns/settings'
require 'namecheap/dynamic/dns/network'

module Namecheap
  module Dynamic
    # This is the main module where all the rest loads from.
    module Dns
      include Processor
      include Request
      include Settings
      include Network

      attr_accessor :config_file, :config, :response, :xml_response, :ip

      def setup(config_file)
        self.config_file = config_file
        load_config
        external_ip
      end

    end
  end
end
