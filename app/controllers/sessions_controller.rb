# typed: strict
class SessionsController < ApplicationController
  extend T::Sig
  sig { void }

  def new; end

  sig { void }

  def create
    user_data = request.env["omniauth.auth"]
    email = user_data.info.email
    subject = user_data.extra.id_info.sub

    user = User.find_or_initialize_by(external_id: subject, external_provider: :google)
    user.email = email
    user.image = user_data.info.image
    user.save!

    session[:user_id] = user.id

    redirect_to root_path
  end
end
