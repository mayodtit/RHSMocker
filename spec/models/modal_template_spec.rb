require 'spec_helper'

describe ModalTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :title
  end

  describe "create_modal_template" do
    let(:modal_template) { build_stubbed :modal_template }
  end
end
