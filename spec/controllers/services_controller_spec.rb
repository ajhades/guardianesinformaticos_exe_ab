require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let!(:service) { create(:service) }
  let(:valid_attributes) { { name: 'John Doe', start_date: '2017-06-24 03:57:15.023', end_date: '2027-06-24 03:57:15.023', status: "1", client_id: client.id } }
  let(:invalid_attributes) { { name: '', start_date: '', end_date: '' } }
  let(:valid_date) { Date.today.to_s }
  let(:valid_week) { Date.today.cweek }

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

  describe "GET #week_selected" do
    it "returns the week range and formatted week for a given date" do
      get :week_selected, params: { date: valid_date }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('week')
      expect(parsed_response).to have_key('date')
    end

    it "returns an error if the date is invalid" do
      get :week_selected, params: { date: 'invalid_date' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('errors')
    end
  end

  describe "GET #available_weeks" do
    it "returns available weeks for the service" do
      get :available_weeks, params: { id: service.id }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_an(Array)
      expect(parsed_response.first).to include("date", "week", "label")
      parsed_response.each do |week_response|
        expect(week_response).to include(
          "date" => be_a(String),
          "week" => be_a(Integer),
          "label" => be_a(String)
        )
      end
    end

    it "returns a not found error if the service does not exist" do
      get :available_weeks, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('error')
      expect(parsed_response['error']).to eq('Service not found')
    end
  end

  describe "GET #total_used_hours_per_user" do
    it "returns total hours per user for the service" do
      get :total_used_hours_per_user, params: { id: service.id, date: valid_date, week: valid_week }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_an(Array)
      parsed_response.each do |user_data|
        expect(user_data).to include(
          "user" => a_hash_including("name" => be_a(String), "id" => be_a(Integer)),
          "hours" => be_an_instance_of(Array),
          "total" => be_a(Integer)
        )
      end
    end

    it "returns a not found error if the service does not exist" do
      get :total_used_hours_per_user, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('error')
      expect(parsed_response['error']).to eq('Service not found')
    end

    it "returns an error if the date is invalid" do
      get :total_used_hours_per_user, params: { id: service.id, date: 'invalid_date' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('errors')
    end
  end

  describe "GET #used_hours_per_user" do
    it "returns used hours per user for the service" do
      get :used_hours_per_user, params: { id: service.id, date: valid_date, week: valid_week }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_an(Array)
      parsed_response.each do |user_data|
        expect(user_data).to include(
          "users" => a_hash_including(
            "name" => be_a(String),
            "id" => be_a(Integer),
            "hours" => be_an_instance_of(Array),
            "total" => be_a(Integer)
          ),
          "available_hours" => be_an_instance_of(Array),
          "date" => be_a(String),
          "day" => be_a(Integer)
        )
      end
    end

    it "returns a not found error if the service does not exist" do
      get :used_hours_per_user, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('error')
      expect(parsed_response['error']).to eq('Service not found')
    end

    it "returns an error if the date is invalid" do
      get :used_hours_per_user, params: { id: service.id, date: 'invalid_date' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('errors')
    end
  end

  describe "GET #available_hours_per_user" do
    it "returns available hours per user for the service" do
      get :available_hours_per_user, params: { id: service.id, date: valid_date, week: valid_week }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_an(Array)
      parsed_response.each do |user_data|
        expect(user_data).to include(
          "users" => a_hash_including(
            "name" => be_a(String),
            "id" => be_a(Integer),
            "hours" => be_an_instance_of(Array),
            "total" => be_a(Integer)
          ),
          "available_hours" => be_an_instance_of(Array),
          "date" => be_a(String),
          "day" => be_a(Integer)
        )
      end
    end

    it "returns a not found error if the service does not exist" do
      get :available_hours_per_user, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('error')
      expect(parsed_response['error']).to eq('Service not found')
    end

    it "returns an error if the date is invalid" do
      get :available_hours_per_user, params: { id: service.id, date: 'invalid_date' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('errors')
    end
  end

  describe "GET #availabilities_hours" do
    it "returns available hours per user for the service" do
      get :availabilities_hours, params: { id: service.id }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_an(Array)
      parsed_response.each do |schedule_data|
        expect(schedule_data).to include(
          "hours" => be_an_instance_of(Array),
          "day" => be_a(Integer)
        )
      end
    end

    it "returns a not found error if the service does not exist" do
      get :availabilities_hours, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to have_key('error')
      expect(parsed_response['error']).to eq('Service not found')
    end
  end
end
