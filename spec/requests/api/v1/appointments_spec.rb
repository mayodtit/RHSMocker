require 'spec_helper'

describe 'Appointments' do
  let!(:user) { create(:member) }
  let!(:creator) { create(:pha) }
  let!(:actor) { create(:pha) }
  let!(:session) { user.sessions.create }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  context 'existing record' do
    let!(:appointment) { create(:appointment, user: user, creator: creator) }

    describe 'GET /api/v1/users/:user_id/appointments' do
      def do_request
        get "/api/v1/users/#{user.id}/appointments", auth_token: session.auth_token
      end

      it 'indexes appointments' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:appointments].to_json).to eq([appointment].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/appointments/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/appointments/#{appointment.id}", auth_token: session.auth_token
      end

      it 'shows the appointment' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:appointment].to_json).to eq(appointment.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/appointments/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/appointments/#{appointment.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_scheduled_at) { Time.now + 1.week }

      it 'updates the appointment' do
        do_request(appointment: {scheduled_at: new_scheduled_at})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(appointment.reload.scheduled_at.to_i).to eq(new_scheduled_at.to_i)
        expect(body[:appointment].to_json).to eq(appointment.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/appointments/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/appointments/#{appointment.id}", auth_token: session.auth_token
      end

      it 'destroys the appointment' do
        do_request
        expect(response).to be_success
        expect(Appointment.find_by_id(appointment.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/appointments' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/appointments", params.merge!(auth_token: session.auth_token)
    end

    let!(:provider) { create(:member) }
    let!(:address) { create(:address) }
    let!(:phone_number) { create(:phone_number, :appointment_phone) }
    let!(:address_attributes) { attributes_for(:address) }
    let!(:phone_number_attributes) { attributes_for(:phone_number) }
    let(:appointment_attributes) { attributes_for(:appointment, user_id: user.id, provider_id: provider.id, creator_id: creator.id, address: address_attributes, phone_number: phone_number_attributes) }

    it 'creates a appointment' do
      expect{ do_request(appointment: appointment_attributes) }.to change(Appointment, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(Time.parse(body[:appointment][:scheduled_at]).to_i).to eq(appointment_attributes[:scheduled_at].to_i)
    end
  end
end
