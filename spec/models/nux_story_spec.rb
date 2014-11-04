require 'spec_helper'

describe NuxStory do
  it_has_a 'valid factory'
  it_validates 'presence of', :html
  it_validates 'presence of', :action_button_text
  it_validates 'presence of', :unique_id
  it_validates 'uniqueness of', :unique_id
  it_validates 'allows blank uniqueness of', :ordinal

  context 'without defaults' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'inclusion of', :show_nav_signup
    it_validates 'inclusion of', :enable_webview_scrolling
  end

  describe '::splash' do
    let!(:nux_story) { create(:nux_story, unique_id: 'SPLASH') }

    it 'returns the splash story' do
      expect(described_class.splash).to eq(nux_story)
    end
  end

  describe '::sign_up' do
    let!(:nux_story) { create(:nux_story, unique_id: 'SIGN_UP') }

    it 'returns the sign up story' do
      expect(described_class.sign_up).to eq(nux_story)
    end
  end

  describe '::trial' do
    let!(:nux_story) { create(:nux_story, unique_id: 'TRIAL') }

    it 'returns the trial story' do
      expect(described_class.trial).to eq(nux_story)
    end
  end

  describe '::credit_card' do
    let!(:nux_story) { create(:nux_story, unique_id: 'CREDIT_CARD') }

    it 'returns the credit_card story' do
      expect(described_class.credit_card).to eq(nux_story)
    end
  end

  describe '::sign_up_success' do
    let!(:nux_story) { create(:nux_story, unique_id: 'SIGN_UP_SUCCESS') }

    it 'returns the credit card story' do
      expect(described_class.sign_up_success).to eq(nux_story)
    end
  end
end
