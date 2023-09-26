# config/routes.rb

Rails.application.routes.draw do
  # Define the root route
  root 'posts#index'

  # Devise routes for user authentication
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Posts and Comments routes
  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      get 'like'
      get 'dislike'
    end
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
