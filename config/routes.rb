Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"
  resources :books

  resources :rentals, except: [:show] do
    member do
      post :return
    end
  end

  get '/reader_cards/show_reader_card', to: 'reader_cards#show_reader_card', as: 'show_reader_card'
  post '/reader_cards/identify_reader', to: 'reader_cards#identify_reader', as: 'identify_reader'
  get '/reader_cards/forget_reader', to: 'reader_cards#forget_reader', as: 'forget_reader'
  get 'rentals/index_rentals', to: 'rentals#index_rentals', as: 'index_rentals'
end
