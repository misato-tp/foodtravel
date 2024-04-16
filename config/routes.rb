Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :users, only: [] do
    collection do
    get :profile
    get :mypage
    end
  end

  resources :restaurants do
    resources :reports, only: [:create, :destroy]
  end
  root to: 'homes#index'
end
