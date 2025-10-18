Rails.application.routes.draw do
  resources :users, only: [ :create ] # if you support signup

  resources :businesses, only: [ :index, :show ] do
    resources :reviews, only: [ :index, :create ]
  end

  post "/login", to: "authentication#login"
  get "/protected", to: "protected#index"
end
