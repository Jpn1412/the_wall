Rails.application.routes.draw do
  get '/blogs', to: "blogs#index"
  get '/login', to: 'users#login'
  get '/registration', to: 'users#registration'
  get '/edit_message/:id', to: 'messages#edit_page'
  get '/edit_comment/:id', to: 'comments#edit_page'
  post '/process_register', to: 'users#process_register'
  post '/process_login', to: 'users#process_login'
  get '/logout', to: 'blogs#logout'
  post '/process_message', to: 'messages#process_message'
  post '/process_comment', to: 'comments#process_comment'
  post '/process_edit_message', to: 'messages#process_edit'
  post '/process_edit_comment', to: 'comments#process_edit'
  delete '/delete_message', to: 'messages#delete'
  delete '/delete_comment', to: 'comments#delete'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
