require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
    let(:service) { create(:service) }
  let!(:schedule) { create(:schedule) }
  let(:valid_attributes) { { day_of_week: 'X', week: 26, start_time: "04:00", end_time: '14:00', service_id: service.id } }
  let(:invalid_attributes) { { day_of_week: '', week: '' } }
  let(:invalid_times) { { day_of_week: 'M', week: 26, start_time: "14:00", end_time: '04:00', service_id: service.id } }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: schedule.to_param }
      expect(response).to be_successful
    end

    it "returns not found for invalid id" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Schedule" do
        expect {
          post :create, params: { schedule: valid_attributes }
        }.to change(Schedule, :count).by(1)
      end

      it "renders a JSON response with the new schedule" do
        post :create, params: { schedule: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new schedule" do
        post :create, params: { schedule: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      it "end_time before start_time for the new schedule" do
        post :create, params: { schedule: invalid_times }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("must be before end time")
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { day_of_week: 'L' } }

      it "updates the requested schedule" do
        put :update, params: { id: schedule.to_param, schedule: new_attributes }
        schedule.reload
        expect(schedule.day_of_week).to eq('L')
      end

      it "renders a JSON response with the schedule" do
        put :update, params: { id: schedule.to_param, schedule: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the schedule" do
        put :update, params: { id: schedule.to_param, schedule: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested schedule" do
      expect {
        delete :destroy, params: { id: schedule.to_param }
      }.to change(Schedule, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { id: schedule.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
