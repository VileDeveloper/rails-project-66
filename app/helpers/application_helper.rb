# frozen_string_literal: true

module ApplicationHelper
  def link_to_github(check, options = {})
    commit_id = check.commit_id

    return '' if check.commit_id.blank?

    file_path = options.delete(:file_path)

    commit_path =
      if file_path.present?
        file_relative_path = file_path.remove(check.repository.path_to_directory).delete_prefix('/')

        "/tree/#{commit_id}/#{file_relative_path}"
      else
        "/commit/#{commit_id}"
      end

    repository_full_name = check.repository.full_name

    link_to file_relative_path, "https://github.com/#{repository_full_name}#{commit_path}", options
  end
end
