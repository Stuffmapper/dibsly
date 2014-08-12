Dibsly::Application.routes.draw do
  resources :messages

  post 'sessions/create'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'

  post 'users' => 'users#create'
  patch 'users/:id' => 'users#my_stuff'
  post 'users/:id', :to => 'users#show', :as => :user
  post 'presets' => 'users#presets'

  post 'posts/:id/dib', :to => 'posts#dib', :as => 'dib_post'
  get 'posts' => 'posts#index'
  post 'posts' => 'posts#create'
  post 'posts/geolocated' => 'posts#geolocated'
  post 'posts/grid_mode' => 'posts#grid_mode'
  get 'search' => 'posts#search'

  root 'posts#index'
end
