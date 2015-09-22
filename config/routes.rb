Dibsly::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'auth/:provider/callback', to: 'api/sessions#create_with_omniauth'
  get 'auth/failure', to: redirect('/')

  namespace :api, defaults: {format: :json} do
    post 'sessions/facebook_create'
    get '/auth/check' => 'sessions#check'

    post 'sessions/create'
    get 'signout', to: 'sessions#destroy', as: 'signout'
    get 'log_out' => 'sessions#destroy', :as => 'log_out'
    get '/auth/check' => 'sessions#check'

    post 'users/email/:confirmation' => 'users#confirm_email'

    post 'users/:id', :to => 'users#show', :as => :user
    resources :users, only: [:show, :create, :update]

    get  'messages/status', :to => 'messages#inbox_status'
    post 'messages/:id', :to => 'messages#reply'
    get  'chat/:id', :to => 'messages#dib_or_post_chat'
    resources :messages, only: [:show, :create, :index]
    resources :images, only: [:create ]


    get 'posts' => 'posts#index'
    post 'posts' => 'posts#create'

    get 'posts/geolocated' => 'posts#geolocated'
    get 'search' => 'posts#search'
    get 'my-stuff' => 'posts#my_stuff'
    get 'my-dibs' => 'posts#my_dibs'



    resources :posts, only: [:create, :index] do
      resources :dibs, only: [:create ]
    end
    post 'posts/:id/undib' => 'dibs#undib'
    post 'posts/:id/update' => 'posts#update'
    post 'posts/:id/remove' => 'posts#remove'
    post 'dibs/:id/removedib' => 'dibs#remove_dib'


    resources :password_resets,  only: [:new, :create, :edit, :update]

    get 'posts/:id' => 'posts#show'
  end

  root 'posts#index'

  get '(*url)' => 'posts#index'

end
