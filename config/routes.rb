Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"
  resources :books
  resources :rentals

  resources :rentals do
    member do
      post :return
    end
  end

  post 'identify_reader', to: 'rentals#identify_reader'
  get 'show_reader_form', to: 'rentals#show_reader_form'

end
