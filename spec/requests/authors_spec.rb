require 'rails_helper'

RSpec.describe 'Authors', type: :request do
  describe 'GET /authors' do
    let(:authors) { create_list(:author, 10) }

    before { get '/authors'}

    it 'returns a successfule response' do
      expect(response).to be_successful
    end

    it 'returns authors' do
      expect(response.body).to eq(Author.all.to_json)
    end
  end

  describe 'GET /authors/:id' do
    let(:author) { create(:author) }

    before { get "/authors/#{author.id}" }

    it 'returns a successfule response' do
      expect(response).to be_successful
    end

    it 'returns the author' do
      expect(response.body).to eq(author.to_json)
    end
  end

  describe 'POST /authors' do
    context 'when the request is valid' do
      before do
        author_attributes = attributes_for(:author)
        post '/authors', params: { author: author_attributes }
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "creates a new author" do
        expect(Author.count).to eq(1)
      end
    end

    context 'when the request is invalid' do
      before do
        author_attributes = attributes_for(:author, name: nil)
        post "/authors", params: { author: author_attributes }
      end

      it "returns a response with errors" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT /authors/:id' do
    let(:author) { create(:author) }

    context 'when request is valid' do
      before do
        author_attributes = { name: 'Updated Name' }
        put "/authors/#{author.id}", params: { author: author_attributes }
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "updates an author" do
        author.reload
        expect(author.name).to eq('Updated Name')
      end
    end

    context 'when request is invalid' do
      before do
        author_attributes = { name: nil }
        put "/authors/#{author.id}", params: { author: author_attributes }
      end

      it "returns a response with errors" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /authors/:id' do
    let(:author) {create(:author)}

    before do
      delete "/authors/#{author.id}"
    end

    it "returns a successful response" do
      expect(response).to be_successful
    end

    it "deletes an author" do
      expect(Author.count).to eq(0)
    end
  end
end
