Rails.application.routes.draw do
  root 'main#index'
  get 'changes_input/index'
  get 'changes_view/index'
  post 'changes_input/create_change'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'subscriptions', to: 'subscriptions#index'
  post 'subscriptions', to: 'subscriptions#create'
  get 'subscriptions/delete/:email', to: 'subscriptions#delete'

  resources :changes
  resources :settings, only: [:index, :create]
end
