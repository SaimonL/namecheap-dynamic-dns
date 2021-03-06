# frozen_string_literal: true
require 'pry'
require 'pry-nav'

require 'xml/to/hash'

require 'open-uri'
require 'oj'
require 'active_support/core_ext/hash/indifferent_access'
require 'yaml'
require 'open-uri'
require 'resolv'
require 'ipaddress'
require 'logger'
require 'csv'

require 'namecheap/dynamic/dns/version'
require 'namecheap/dynamic/dns/processor'
require 'namecheap/dynamic/dns/request'
require 'namecheap/dynamic/dns/settings'
require 'namecheap/dynamic/dns/network'
require 'namecheap/dynamic/dns/report'


module Namecheap
  module Dynamic
    # This is the main module where all the rest loads from.
    module Dns
      include Processor
      include Request
      include Settings
      include Network
      include Report

      attr_accessor :config_file, :config, :response, :xml_response, :ip, :updated_domains, :logger

      def setup(config_file)
        self.config_file = config_file
        load_config
        external_ip
        self.logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
      end

    end
  end
end
