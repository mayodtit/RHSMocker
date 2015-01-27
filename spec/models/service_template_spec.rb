require 'spec_helper'

describe ServiceTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
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
        owner: other_pha,
        assignor: other_pha
      }

      service = service_template.create_service! attributes
      service.should be_valid
      service.id.should be_present
    end

    context 'with #task_templates' do
      let(:task_templates) { [build_stubbed(:task_template), build_stubbed(:task_template)] }
      let(:task) { build_stubbed :task }
      let(:next_task) { build_stubbed :task }

      it 'iterates each task template and creates tasks for the service' do
        Service.stub(:create!) { service }

        service_template.should_receive(:task_templates) do
          o = Object.new
          o.should_receive(:order).with('service_ordinal DESC, created_at ASC') { task_templates }
          o
        end

        task_templates[0].should_receive(:create_task!).with(service: service, start_at: Time.now, assignor: pha) { task }
        task_templates[1].should_receive(:create_task!).with(service: service, start_at: task.due_at, assignor: pha) { task }

        service_template.create_service!(assignor: pha).should == service
      end

      it 'creates a valid service with valid tasks' do
        service_template = create :service_template
        task_template_1 = create :task_template, title: 'B', service_template: service_template, service_ordinal: 2
        task_template_0 = create :task_template, title: 'A', service_template: service_template, service_ordinal: 1

        member = create :member
        relative = create :user
        pha = create :pha
        other_pha = create :pha

        attributes = {
          member: member,
          subject: relative,
          creator: pha,
          owner: other_pha,
          assignor: other_pha
        }

        service = service_template.create_service! attributes
        service.tasks[0].title.should == task_template_0.title
        service.tasks[1].title.should == task_template_1.title
      end
    end
  end
end
