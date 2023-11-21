class ReaderCardsController < ApplicationController
    def show_reader_form
      @book = Book.find(params[:book_id]) if params[:book_id].present?
      @reader_card = ReaderCard.new
    end
  
    def identify_reader
      @reader_card = ReaderCard.find_by(number: params[:number], code: params[:code])
      if @reader_card
        if @reader_card.valid?
          session[:current_reader_id] = @reader_card.user_id
          redirect_to session.delete(:return_to) || root_path, notice: "Czytelnik zidentyfikowany."
        else
            redirect_to show_reader_card_path, alert: "Najpierw zidentyfikuj czytelnika."
        end
      else
        flash[:alert] = "Nieprawidłowy numer lub kod karty."
        redirect_to show_reader_card_path, alert: "Najpierw zidentyfikuj czytelnika."
      end
    end
  
    def forget_reader
      session.delete(:current_reader_id)
      redirect_to root_path, notice: "Czytelnik został zapomniany."
    end
       
  end
  