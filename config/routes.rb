Rails.application.routes.draw do
  get "protected/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  post "/login", to: "authentication#login"
  get "/protected", to: "protected#index"


  # Defines the root path route ("/")
  # root "posts#index"
end
