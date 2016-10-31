Rails.application.routes.draw do
  root to: 'visitors#index'

  resources :posts
end
