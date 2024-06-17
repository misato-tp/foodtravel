# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    callback_from(:google)
  end

  def callback_from(provider)
    provider = provider.to_s
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: provider.capitalize)
      sign_in_and_redirect @user
    else
      if @user.errors[:email].any?
        flash[:alert] = "すでに同じアドレスのユーザーが登録されています。ユーザー名とパスワードでログインして下さい。"
      end
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].slice(:provider, :uid, info: [:email, :username])
      redirect_to new_user_session_path
    end
  end
end
