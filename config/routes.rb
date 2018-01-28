Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  get 'events', to: 'events#index'
  post 'events', to: 'events#create'
  get 'events/:id', to: 'events#show'
  delete 'events/:id', to: 'events#destroy'
end
