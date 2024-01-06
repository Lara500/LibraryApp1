class RentalsController < ApplicationController
    before_action :authenticate_user!  # Devise authentication
    before_action :check_librarian, only: [:new, :create, :edit, :update, :destroy]
    before_action :require_reader_identification, only: [:create, :new]
  
     def new
        @rental = Rental.new
        @rental.book_id = params[:book] if params[:book]
      end
  

    def create
      reader = verify_reader(session[:current_reader_id]) 
    if reader

       @rental = Rental.new(rental_params)
       @rental.user_id = reader.id
       @rental.rental_date = Time.current
       @rental.expected_return_date = Date.current + 4.weeks
       @rental.overdue = false
       check_availability

      else
        flash.now[:alert] = "Nieprawidłowy numer lub kod karty."
        render :new
      end
    end

    def index_rentals

      if current_user.type == 'Librarian'
        user_id = session[:current_reader_id]
      elsif current_user.type == 'Reader'
        user_id = current_user.id
      end
      @reader = User.find(user_id) # Zakładając, że identyfikacja czytelnika przechowywana jest w sesji
      @rentals = Rental.where(user_id: @reader.id)
    end

      def return

        @rental = Rental.find_by(id: params[:id])
        @book = Book.find_by(id: @rental.book_id)
      
        if @rental
          @rental.return_date = Time.current
          @rental.rental_status = 'zwrócona'
          @book.update(status: 'dostępna')

          @rental.overdue = check_overdue(@rental)
      
          if @rental.save
            redirect_to index_rentals_path, notice: 'Książka została pomyślnie zwrócona.'
          else
            render :edit, alert: 'Nie udało się zwrócić książki.'
          end
        else
          redirect_to index_rentals_path, alert: 'Nie znaleziono wypożyczenia.'
        end
      end

    private
  
    def rental_params
        params.require(:rental).permit(:book_id)
    end

    def verify_params
        params.require(:rental).permit(:number, :code)
    end
  
    def verify_reader(user_id)
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

    def require_reader_identification
      unless session[:current_reader_id].present?
        session[:return_to] = request.fullpath
        redirect_to show_reader_card_path, alert: "Najpierw zidentyfikuj czytelnika."
      end
    end

    def check_availability
      book = Book.find_by(id: @rental.book_id)
      if book.status == 'dostępna'
        @rental.rental_status = 'wypożyczona'
        book.update(status: 'wypożyczona')

        if @rental.save
          redirect_to book_path(@rental.book_id), notice: "Książka wypożyczona pomyślnie."
        else
          render :new
        end
      else
        redirect_to book_path(@rental.book_id), alert: "Książka nie jest dostępna do wypożyczenia."
      end
    end
  end
  