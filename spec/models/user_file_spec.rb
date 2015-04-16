require 'spec_helper'

describe UserFile do
  before do
    CarrierWave::Mount::Mounter.any_instance.stub(:store!)
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :user, :file
end
