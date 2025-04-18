Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :index, :update, :destroy]
    collection do
      get 'search', to: 'posts#search'
    end
  end
  resources :users, only: [:index, :show, :update, :destroy] do
    collection do
      post 'whose_email/', to: 'users#search_by_email'
    end
  end
  get 'current_user/', to: 'current_user#index'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
