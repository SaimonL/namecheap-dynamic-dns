# frozen_string_literal: true

module Namecheap
  module Dynamic
    module Dns
      # This module is designed to create a report file
      module Report
        attr_accessor :report_path, :report_data, :report_memory

        def new_report(path = nil)
          self.report_path = path || 'report.csv'
          self.report_data = [['Domain', 'Subdomain', 'Action', 'Processed?', 'From I.P', 'To I.P', 'Has Error', 'Message', 'Time']]
          self.report_memory = Hash.new
        end

        def clear_report_memory
          self.report_memory = {
            domain: '',
            sub_domain: '',
            action: 'Initialize',
            processed: false,
            from_ip: '',
            to_ip: '',
            error: false,
            message: '',
            time: Time.now.utc
          }
        end

        def store_report_memory
          self.report_data.push([
            report_memory[:domain],
            report_memory[:sub_domain],
            report_memory[:action],
            report_memory[:processed],
            report_memory[:from_ip],
            report_memory[:to_ip],
            report_memory[:error],
            report_memory[:message],
            report_memory[:time]
          ])
        end

        def save_report
          File.open(report_path,'w') do |f|
            report_data.each do |row|
              f.write(row.to_csv)
            end
          end
        end
      end
    end
  end
end
