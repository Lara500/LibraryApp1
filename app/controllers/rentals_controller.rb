class RentalsController < ApplicationController
    before_action :authenticate_user!  # Devise authentication
    before_action :check_librarian, only: [:new, :create, :edit, :update, :destroy]
  
    def new
        @rental = Rental.new
        @rental.book_id = params[:book_id] if params[:book_id]
      end
  
      def create
        verification_params = verify_params
        reader = verify_reader(verification_params[:number], verification_params[:code])
        
        if reader

          @rental = Rental.new(rental_params)
          @rental.user_id = reader.id
      
          if @rental.save
            redirect_to book_path(@rental.book_id), notice: "Książka wypożyczona pomyślnie."
          else
            render :new
          end
        else
          flash.now[:alert] = "Nieprawidłowy numer lub kod karty."
          render :new
        end
      end
  
    private
  
    def rental_params
        params.require(:rental).permit(:book_id)
    end

    def verify_params
        params.require(:rental).permit(:number, :code)
    end
  
    def verify_reader(number, code)
        user_id = ReaderCard.find_by(number: number, code: code).user_id
        User.find_by(id: user_id, type: 'Reader')
    end

    def check_librarian
        unless current_user.librarian?
          redirect_to root_path, alert: "Tylko bibliotekarze mogą zarządzać książkami."
        end
      end
  end
  