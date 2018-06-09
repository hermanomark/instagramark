Rails.application.routes.draw do
  # root 'posts#index'
  # devise_for :users

devise_for :users

devise_scope :user do
  authenticated :user do
    root 'posts#index', as: :authenticated_root
  end

  unauthenticated do
    root 'devise/sessions#new', as: :unauthenticated_root
  end
end

  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end

  resources :posts

  # root to: "home#index"
  get 'home/index'

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

