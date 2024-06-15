# frozen_string_literal: true

module Linters
  module Src
    module RubyCodeService
      class << self
        def handle(dir_path)
          result_rubocop = rubocop_exec(dir_path)
          format_after_rubocop(result_rubocop)
        end

        private

        def format_after_rubocop(json)
          files = get_files(json)
          files.filter! { |file| file[:offenses].count.positive? }
          is_fatal = files.any? do |file|
            file[:offenses].any? { |offense| offense[:severity] == 'fatal' }
          end
          { files:, offense_count: json['summary']['offense_count'], is_fatal: }
        end

        def get_files(json)
          json['files'].map do |file|
            offenses = map_rubocop_offenses(file['offenses'])
            { file_path: make_file_path_from_rubocop(file['path']), offenses: }
          end
        end

        def make_file_path_from_rubocop(file_path)
          file_path.split('/')[3..].join('/')
        end

        def map_rubocop_offenses(offenses)
          offenses.map do |offense|
            {
              message: offense['message'],
              rule: offense['cop_name'],
              position: "#{offense['location']['line']}:#{offense['location']['column']}",
              severity: offense['severity']
            }
          end
        end

        def rubocop_exec(dir_path)
          JSON.parse(`cd #{Rails.root} && \
                                   bundle exec rubocop \
                                   --format json \
                                   #{dir_path}/**/*.rb`)
        end
      end
    end
  end
end
