# frozen_string_literal: true

module AuthManagement
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def check_admin
    return if current_user&.admin?

    redirect_to root_path, notice: t('.notice')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  private

  def authenticate_user!
    return if signed_in?

    flash[:alert] = t('.should_sign_in')
    redirect_to root_path
  end
end
