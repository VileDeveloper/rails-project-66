# frozen_string_literal: true

module Linters
  class Handler
    def initialize(repository)
      @language = repository.language
      @repository_full_name = repository.full_name
    end

    def exec(dir_path)
      raise ArgumentError, "Unsuported language: #{@language}" if @language.nil?

      language = @language.capitalize
      linter = "Linters::Src::#{language}CodeService"

      raise ArgumentError, "Unsuported language: #{language}" unless Object.const_defined? linter

      linter.constantize.handle dir_path
    end
  end
end
