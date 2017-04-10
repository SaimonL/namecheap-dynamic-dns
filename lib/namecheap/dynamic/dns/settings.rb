# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is all about loading and processing configuration items
      module Settings
        def load_config
          if config_file.empty? || !File.exist?(config_file)
            raise 'Invalid YML config file!'
          end
          self.config = YAML.load_file(config_file)
          self.config = ActiveSupport::HashWithIndifferentAccess.new(config)
        end

        def domains?
          config.key?(:domains) && !config[:domains].empty?
        end

        def domains
          config[:domains]
        end

        def subdomains?(domain)
          domain.key?(:subdomains) && !domain[:subdomains].empty?
        end
      end
    end
  end
end
