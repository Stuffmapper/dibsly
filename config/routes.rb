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

    post 'users/reconfirm' => 'users#resend_verify'

    post 'users/:id', :to => 'users#show', :as => :user
    resources :users, only: [:show, :create, :update, :index]

    get  'messages/status', :to => 'messages#inbox_status'
    resources :messages, only: [:index]
    resources :images, only: [:create ]
    resources :alerts, only: [:index, :update ]

    get 'posts' => 'posts#index'
    post 'posts' => 'posts#create'

    get 'posts/geolocated' => 'posts#geolocated'
    get 'search' => 'posts#search'
    get 'my-stuff' => 'posts#my_stuff'
    get 'my-dibs' => 'posts#my_dibs'

    post 'posts/:id/undib' => 'dibs#undib'
    # post 'posts/:id/update' => 'posts#update'
    
    #UNTESTED
    post 'posts/:id/removecurrentdib' => 'posts#remove_dib'

    post 'posts/:id/remove' => 'posts#remove'

    post 'dibs/:id/removedib' => 'dibs#remove_dib'

    post 'dibs/:dib_id/messages' => 'dibs#send_message'
    get 'dibs/:dib_id/messages' => 'dibs#messages'
    post 'dibs/:dib_id/markread' => 'dibs#mark_read'
    get 'dibs/:dib_id/unread' => 'dibs#unread'

    get 'policies/termsofuse' => 'policies#terms_of_use'
    get 'policies/privacy' => 'policies#privacy'



    resources :posts, only: [:create, :index, :update, :show] do
      resources :dibs, only: [:create ]
    end



    resources :password_resets,  only: [:new, :create, :edit, :update]

  end
  get 'privacy' => 'pages#privacy'
  get 'termsofuse' => 'pages#terms_of_use'
  get 'support' => 'pages#support'
  get 'jobs' => 'pages#jobs'

  get '/beta' => 'posts#index'
  get '/' => 'pages#splash'

  get '(*url)' => 'posts#index'

end
