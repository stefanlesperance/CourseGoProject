Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :users
  resources :courses do
    #Enrollments is above too, but im basically subclassing routes for enrollments methods new + create
    #beneath courses, so enrollments_new_path becomes courses_enrollments_new_path (a fictious example)
      resources :enrollments, only: [:new, :create]
      resources :lessons

  end
  root'home#index'
  get 'activity', to: 'home#activity'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
