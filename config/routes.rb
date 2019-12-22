Rails.application.routes.draw do

  if Rails.env == 'development'
    require 'sidekiq/web'
    require 'sidekiq-scheduler/web'
  end

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :notifications, only: [:index, :show, :update]
      resources :facilities, only: [:index, :show, :create, :update, :destroy]
      resources :rooms, only: [:index, :show, :create, :update, :destroy]
      resources :ota, only: [:index, :show, :create, :update, :destroy]
      resources :ota_rooms, only: [:index, :show, :create, :update, :destroy]
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:show, :update, :destroy]
      post      '/ota/:id/crawl/rooms',    to: 'ota#get_rooms'
      post      '/ota/:id/crawl/bookings', to: 'ota#get_bookings'
      get    '/subscribe', to: 'subscribes#show'
      post   '/subscribe', to: 'subscribes#create'
      put    '/subscribe', to: 'subscribes#update'
      patch  '/subscribe', to: 'subscribes#update'
    end
  end

  scope :api, { format: 'json'} do
    scope :v1 do
      devise_for :users, :class_name => 'User', controllers: {
        :registrations => "user/registrations",
        :sessions => "user/sessions",
      }
      devise_scope :user do
        get 'users' => 'api/v1/users#index'
        get 'current_user' => 'api/v1/users#current'
      end
    end
  end

  if Rails.env == 'development'
    mount Sidekiq::Web, at: "/sidekiq"
  end

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :notifications, only: [:index, :show, :create, :update, :destroy]
      resources :facilities, only: [:index, :show, :create, :update, :destroy]
      resources :rooms, only: [:index, :show, :create, :update, :destroy]
      resources :ota, only: [:index, :show, :create, :update, :destroy]
      resources :ota_rooms, only: [:index, :show, :create, :update, :destroy]
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:show, :update, :destroy]
    end
  end

  namespace :admin do
    devise_for :users, controllers: {
      sessions: "admin/users/sessions",
    }, skip: [:registrations]
    # resources :notifications
    resources :facilities
    resources :rooms
    resources :ota
    # resources :ota_rooms
    # resources :scraping_logs, only: [:index, :show]
    resources :crawl_logs, only: [:index, :show]
    resources :bookings, expect: [:new, :create]
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    get '/dashboard', to: 'pages#dashboard'
  end

  root :to => "app#index"
  match "*path", to: "app#index", format: false, via: :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end