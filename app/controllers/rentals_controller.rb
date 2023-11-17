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

          @rental.rental_status = 'wypożyczona'
          @rental.rental_date = Time.current
          @rental.return_date = Date.current + 4.weeks
          @rental.overdue = false
      
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

      def show_reader_form
      end
      
      def identify_reader
        reader_card = ReaderCard.find_by(number: params[:number], code: params[:code])
    
        if reader_card
          session[:current_reader_id] = reader_card.user_id
          redirect_to new_rental_path, notice: "Czytelnik zidentyfikowany."
        else
          redirect_to show_reader_form_path, alert: "Nieprawidłowy numer lub kod karty."
        end
      end

#do dokończenia jak będą dodane widoki wyświetlania wypożyczeń
      def return

        @rental = Rental.find_by(params[:id])
      
        if @rental
          @rental.return_date = Time.current
          @rental.rental_status = 'zwrócona' # Aktualizacja statusu
          @rental.overdue = check_overdue(@rental)
      
          if @rental.save
            redirect_to somewhere_path, notice: 'Książka została pomyślnie zwrócona.'
          else
            render :edit, alert: 'Nie udało się zwrócić książki.'
          end
        else
          redirect_to somewhere_path, alert: 'Nie znaleziono wypożyczenia.'
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

    def check_overdue(rental)
      rental.return_date > rental.expected_return_date
    end
  end
  