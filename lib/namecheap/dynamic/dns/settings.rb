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
          return true if domain.key?(:subdomains) && !domain[:subdomains].empty?
          logger.error('Subdomains are not found.')
          false
        end

        def valid_domain?(domain)
          unless valid_domain?(domain)
            logger.error("Invalid domain found #{domain}.")
            return false
          end
          true
        end

        def password?(attr)
          unless attr.key?(:password)
            logger.error("No password is specified for #{domain}.")
            return false
          end
          true
        end
      end
    end
  end
end
