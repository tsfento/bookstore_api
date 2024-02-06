class BooksController < ApplicationController
    before_action :set_book, only: [:show, :update, :destroy]

    def index
        books = Book.all

        render json: books, status: :ok
    end

    def show
        render json: @book, status: :ok
    end

    def create
        book = Book.new(book_params)

        if book.save
            render json: book, status: :created
        else
            render json: book.errors, status: :unprocessable_entity
        end
    end

    def update
        if @book.update(book_params)
            render json: @book, status: :ok
        else
            render json: @book.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @book.destroy
            render json: nil, status: :no_content
        else
            render json: @book.errors, status: :unprocessable_entity
        end
    end

    private

    def set_book
        @book = Book.find(params[:id])
    end

    def book_params
        params.require(:book).permit(:title, :author_id)
    end
end
