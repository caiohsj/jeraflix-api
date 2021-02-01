Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :profiles
      resources :watchlist
      resources :watched_movie
      post '/users', to: 'user#create'
      post '/auth', to: 'user#auth'
      get '/profiles/:id/watchlist', to: 'profiles#watchlist'
      get '/profiles/:id/watched_movies', to: 'profiles#watched_movies'
      get '/movie/:id/profile/:profile', to: 'movie#show'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
