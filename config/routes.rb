Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts
  
  resources :users
  get 'user/reset_password', controller: :user, action: :reset_password, as: "reset_password"
  
  resources :sessions do
    collection do
      get 'sign_out'
    end
  end
end
