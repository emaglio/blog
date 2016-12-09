Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts
  
  resources :users do
    collection do
      post 'reset_password'
      get 'get_email'
      get 'get_new_password'
      post 'change_password'
      post 'block'
    end
  end

  resources :sessions do
    collection do
      get 'sign_out'
    end
  end
end
