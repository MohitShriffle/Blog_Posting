# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :blogs
  post 'users/login', to: 'authentication#login'
  post 'users/sent_otp',to:'users#sent_otp'
  post 'users/verification',to: 'users#verification'
  
end
