Rails.application.routes.draw do
  resources :lessons
  devise_for :users
  resources :users
  resources :courses
  root'home#index'
  get 'home/activity'

      
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
