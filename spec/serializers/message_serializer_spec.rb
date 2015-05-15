require 'spec_helper'

describe MessageSerializer do
  let(:user) { create(:member, :premium) }
  let(:consult) { user.master_consult }
  let(:message) { create(:message, consult: consult) }

  it 'renders the services attribute' do
    result = message.serializer.as_json
    expect(result.fetch(:service_id)).to be_nil
    expect(result.fetch(:services)).to eq([])
  end

  context 'with an attached Service' do
    let(:service) { create(:service, member: user) }
    let(:message) { create(:message, consult: consult, service: service) }

    it 'renders the service_id and services attributes' do
      result = message.serializer.as_json
      expect(result[:service_id]).to eq(service.id)
      expect(result[:services]).to eq(
        [
          {
            id: service.id,
            title: service.title,
            image_url: 'http://localhost/assets/logo_58.png',
            action_url: "better-test://nb?cmd=services&id=#{service.id}"
          }
        ]
      )
    end
  end
end
