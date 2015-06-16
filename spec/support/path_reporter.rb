require 'capybara-screenshot/rspec/base_reporter'

module Capybara
  module Screenshot
    module PathReporter
      extend RSpec::BaseReporter

      if ::RSpec::Core::Version::STRING.to_i <= 2
        enhance_with_screenshot :dump_failure_info
      else
        enhance_with_screenshot :example_failed
      end

      def dump_failure_info_with_screenshot(example)
        dump_failure_info_without_screenshot example
        output_screenshot_info(example)
      end

      def example_failed_with_screenshot(notification)
        example_failed_without_screenshot notification
        output_screenshot_info(notification.example)
      end

      private
      def output_screenshot_info(example)
        return unless (screenshot = example.metadata[:screenshot])
        output.puts
        output.puts(long_padding + "HTML dump: file://#{screenshot[:html]}".yellow) if screenshot[:html]
        output.puts(long_padding + "Screenshot: file://#{screenshot[:image]}".yellow) if screenshot[:image]
        if ENV['RAILS_SHOW_TEST_LOG'] || ENV['CIRCLECI']
          log_excerpt = `cat log/test.log`.split("\n").map {|line| "#{long_padding}#{line}".cyan}.join("\n")
          if log_excerpt.present?
            output.puts(long_padding + "=================== Test Log Excerpt ===================")
            output.puts
            output.puts(log_excerpt)
            output.puts
            output.puts(long_padding + "=================== End of Test Log Excerpt ============")
          end
        end
      end

      def long_padding
        "  "
      end
    end
  end
end
