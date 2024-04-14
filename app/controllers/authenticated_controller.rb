class AuthenticatedController < ApplicationController
  extend T::Sig

  before_action :require_user_id

  protected

  def require_user_id
    if session[:user_id].blank?
      redirect_to new_session_path
    end
  end
end
