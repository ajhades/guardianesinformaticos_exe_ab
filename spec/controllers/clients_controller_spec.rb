require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:user) { create(:user) }
  let!(:client) { create(:client) }
  let(:valid_attributes) { { name: 'John Doe', nit: '345123', status: "1" } }
  let(:invalid_attributes) { { name: '', nit: '' } }

  before(:each) do
    authenticate_user(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: client.to_param }
      expect(response).to be_successful
    end

    it "returns not found for invalid id" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Client" do
        expect {
          post :create, params: { client: valid_attributes }
        }.to change(Client, :count).by(1)
      end

      it "renders a JSON response with the new client" do
        post :create, params: { client: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new client" do
        post :create, params: { client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: 'Jane Doe' } }

      it "updates the requested client" do
        put :update, params: { id: client.to_param, client: new_attributes }
        client.reload
        expect(client.name).to eq('Jane Doe')
      end

      it "renders a JSON response with the client" do
        put :update, params: { id: client.to_param, client: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the client" do
        put :update, params: { id: client.to_param, client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested client" do
      expect {
        delete :destroy, params: { id: client.to_param }
      }.to change(Client, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { id: client.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
