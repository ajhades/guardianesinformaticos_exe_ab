require 'rails_helper'

RSpec.describe DailyShiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:schedule) { create(:schedule) }
  let!(:daily_shift) { create(:daily_shift) }
  let(:valid_attributes) { { date: "2017-06-24 03:57:15.023", week: 26, start_time: "04:00", end_time: '14:00', user_id: user.id, schedule_id: schedule.id } }
  let(:invalid_attributes) { { date: '', week: '' } }
  let(:invalid_times) { { date: "2017-06-24 03:57:15.023", week: 26, start_time: "14:00", end_time: '04:00', user_id: user.id, schedule_id: schedule.id } }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: daily_shift.to_param }
      expect(response).to be_successful
    end

    it "returns not found for invalid id" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DailyShift" do
        expect {
          post :create, params: { daily_shift: valid_attributes }
        }.to change(DailyShift, :count).by(1)
      end

      it "renders a JSON response with the new daily_shift" do
        post :create, params: { daily_shift: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new daily_shift" do
        post :create, params: { daily_shift: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      it "end_time before start_time for the new daily_shift" do
        post :create, params: { daily_shift: invalid_times }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('errors')
        expect(parsed_response['errors']).to include(/a|must be before end time/)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { date: '2024-07-03 00:00:00.000', week: 'J' } }

      it "updates the requested daily_shift" do
        put :update, params: { id: daily_shift.to_param, daily_shift: new_attributes }
        daily_shift.reload
        expect(daily_shift.date).to eq('2024-07-03 00:00:00.000')
        expect(daily_shift.week).to eq('J')
      end

      it "renders a JSON response with the daily_shift" do
        put :update, params: { id: daily_shift.to_param, daily_shift: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the daily_shift" do
        put :update, params: { id: daily_shift.to_param, daily_shift: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested daily_shift" do
      expect {
        delete :destroy, params: { id: daily_shift.to_param }
      }.to change(DailyShift, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { id: daily_shift.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
