Rails.application.routes.draw do
  root 'main#index'
  get 'changes_input/index'
  get 'changes_view/index'
  post 'changes_input/create_change'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'subscriptions', to: 'subscriptions#index'
  post 'subscriptions', to: 'subscriptions#create'
  get 'subscriptions/delete', to: 'subscriptions#delete'

  post 'send_changes', to: 'changes#send_changes'

  resources :changes
  resources :professors, only: [:index, :create]
  get 'professors/:name', to: 'professors#show'
  resources :settings, only: [:index, :create]
end
