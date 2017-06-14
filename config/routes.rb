Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:registrations, :sessions]
  devise_for :parents, skip: :sessions
  devise_for :tutors, skip: :sessions

  resources :groups
  resources :children
  patch "children/:id/drop" => "children#drop", as: :drop

  resources :admins
  resources :parents do
  	resources :transactions 
  end
  resources :tutors
  get "tutors/:id/lessons" => "tutors#lessons", as: :tutor_lessons

  resources :lessons
  get "lessons/update_attendance", as: "update_attendance"

  root "groups#index"
end
