Dibsly::Application.routes.draw do
  post 'sessions/create'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  get '/auth/check' => 'sessions#check'

  post 'users' => 'users#create'
  patch 'users/:id' => 'users#my_stuff'
  post 'users/:id', :to => 'users#show', :as => :user
  post 'presets' => 'users#presets'

  post 'messages/:id', :to => 'messages#reply'
  resources :messages

  get 'posts' => 'posts#index'
  post 'posts' => 'posts#create'
  get 'posts/geolocated' => 'posts#geolocated'
  post 'posts/grid_mode' => 'posts#grid_mode'
  get 'search' => 'posts#search'
  get 'my-stuff' => 'posts#my_stuff'
  post 'feedbacks/create'

  resources :posts do 
    resources :dibs 
  end

  root 'posts#index'

  get '(*url)' => 'posts#index'
end
