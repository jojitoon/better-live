Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/me', to: 'users#index'
  get '/users/:id/bets', to: 'users#bets'
  resources :users
  post '/login', to: 'auth#login'
  resources :bets, only: [:create]
  resources :games
  get '/leaderboard', to: 'bets#leaderboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "fund-user-dummy", to: "users#fund_user_dummy"

  # Defines the root path route ("/")
  # root "posts#index"

end
