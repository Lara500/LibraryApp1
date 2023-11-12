class BooksController < ApplicationController
    def index
      @books = Book.all
    end
  
    def show
      @book = Book.find(params[:id])
    end
  
    def new
      @book = Book.new
    end

    def create
        @book = Book.new(book_params)
      
        if @book.save
          redirect_to @book, notice: 'Książka została pomyślnie utworzona.'
        else
          render :new
        end
    end
  
    def edit
      @book = Book.find(params[:id])
    end

    def update
        @book = Book.find(params[:id])
      
        if @book.update(book_params)
          redirect_to @book, notice: 'Książka została pomyślnie zaktualizowana.'
        else
          render :edit
        end
    end
  
    def destroy
        @book = Book.find(params[:id])
        @book.destroy
        redirect_to books_url, notice: 'Książka została pomyślnie usunięta.'
    end

    private

    def book_params
        params.require(:book).permit(:title, :author, :description, :genre, :release_date, :publisher, :ISBN, :page_number, :translation, :rental_status)
    end
end
  
