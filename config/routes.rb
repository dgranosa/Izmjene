Rails.application.routes.draw do
  get 'sessions/new'
  root 'main#index'
  get 'changes_input/index'
  get 'changes_view/index'
  post 'changes_input/create_change'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'subscriptions', to: 'subscriptions#index'
  post 'subscriptions', to: 'subscriptions#create'
  get 'subscriptions/delete', to: 'subscriptions#delete'
  get 'subscriptions/confirm', to: 'subscriptions#confirm'

  post 'send_changes', to: 'changes#send_changes'

  resources :changes
  resources :professors, only: [:index, :create]
  
  get 'professors/:name', to: 'professors#show'

  resources :settings, only: [:index, :create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
