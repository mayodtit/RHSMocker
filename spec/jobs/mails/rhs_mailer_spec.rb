require 'spec_helper'

describe RHSMailer, "#before_check" do
  let( :mailer ) { RHSMailer.new }

  context 'email is sent to non @getbetter.com address' do

    let( :params ) { { subject: 'Test',
                       to: { email: 'neel@getworse.com' },
                       template: 'All User Welcome Email',
    }}

    it "should send email under non-production/demo env goes to inner mailbox address and change its subject" do
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

    it "should send mail under demo env goes to its original address" do
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
