require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Rpsec Doc Generator Config
RspecApiDocumentation.configure do |config|
  config.docs_dir = Rails.root.join("tmp", "docs")
  config.format = [:json]
  config.keep_source_order = false
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.alias_it_should_behave_like_to :it_validates, "it validates"
  config.alias_it_should_behave_like_to :it_has_a, "it has a"

  # this increases spec run time by ~4%, but is probably more convenient
  # than remembering which exact specs require Analytics stubbing
  config.before(:each) { stub_out_analytics_methods }
  config.before(:each) { stub_out_twilio }
  config.before(:each) { Role.find_or_create_by_name!(:pha).id }
end

def stub_out_analytics_methods
  (Analytics.methods - Object.methods).each do |m|
    Analytics.stub(m).and_return(nil)
  end
end

def stub_out_twilio
  twilio = Object.new
  account = Object.new
  calls = Object.new
  call = Object.new

  twilio.stub(:account) do
    account
  end

  account.stub(:calls) do
    calls
  end

  account.stub(:messages) do
    calls
  end

  calls.stub(:create) do
    call
  end

  calls.stub(:get) do
    call
  end

  call.stub(:sid) { 'FAKETWILIOSID' }
  call.stub(:update)

  TwilioModule.stub(:client) { twilio }
end