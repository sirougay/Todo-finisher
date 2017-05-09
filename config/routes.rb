Rails.application.routes.draw do
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "timers#show"
  get "/timer" => "timers#show"
  resources :users, only:[:edit]
  resources :timers
  resources :diaries
  resources :tasks
  post "/tasks/sort" => "tasks#sort"
end
