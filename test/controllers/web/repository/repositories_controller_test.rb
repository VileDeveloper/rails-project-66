# frozen_string_literal: true

require 'test_helper'

class Web::Repository::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:one)
    @git_rep_id = 123_456_789
  end

  test 'should get index page' do
    sign_in @user
    get repositories_url
    assert :success
  end

  test 'should NOT get index page' do
    get repositories_url
    assert_redirected_to root_path
  end

  test 'should get new' do
    sign_in @user

    get new_repository_url
    assert_response :success
  end

  test 'should show repository' do
    sign_in @user

    get repository_url(@repository)
    assert_response :success
  end

  test 'should create repository' do
    sign_in @user

    post repositories_url, params: { repository: { github_id: @git_rep_id } }

    assert ::Repository.find_by(github_id: @git_rep_id)
  end
end
