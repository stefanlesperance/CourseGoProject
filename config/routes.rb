Rails.application.routes.draw do
  resources :enrollments do 
    get :my_students, on: :collection
  end
  devise_for :users
  resources :users
  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    #I believe member here stands for current course
    member do
      #This will add two new accounts in our routes.
      patch :approve
      patch :unapprove
    end
    #Enrollments is above too, but im basically subclassing routes for enrollments methods new + create
    #beneath courses, so enrollments_new_path becomes courses_enrollments_new_path (a fictious example)
      resources :enrollments, only: [:new, :create]
      resources :lessons

  end
  root'home#index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'

  namespace :charts do     
    get 'money_makers'
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'popular_courses'
  end
  #Compare above and below, since it seems to auto direct to the right method immediately.
  #get 'charts/users_per_day', to: 'charts#users_per_day'
  #get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  #get 'charts/popular_courses', to: 'charts#popular_courses'
  #get 'charts/money_makers', to: 'charts#money_makers'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
