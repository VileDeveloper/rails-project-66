# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: %i[javascript ruby]

  validates :github_id, uniqueness: true, presence: true

  def path_to_directory
    File.join(Dir.tmpdir, 'viledev_quality_repositories/', full_name)
  end
end
