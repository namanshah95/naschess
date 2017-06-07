Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:registrations, :sessions]
  devise_for :parents, skip: :sessions
  devise_for :tutors, skip: :sessions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'groups#index'

  resources :groups
  resources :children
  patch "children/:id/drop" => "children#drop", as: :drop

  resources :parents
  resources :tutors
end
