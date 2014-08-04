Dibsly::Application.routes.draw do
  post 'sessions/create'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'

  post 'users' => 'users#create'
  patch 'users/:id' => 'users#my_stuff'
  post 'users/:id', :to => 'users#show', :as => :user

  post 'posts/:id/dib', :to => 'posts#dib', :as => 'dib_post'
  get 'posts' => 'posts#index'
  post 'posts' => 'posts#create'
  post 'posts/geolocated' => 'posts#geolocated'

  get 'search' => 'posts#search'

  root 'posts#index'
end
