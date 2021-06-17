Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :courses
  root'home#index'
  get 'home/activity'
  devise_scope :user do
  get "/some/route" => "some_devise_controller"
  end
      
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
