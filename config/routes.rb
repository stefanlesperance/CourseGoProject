Rails.application.routes.draw do
  resources :enrollments do 
    get :my_students, on: :collection
  end
  devise_for :users
  resources :users
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    #Enrollments is above too, but im basically subclassing routes for enrollments methods new + create
    #beneath courses, so enrollments_new_path becomes courses_enrollments_new_path (a fictious example)
      resources :enrollments, only: [:new, :create]
      resources :lessons

  end
  root'home#index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'

  #For test purposes.

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
