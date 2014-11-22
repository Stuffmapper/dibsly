Dibsly::Application.routes.draw do
  post 'sessions/create'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'

  get 'auth/:provider/callback', to: 'sessions#create'
 get  'auth/failure', to: redirect('/')




  post 'users' => 'users#create'
  patch 'users/:id' => 'users#my_stuff'
  post 'users/:id', :to => 'users#show', :as => :user
  post 'presets' => 'users#presets'

  get 'messages' => 'messages#index'
  post 'messages' => 'messages#create'

  post 'posts/:id/dib', :to => 'posts#dib', :as => 'dib_post'
  post 'posts/:id/claim', :to => 'posts#claim', :as => 'dib_claim'
  get 'posts' => 'posts#index'
  post 'posts' => 'posts#create'
  post 'posts/geolocated' => 'posts#geolocated'
  post 'posts/grid_mode' => 'posts#grid_mode'
  get 'search' => 'posts#search'
  get 'my-stuff' => 'posts#my_stuff'
  post 'feedbacks/create'

  root 'posts#index'
end
