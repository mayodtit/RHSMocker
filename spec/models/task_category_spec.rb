require 'spec_helper'

describe TaskCategory do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
  it_validates 'presence of', :priority_weight

  describe '#add_expertise' do
    let(:task_category) { create :task_category }
    let(:expertise) { create :expertise, name: 'expertise' }

    context 'task_category has expertise' do
      before do
        task_category.stub(:has_expertise?).with('expertise') { true }
      end

      it 'does nothing' do
        Expertise.should_not_receive(:where)
        task_category.add_expertise 'expertise'
      end
    end

    context 'task_category doesn\'t have expertise' do
      before do
        task_category.should_not be_has_expertise('expertise')
      end

      it 'adds the expertise' do
        task_category.add_expertise 'expertise'
        task_category.should be_has_expertise('expertise')
      end
    end
  end

  describe '#has_expertise?' do
    it 'returns true if task_category has the expertise' do
      task_category = build :task_category
      task_category.stub(:expertise_names) { ['expertise'] }
      task_category.should be_has_expertise('expertise')
    end

    it 'returns false if user has the expertise' do
      task_category = build :member
      task_category.stub(:expertise_names) { ['other_expertise'] }
      task_category.should_not be_has_expertise('expertise')
    end
  end
end
