require 'spec_helper'

describe NurselineRecord do
  it_has_a 'valid factory'
  it_validates 'presence of', :api_user
  it_validates 'presence of', :payload

  describe 'callbacks' do
    describe '#create_processing_job' do
      it 'queues a delayed job to process' do
        expect{ create(:nurseline_record) }.to change(Delayed::Job, :count).by(1)
      end
    end
  end
end
