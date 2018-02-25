Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  get 'events', to: 'events#index'
  post 'events', to: 'events#create'

  get 'events/:id', to: 'events#show'
  put 'events/:id', to: 'events#update'
  delete 'events/:id', to: 'events#destroy'

  post 'events/:id/check', to: 'events#check'

  get 'events/:id/validation_rules', to: 'validation_rules#index'
  post 'events/:id/validation_rules', to: 'validation_rules#create'

  delete 'events/:id/validation_rules/:validation_rule_id', to: 'validation_rules#destroy'
end
