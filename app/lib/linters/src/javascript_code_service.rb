# frozen_string_literal: true

module Linters
  module Src
    module JavascriptCodeService
      class << self
        def handle(dir_path)
          output_file_path = "#{dir_path}/eslint_result.json"
          FileUtils.touch output_file_path
          result_eslint = eslint_exec(dir_path, output_file_path)
          format_after_eslint(result_eslint)
        end

        private

        def eslint_exec(dir_path, output_file_path)
          `cd #{Rails.root} && yarn eslint --no-config-lookup --format json #{dir_path} 1> #{output_file_path}`

          line_with_json = ''
          File.foreach(output_file_path) do |line|
            if line.strip.start_with?('[')
              line_with_json = line
              break
            end
          end
          JSON.parse(line_with_json)
        end

        def format_after_eslint(json)
          offense_count = 0
          files = format_files(json, offense_count)
          files.filter! { |file| file[:offenses].count.positive? }
          { files:, offense_count: }
        end

        def format_files(json, offense_count)
          json.map do |file|
            offenses = file['messages'].map do |message|
              offense_count += 1
              { message: message['message'], rule: message['ruleId'],
                position: "#{message['line']}:#{message['column']}" }
            end

            { file_path: make_file_path_from_eslint(file['filePath']), offenses:, is_fatal: false }
          end
        end

        def make_file_path_from_eslint(absolute_file_path)
          file_path = absolute_file_path.split('/')
          index = file_path.index('clone_app')
          return absolute_file_path unless index

          file_path.slice((index + 2)..).join('/')
        end
      end
    end
  end
end
