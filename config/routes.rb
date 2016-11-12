Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts
  
  resources :users do
    collection do
      post 'reset_password'
      get 'get_email'
    end
  end

  resources :sessions do
    collection do
      get 'sign_out'
    end
  end
end
