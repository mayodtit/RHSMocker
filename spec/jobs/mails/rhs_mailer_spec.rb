require 'spec_helper'
require 'mandrill_mailer/offline'
require 'stripe_mock'

describe RHSMailer, "#before_check" do
  let( :mailer ) { RHSMailer.new }

  context 'email is sent to non @getbetter.com address' do

    let( :params ) { { subject: 'Test',
                       to: { email: 'neel@getworse.com' },
                       template: 'All User Welcome Email',
    }}

    it "should send email under non-production env goes to inner mailbox address and change its subject" do
      Rails.stub(env: ActiveSupport::StringInquirer.new("development"))
      mailer.before_check(params)
      expect( params[:to][:email] ).to eq( 'test@getbetter.com' )
      expect( params[:subject] ).to eq( '[To:neel@getworse.com]Test')
    end

    it "should send mail under production env goes to its original address" do
      Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
      mailer.before_check(params)
      expect( params[:to][:email] ).to eq( 'neel@getworse.com' )
      expect( params[:subject] ).to eq( 'Test')
    end
  end

  context 'email is sent to @getbetter.com address' do

    let( :params ) { { subject: 'Test',
                       to: { email: 'neel@getbetter.com' },
                       template: 'All User Welcome Email',
    }}

    it "should send mail under develop env goes to its original address" do
      Rails.stub(env: ActiveSupport::StringInquirer.new("develop"))
      mailer.before_check(params)
      expect( params[:to][:email] ).to eq( 'neel@getbetter.com' )
      expect( params[:subject] ).to eq( 'Test')
    end

    it "should send mail under production env goes to its original address" do
      Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
      mailer.before_check(params)
      expect( params[:to][:email] ).to eq( 'neel@getbetter.com' )
      expect( params[:subject] ).to eq( 'Test')
    end
  end
end

describe RHSMailer, "#notify_user_when_first_charge_fail" do
  let(:user){create(:member, :premium)}

  before do
    StripeMock.start
    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                       card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))

    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  def do_method
    event = StripeMock.mock_webhook_event('charge.failed', {customer: user.stripe_customer_id})
    RHSMailer.notify_user_when_first_charge_fail( user ).deliver
  end

  it 'should email the user to notify their first failed payment' do
    expect{do_method}.to change{ MandrillMailer.deliveries.count }.by(1)
  end
end
