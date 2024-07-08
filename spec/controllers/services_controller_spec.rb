require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  let!(:service) { create(:service) }
  let(:valid_attributes) { { name: 'John Doe', start_date: '2017-06-24 03:57:15.023', end_date: '2027-06-24 03:57:15.023', status: "1", client_id: create(:client).id } }
  let(:invalid_attributes) { { name: '', start_date: '', end_date: '' } }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: service.to_param }
      expect(response).to be_successful
    end

    it "returns not found for invalid id" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Service" do
        expect {
          post :create, params: { service: valid_attributes }
        }.to change(Service, :count).by(1)
      end

      it "renders a JSON response with the new service" do
        post :create, params: { service: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new service" do
        post :create, params: { service: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: 'Jane Doe' } }

      it "updates the requested service" do
        put :update, params: { id: service.to_param, service: new_attributes }
        service.reload
        expect(service.name).to eq('Jane Doe')
      end

      it "renders a JSON response with the service" do
        put :update, params: { id: service.to_param, service: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the service" do
        put :update, params: { id: service.to_param, service: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested service" do
      expect {
        delete :destroy, params: { id: service.to_param }
      }.to change(Service, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { id: service.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
