Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  resources :users do
    collection do
    get :profile
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :reports, :restaurants
  root to: 'homes#index'
end
