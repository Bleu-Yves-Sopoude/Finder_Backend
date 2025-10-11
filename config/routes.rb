Rails.application.routes.draw do
  get "protected/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "/login", to: "authentication#new"

  post "/login", to: "authentication#login"
  get "/protected", to: "protected#index"


  # Defines the root path route ("/")
  # root "posts#index"
end
