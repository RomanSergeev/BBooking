Rails.application.routes.draw do
	get 'users/:id/edit_profile', to: 'users#edit_profile', as: 'edit_profile'
	get 'users/:id/edit_services', to: 'users#edit_services', as: 'edit_services'
	devise_for :users, controllers: { registrations: "registrations" }
  resources :users
  get 'welcome/index'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
