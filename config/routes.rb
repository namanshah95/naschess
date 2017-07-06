Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:registrations, :sessions]
  devise_for :parents, skip: :sessions
  devise_for :tutors, skip: :sessions

  get "groups/add_slot", as: "add_slot"
  get "groups/remove_slot", as: "remove_slot"
  resources :groups
  resources :children
  patch "children/:id/drop" => "children#drop", as: :drop

  resources :admins
  resources :parents do
  	resources :transactions 
  end
  resources :tutors
  get "tutors/:id/lessons" => "tutors#lessons", as: :tutor_lessons

  get "lessons/update_attendance", as: "update_attendance"
  resources :lessons

  root "groups#index"
end
