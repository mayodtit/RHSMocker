require 'spec_helper'

describe ServiceTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'presence of', :version
    it_validates 'presence of', :state
    it_validates 'uniqueness of', :state, :unique_id
    it_validates 'uniqueness of', :version, :unique_id
  end

  describe '#create_service!' do
    let(:service_template) { build_stubbed :service_template, time_estimate: 60 }
    let(:service) { build_stubbed :service }

    let(:relative) { build_stubbed :user }
    let(:pha) { build_stubbed :pha }
    let(:other_pha) { build_stubbed :pha }
    let(:member) { build_stubbed :member , pha: pha}
    before do
      Timecop.freeze(Time.new(2014, 7, 28, 0, 0, 0, '-07:00'))
    end

    after do
      Timecop.return
    end

    it 'creates a service from it\'s own attributes' do
      Service.should_receive(:create!).with(hash_including(
        title: service_template.title,
        description: service_template.description,
        service_type: service_template.service_type,
        due_at: Time.new(2014, 7, 28, 6, 0, 0, '-07:00')
      )) { service }

      service_template.create_service!.should == service
    end

    it 'sets the assignor to the creator if missing' do
      creator = build_stubbed :pha

      Service.should_receive(:create!).with(hash_including(
        assignor: creator
      )) { service }

      service_template.create_service!(creator: creator).should == service
    end

    it 'uses attributes passed in first before it\'s own' do
      attributes = {
        title: service_template.title + ' B',
        description: service_template.description + ' B',
      }

      Service.should_receive(:create!).with(hash_including(
        title: attributes[:title],
        description: attributes[:description],
      )) { service }

      service_template.create_service!(attributes).should == service
    end

    it 'creates a valid service' do
      service_template = create :service_template
      member = create :member
      relative = create :user
      pha = create :pha
      other_pha = create :pha

      attributes = {
        title: service_template.title + ' B',
        description: service_template.description + ' B',
        member: member,
        subject: relative,
        creator: pha,
        owner_id: other_pha.id,
        assignor: other_pha
      }

      service = service_template.create_service! attributes
      service.should be_valid
      service.id.should be_present
    end
  end

  describe '#create_deep_copy!' do
    let(:service_template) { build_stubbed(:service_template)}

    it 'creates a deep copy of the current service template' do
      service_template.should_receive(:create_deep_copy!) { service_template }

      service_template.create_deep_copy!.should == service_template
    end
  end
end
