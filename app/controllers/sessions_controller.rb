# typed: strict
class SessionsController < ApplicationController
  extend T::Sig
  sig { void }

  def new; end

  sig { void }

  def create
    session[:user_id] = provision_user

    redirect_to root_path
  end

  sig { returns(Integer) }

  def provision_user
    user_data = request.env["omniauth.auth"]
    subject = user_data.extra.id_info.sub

    user = User.find_or_initialize_by(external_id: subject, external_provider: :google)
    user.email = user_data.info.email
    user.image = user_data.info.image

    user.save!

    return T.must(user.id)
  end
end
