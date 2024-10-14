# config/routes.rb
Rails.application.routes.draw do

  root "pages#stub_page"
  get "landing" => "pages#landing_page"
  get "test" => "sponsors#test_route"
  get "home" => "pages#home_page"
  get "search" => "pages#search_page"


  namespace :api do
    namespace :v1 do
      get "user_bills", to: "user_saved_bills#index"
      post "user_bills", to: "user_saved_bills#create"
      delete "user_bills", to: "user_saved_bills#destroy"

      resources :bills, only: [:create] do
        collection do
          get "" => "bills#gov_collection"
          post "search" => "bills#gov_search"
          get 'congress_bills', to: 'bills#congress_bills'
          post 'congress_bills', to: 'bills#congress_bill'
          post 'congress_sponsor', to: 'bills#congress_sponsor'
          post "congress_bills_search", to: "bills#congress_bills_search"
        end
      end
    end
  end

  resources :users
  resource :session, only: [:create, :new, :destroy]

  get "up", to: "rails/health#show", as: :rails_health_check
end
