# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is designed to create a report file
      module Report
        attr_accessor :report_path, :report_data, :report_memory

        def new_report(path = nil)
          self.report_path = path || 'report.csv'
          self.report_data = [['Domain', 'Subdomain', 'Action', 'From I.P', 'To I.P', 'Message', 'Time']]
          self.report_memory = Hash.new
        end

        def clear_report_memory
          self.report_memory = {
            domain: '',
            sub_domain: '',
            action: 'Initialize',
            from_ip: '',
            to_ip: '',
            message: '',
            time: Time.zone.now
          }
        end

        def store_report_memory
          self.report_data.push([
            report_memory[:domain],
            report_memory[:sub_domain],
            report_memory[:action],
            report_memory[:from_ip],
            report_memory[:to_ip],
            report_memory[:message],
            report_memory[:time]
          ])
        end

        def save_report
          File.open(report_path,'w') { |f| f.write(report_data.to_csv) }
        end
      end
    end
  end
end
