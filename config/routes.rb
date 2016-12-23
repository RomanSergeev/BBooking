Rails.application.routes.draw do
  get 'users/:id/edit_services', to: 'users#edit_services', as: :edit_services
  get 'users/:id/show_services', to: 'users#show_services', as: :show_services
  get 'services/:id/book', to: 'services#book', as: :book_service
  get 'search', to: 'application#search', as: :search
  post 'services/:id/book_payment', to: 'services#book_payment', as: :book_payment
  post 'services/:id/booking_completed', to: 'services#booking_completed', as: :booking_completed
  devise_for :users, controllers: {registrations: 'registrations'}
  resources :users do
    resource :calendar
  end
  resources :profiles, except: [:show, :index]
  resources :services, except: [:index]
  get 'welcome/index'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
