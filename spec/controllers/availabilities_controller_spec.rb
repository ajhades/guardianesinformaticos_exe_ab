require 'rails_helper'

RSpec.describe AvailabilitiesController, type: :controller do
    let(:user) { create(:user) }
  let!(:availability) { create(:availability, user: user) }
  let(:valid_attributes) { { day_of_week: 'X', week: 26, date: "2017-06-24 03:57:15.023", time: '04:00', user_id: user.id } }
  let(:invalid_attributes) { { day_of_week: '', week: '' } }
  let(:duplicate_availability){ {day_of_week: availability.day_of_week, time: availability.time, week: availability.week, date: availability.date}}

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: availability.to_param }
      expect(response).to be_successful
    end

    it "returns not found for invalid id" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Availability" do
        expect {
            post :create, params: { availability: valid_attributes }
        }.to change(Availability, :count).by(1)
      end

      it "renders a JSON response with the new availability" do
        post :create, params: { availability: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new availability" do
        post :create, params: { availability: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      it "does not allow duplicates" do
        post :create, params: { availability: duplicate_availability }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("there is already one")
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { time: '15:00' } }

      it "updates the requested availability" do
        put :update, params: { id: availability.to_param, availability: new_attributes }
        availability.reload
        expect(availability.time).to eq('15:00')
      end

      it "renders a JSON response with the availability" do
        put :update, params: { id: availability.to_param, availability: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the availability" do
        put :update, params: { id: availability.to_param, availability: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested availability" do
      expect {
        delete :destroy, params: { id: availability.to_param }
      }.to change(Availability, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { id: availability.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
