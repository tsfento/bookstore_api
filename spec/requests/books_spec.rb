require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET /books' do
    let(:book) { create(:book) }

    before do
      book
      get '/books'
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns books' do
      expect(response.body).to eq(Book.all.to_json)
    end
  end

  describe 'GET /books/:id' do
    let(:book) { create(:book) }

    before { get "/books/#{book.id}" }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns the book' do
      expect(response.body).to eq(book.to_json)
    end
  end

  describe 'POST /books' do
    context 'when the request is valid' do
      let (:author) { create(:author) }

      before do
        book_attributes = attributes_for(:book, author_id: author.id)
        post '/books', params: { book: book_attributes }
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "creates a new book" do
        expect(Book.count).to eq(1)
      end
    end

    context 'when the request is invalid' do
      before do
        book_attributes = attributes_for(:book, author_id: nil)
        post "/books", params: { book: book_attributes }
      end

      it "returns a response with errors" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT /books/:id' do
    let(:book) { create(:book) }

    context 'when request is valid' do
      before do
        book_attributes = { title: 'Updated Title' }
        put "/books/#{book.id}", params: { book: book_attributes }
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "updates an book" do
        book.reload
        expect(book.title).to eq('Updated Title')
      end
    end

    context 'when request is invalid' do
      before do
        book_attributes = { title: nil }
        put "/books/#{book.id}", params: { book: book_attributes }
      end

      it "returns a response with errors" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /books/:id' do
    let(:book) {create(:book)}

    before do
      delete "/books/#{book.id}"
    end

    it "returns a successful response" do
      expect(response).to be_successful
    end

    it "deletes an book" do
      expect(Book.count).to eq(0)
    end
  end
end
