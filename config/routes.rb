# config/routes.rb

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define the root route
  root 'posts#index'

  # Devise routes for user authentication
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Posts and Comments routes
  resources :posts do
    resources :comments
    member do
      get 'like'
      get 'dislike'
    end
    get 'show', on: :member
    post 'create', on: :collection
  end

  # Chats routes
  resources :chats, only: [:index, :create, :show] do
    resources :messages, only: [:create]
  end

  # User profiles route
  resources :profiles, only: [:show]

  # Custom route for starting a chat with a specific user
  get 'chat/:id', to: 'chats#show', as: 'chat_with'
end
