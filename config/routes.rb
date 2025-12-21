Rails.application.routes.draw do
  resources :users, only: [ :create ]

  resources :businesses, only: [ :index, :show, :create ] do
    resources :reviews, only: [ :index, :create ]

    collection do
      get :nearby
    end
  end

  post "/login", to: "authentication#login"
  get "/protected", to: "protected#index"
end
