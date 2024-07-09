Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions/sessions'
  }
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/services/week_selected", to: "services#week_selected"
  get "/services/available_weeks/:id", to: "services#available_weeks"
  get "/services/total_used_hours_per_user/:id", to: "services#total_used_hours_per_user"
  get "/services/used_hours_per_user/:id", to: "services#used_hours_per_user"
  get "/services/available_hours_per_user/:id", to: "services#available_hours_per_user"
  get "/services/availabilities_hours/:id", to: "services#availabilities_hours"

  resources :clients
  resources :daily_shifts
  resources :services
  resources :availabilities
  resources :schedules

  
end
