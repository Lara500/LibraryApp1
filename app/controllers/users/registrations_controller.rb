# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        if params[:user][:type] == 'Librarian'
          user.type = 'Librarian'
        elsif params[:user][:type] == 'Reader'
          user.type = 'Reader'
        end
        # Możesz dodać dodatkową logikę, jeśli jest potrzebna
      end
    end
  end
  