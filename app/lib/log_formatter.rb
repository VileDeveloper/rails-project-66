# frozen_string_literal: true

##########################################
# offense_count: X,
# files: [{
#   path: PATH,
#   offenses: [{
#     message: MESSAGE,
#     rule: NAME,
#     location: X:Y
#   }]
# }]
#########################################
class LogFormatter
  class << self
    def format(raw_check_log, language)
      if raw_check_log.empty?
        return {
          offense_count: 0,
          files: []
        }
      end

      case language
      when 'ruby'
        format_ruby(raw_check_log)
      when 'javascript'
        format_javascript(raw_check_log)
      else
        raise "Unhandled language for parse #{language}"
      end
    end

    private

    def format_ruby(raw_check_log)
      errors = raw_check_log['files'].select { |record| record['offenses'].any? }

      files = errors.map do |error|
        offenses = error['offenses'].map do |offence|
          {
            message: offence['message'],
            rule: offence['cop_name'],
            location: "#{offence.dig('location', 'start_line')}:#{offence.dig('location', 'start_column')}"
          }
        end

        {
          path: error['path'],
          offenses:
        }
      end

      {
        offense_count: raw_check_log.dig('summary', 'offense_count'),
        files:
      }
    end

    def format_javascript(raw_check_log)
      errors = raw_check_log.reject { |record| record['errorCount'].zero? }

      files = errors.map do |error|
        offenses = error['messages'].map do |offence|
          {
            message: offence['message'],
            rule: offence['ruleId'],
            location: "#{offence['line']}:#{offence['column']}"
          }
        end

        {
          path: error['filePath'],
          offenses:
        }
      end

      {
        offense_count: errors.sum { |issues_group| issues_group['messages'].size },
        files:
      }
    end
  end
end
