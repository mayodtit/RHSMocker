require 'spec_helper'

describe Api::V1::ItemsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:item) { build_stubbed(:item, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:items) { double('items', :inbox_or_timeline => [item]) }

      before(:each) do
        user.stub(:items => items)
      end

      it_behaves_like 'success'

      it 'returns a hash of items by type' do
        do_request
        json = JSON.parse(response.body)
        json['items'].to_json.should == [item].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    let(:items) { double('items', :find => item) }

    before(:each) do
      user.stub(:items => items)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the item' do
        do_request
        json = JSON.parse(response.body)
        json['item'].to_json.should == item.as_json.to_json
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, item: attributes_for(:item)
    end

    let(:items) { double('items', :find => item) }

    before(:each) do
      user.stub(:items => items)
      item.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        item.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          item.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          item.stub(:update_attributes => false)
          item.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
