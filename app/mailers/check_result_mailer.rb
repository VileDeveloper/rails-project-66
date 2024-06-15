# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  before_action :set_objects

  def failed_check_email
    mail(
      to: @user.email,
      subject: t('.failed_check')
    )
  end

  def error_check_email
    mail(
      to: @user.email,
      subject: t('.error_check')
    )
  end

  def passed_check_email
    mail(
      to: @user.email,
      subject: t('.passed_check')
    )
  end

  private

  def set_objects
    @user = params[:user]
    @check = params[:check]
    @repository = params[:repository]
  end
end
