Rails.application.routes.draw do
  
  devise_for :users, :controllers => { :registrations => "user/registrations" }

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

  # generate index for users
  # NOTE: put this after the 'devise_for :users' line
  resources :users, only: [:index, :show]
  resources :follows
  resources :posts

  get 'following', to: 'users#following'
  get 'find_people', to: 'users#find_people'
  get 'search_users', to: 'users#search'
  post 'follow_user', to: 'users#follow_user'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

