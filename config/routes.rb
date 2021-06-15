Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :courses
  root'home#index'
  get 'home/activity'
  devise_scope :user do
     get 'users/sign_out', to: 'devise/sessions#destroy'
  end
      
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
