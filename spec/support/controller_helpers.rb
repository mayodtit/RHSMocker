shared_examples 'action requiring authentication' do
  # TODO - make this more sensible; we should be intercepting an exception here.
  it 'requires authentication' do
    do_request
    response.should_not be_success
    json = JSON.parse(response.body)
    json['reason'].should == "Invalid auth_token"
  end
end

shared_context 'authenticate user!', :user => :authenticate! do
  before(:each) do
    controller.stub(:authentication_check)
    controller.stub(:current_user => user)
  end
end

shared_examples 'action requiring authorization' do
  it 'requires User authorization' do
    expect{ do_request }.to raise_error(CanCan::AccessDenied)
  end
end

shared_context 'authorize user!', :user => :authorize! do
  before(:each) do
    ability.can :manage, :all
  end
end

shared_examples 'action requiring authentication and authorization' do
  it_behaves_like 'action requiring authentication'

  context 'user signed-in', :user => :authenticate! do
    it_behaves_like 'action requiring authorization'
  end
end

shared_context 'authenticate and authorize user!', :user => :authenticate_and_authorize! do
  include_context 'authenticate user!'
  include_context 'authorize user!'
end

shared_examples 'success' do
  it 'returns success' do
    do_request
    response.should be_success
  end
end

shared_examples 'failure' do
  it 'returns failure' do
    do_request
    response.should_not be_success
  end
end

shared_examples 'index action' do |object|
  before(:each) do
    user.stub(object_plural_symbol(object) => [object])
  end

  include_examples 'success'

  it "returns an array of #{object.class.name} " do
    do_request
    json = JSON.parse(response.body)
    json[object_plural_string(object)].to_json.should == [object.as_json].to_json
  end
end

def object_singular_string(object)
  object.class.name.underscore
end

def object_plural_string(object)
  object_singular_string(object).pluralize
end

def object_plural_symbol(object)
  object_plural_string(object).to_sym
end
