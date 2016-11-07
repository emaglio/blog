Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts
  resources :users
  
  resources :sessions do
    collection do
      get 'sign_out'
    end
  end
end
