Rails.application.routes.draw do
  devise_for :users


  devise_scope :user do
     get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root 'posts#index'

  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      get 'like'
      get 'dislike'
    end
  
  end

  resources :chats, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  get 'chat/:id', to: 'chats#show', as: 'chat_with'
end