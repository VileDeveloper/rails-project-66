# frozen_string_literal: true

module ApplicationHelper
  def link_to_github(check, options = {})
    commit = commit_id check.commit_id
    file_path = options.delete(:file_path)
    link_name = file_path.nil? ? commit : file_path
    commit_path = file_path.nil? ? "/commit/#{commit}" : "/tree/#{commit}/#{file_path}"

    link_to link_name, "https://github.com/#{check.repository.full_name}#{commit_path}", options
  end

  private

  def commit_id(commit_hash)
    commit_hash.slice(..6)
  end
end
