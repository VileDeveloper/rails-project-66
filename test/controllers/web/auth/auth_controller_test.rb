# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
    end

    test '#request' do
      post auth_request_path('github')

      assert_response :redirect
    end

    test '#callback' do
      sign_in(@user)

      assert_redirected_to root_path
      assert User.find(@user.id)
      assert { signed_in? }
      assert_equal flash[:notice], I18n.t('web.auth.callback.success')
    end

    test '#logout' do
      delete auth_logout_path

      assert_response :redirect
      assert_equal flash[:notice], I18n.t('web.auth.logout.success')
    end
  end
end
