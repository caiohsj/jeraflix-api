Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :profiles
      post "/users", to: "user#create"
      post "/auth", to: "user#auth"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
