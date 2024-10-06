# config/routes.rb
Rails.application.routes.draw do

  root "pages#stub_page"

  namespace :api do
    namespace :v1 do
      get "user_bills", to: "user_saved_bills#index"

      resources :bills, only: [:index, :create] do
        collection do
          get 'congress_bills', to: 'bills#congress_bills'
          post 'congress_bills', to: 'bills#congress_bill'
          post 'congress_sponsor', to: 'bills#congress_sponsor'
        end
      end
    end
  end

  resources :users
  resource :session, only: [:create, :new, :destroy]

  get "up", to: "rails/health#show", as: :rails_health_check
end
