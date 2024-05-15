# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    if sign_in user
      flash[:notice] = 'ゲストユーザーとしてログインしました。'
      redirect_to root_path
    else
      flash.now[:notice] = 'ログインに失敗しました。'
      render new_user_session_path
    end
  end
end
