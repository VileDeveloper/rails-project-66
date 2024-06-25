# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:one)
    @git_rep_id = 123_456_789

    sign_in(@user)
  end

  test '#index' do
    get repositories_path
    assert_response :success
  end

  test '#new' do
    get new_repository_path
    assert_response :success
  end

  test '#show' do
    get repository_url(@repository)
    assert_response :success
  end

  test '#create' do
    post repositories_url, params: { repository: { github_id: @git_rep_id } }

    assert ::Repository.find_by(github_id: @git_rep_id)
  end
end
