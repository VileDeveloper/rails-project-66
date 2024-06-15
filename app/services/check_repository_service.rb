# frozen_string_literal: true

class CheckRepositoryService
  attr_reader :check, :repository, :user

  def initialize(check)
    @check = check
    @repository = check.repository
    @user = check.repository.user
  end

  def perform
    begin
      check.run_check!

      repository_path = path_to_repository(repository)

      clean_repository_path(bash_runner, repository_path)

      git.clone(repository.git_url, repository_path)

      check.commit_id = commit_id(bash_runner, repository_path)

      check_command = map_language_to_check_command(repository)
      check_details, exit_status = bash_runner.execute(check_command)

      check.details = check_details
      check.passed = exit_status.zero?

      check.mark_as_finish!
    rescue StandardError => e
      check.passed = false
      check.mark_as_fail!
      Rails.logger.error e
    end

    send_result_mail(check, user)

    true
  end

  private

  def bash_runner
    @bash_runner ||= AppContainer[:bash_runner]
  end

  def git
    @git ||= AppContainer[:git]
  end

  def send_mail_by_result(user, check)
    if check.failed?
      CheckResultMailer.with(user:, check:, repositroy:).error_check_email.deliver_later
    elsif !check.passed
      CheckResultMailer.with(user:, check:, repositroy:).failed_check_email.deliver_later
    else
      CheckResultMailer.with(user:, check:, repositroy:).passed_check_email.deliver_later
    end
  end

  def clean_repository_path(bash_runner, repository_path)
    return unless Dir.exist?(repository_path)

    clean_dir_command = "rm -rf #{repository_path}"
    output, exit_status = bash_runner.execute(clean_dir_command)

    return if exit_status.zero?

    check.details = output
    raise 'Could not clean repository path'
  end

  def commit_id(bash_runner, repository_path)
    commit_id_command = "cd #{repository_path} && git rev-parse --short HEAD"
    commit_id_output, exit_status = bash_runner.execute(commit_id_command)

    unless exit_status.zero?
      check.check_log = 'Error'
      raise
    end

    commit_id_output.chop
  end

  def map_language_to_check_command(repository)
    path_to_repository = repository.path_to_directory
    mapping = {
      javascript: "node_modules/eslint/bin/eslint.js #{path_to_repository} --format=json --config ./.eslintrc.yml  --no-eslintrc",
      ruby: "bundle exec rubocop #{path_to_repository} --format=json --config ./.rubocop.yml"
    }

    command = mapping[repository.language.to_sym]
    Rails.logger.debug command

    command
  end

  def path_to_repository(repository)
    File.join(Dir.tmpdir, 'check_quality_repositories/', repository.full_name)
  end
end
