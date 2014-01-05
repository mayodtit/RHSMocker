require 'spec_helper'

describe Api::V1::ABaseController do
  describe '#render_failure' do
    controller(Api::V1::ABaseController) do
      skip_before_filter :authentication_check
      def index
        render_failure({reason:"UH OH"}, 401)
      end
    end

    it 'sets the WWW-Authenticate header for 401' do
      get :index
      response.should_not be_success
      response.status.should == 401
      JSON.parse(response.body)['reason'].should == "UH OH"
      response.headers['WWW-Authenticate'].should == %(BasicCustom realm="Better")
    end
  end

  describe '#convert_to_role' do
    controller(Api::V1::ABaseController) do
      skip_before_filter :authentication_check
      def index
        render :text => 'test'
      end
    end

    it 'is activated by default' do
      controller.should_receive(:convert_to_role)
      get :index
    end

    it 'calls search_and_replace_to_role with params' do
      params = {test: 'HI'}
      controller.stub(:params) { params }
      controller.should_receive(:search_and_replace_to_role).with(params)
      get :index
    end
  end

  describe '#search_and_replace_to_role' do
    it 'does nothing for a non-hash input' do
      controller.send(:search_and_replace_to_role, [1, 2, 3])
    end

    it 'converts top-level to_role fields' do
      role_name = 'nurse'
      role = {id: 1, name: role_name}
      Role.stub(:find_by_name).with(role_name) { role }
      params = {to_role: role_name, non_to_role: 'hello'}

      controller.send(:search_and_replace_to_role, params)

      params[:to_role].should == role
      params[:non_to_role].should == 'hello'
    end

    it 'converts nested to_role fields' do
      role_name = 'nurse'
      role = {id: 1, name: role_name}
      Role.stub(:find_by_name).with(role_name) { role }
      params = {consult: {phone_call: {to_role: role_name, non_to_role: 'hello'}}}

      controller.send(:search_and_replace_to_role, params)

      params[:consult][:phone_call][:to_role].should == role
      params[:consult][:phone_call][:non_to_role].should == 'hello'
    end

    it 'converts multiple to_role fields' do
      role_name = 'nurse'
      role = {id: 1, name: role_name}
      Role.stub(:find_by_name).with(role_name) { role }

      other_role_name = 'nurse'
      other_role = {id: 1, name: other_role_name}
      Role.stub(:find_by_name).with(other_role_name) { other_role }

      params = {consult: {to_role: other_role_name, phone_call: {to_role: role_name, non_to_role: 'hello'}}}

      controller.send(:search_and_replace_to_role, params)

      params[:consult][:to_role].should == other_role
      params[:consult][:phone_call][:to_role].should == role
      params[:consult][:phone_call][:non_to_role].should == 'hello'
    end
  end
end