Rails.application.routes.draw do
  root 'tickets#index'
  
  resources :tickets, only: [:index, :show]
end
