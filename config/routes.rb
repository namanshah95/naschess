Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:registrations, :sessions]
  devise_for :parents, skip: :sessions
  devise_for :tutors, skip: :sessions

  devise_scope :user do
    root :to => 'devise/sessions#new'
  end

  get "groups/add_slot", as: "add_slot"
  get "groups/remove_slot", as: "remove_slot"
  get "groups/update_host", as: "update_host"
  resources :groups
  resources :children
  patch "children/:id/drop" => "children#drop", as: :drop

  resources :admins
  resources :parents
  get "parents/:id/payments" => "parents#payments", as: :parent_payments
  post "parents/:id/store_card" => "parents#store_card", as: :parent_store_card
  resources :tutors
  get "tutors/:id/lessons" => "tutors#lessons", as: :tutor_lessons

  get "lessons/update_attendance", as: "update_attendance"
  resources :lessons
end
