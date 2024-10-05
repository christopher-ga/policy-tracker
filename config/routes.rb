Rails.application.routes.draw do
  resources :user_saved_bills, only:[:index]
  resources :users
  resources :bills, only: [:index, :create]
  get 'bills/data', to: 'bills#bills_data'
  get "userbills", to: "user_saved_bills#index"
  post 'bills/bill_data', to: 'bills#bill_data'
  post 'bills/sponsor_data', to: 'bills#sponsor_data'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: [:create, :new, :destroy]
  # Defines the root path route ("/")
  # root "posts#index"
end
