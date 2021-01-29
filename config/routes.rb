Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :profiles
      resources :watchlist
      post '/users', to: 'user#create'
      post '/auth', to: 'user#auth'
      get '/profiles/:id/watchlist', to: 'profiles#watchlist'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
