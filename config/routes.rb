Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'static_pages#home'
  resources :users, only: [:index, :show] do
    resources :posts, only: [:index, :new, :create]
    resources :pics, only: [:index, :create]
  end
  resources :pics, only: [:index, :show, :destroy] do
    resources :comments, only: [  :create]
  end
  resources :posts, except: [:new, :create] do
    resources :comments, only: [  :create]
  end
  resources :comments, except: [:index, :new, :create, :show]
  resources :friend_requests, only: [:index, :create, :destroy]
  resources :friendships, only: [:index, :create, :destroy]
  get 'friends' => 'friendships#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
