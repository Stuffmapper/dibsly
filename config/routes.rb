Dibsly::Application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  post 'sessions/facebook_create'
  get '/auth/check' => 'sessions#check'

  post 'sessions/create'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  get '/auth/check' => 'sessions#check'

  post 'users' => 'users#create'
  patch 'users/:id' => 'users#my_stuff'
  post 'users/:id', :to => 'users#show', :as => :user
  post 'presets' => 'users#presets'

  post 'messages/:id', :to => 'messages#reply'
  resources :messages, only: [:show, :create, :index]

  get 'posts' => 'posts#index'
  post 'posts' => 'posts#create'

  get 'posts/geolocated' => 'posts#geolocated'
  post 'posts/grid_mode' => 'posts#grid_mode'
  get 'search' => 'posts#search'
  get 'my-stuff' => 'posts#my_stuff'
  post 'feedbacks/create'
  
 

  resources :posts, only: [:create, :index] do 
    resources :dibs, only: [:create ] 
  end
  post 'posts/:id/undib' => 'dibs#undib'
  post 'posts/:id/update' => 'posts#update'


  resources :password_resets,  only: [:new, :create, :edit, :update]
  
  get 'posts/:id' => 'posts#show'


  root 'posts#index'

  get '(*url)' => 'posts#index'
end
