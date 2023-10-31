# frozen_string_literal: true
require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :blogs
  resources :users do 
    resources :subscriptions 
  end
  resources :users do
    resources :blogs 
  end
  resources :plans
  resources :subscriptions
  post 'users/login', to: 'authentication#login'
  post 'users/sent_otp', to: 'users#sent_otp'
  post 'users/verification', to: 'users#verification'
  get 'blogs/view_blog/:id', to: 'blogs#view_blog'
  get '/blog_read', to: 'blogs#blog_read'
end
