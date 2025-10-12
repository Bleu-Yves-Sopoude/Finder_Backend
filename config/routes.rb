Rails.application.routes.draw do
  resources :businesses do
    resources :reviews, only: [ :index, :create ]
  end

  get "protected/index"

  get "/login", to: "authentication#new"
  post "/login", to: "authentication#login"
  get "/protected", to: "protected#index"
end
