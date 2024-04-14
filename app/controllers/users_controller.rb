class UsersController < ApplicationController
  def index
  end
  
  def profile
    @user = current_user
  end

  def account
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to users_profile_path
    else
      render users_profile_path
    end
  end
end

private

def user_params
  params.require(:user).permit(:username, :email, :user_id)
end
