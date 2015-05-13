shared_examples 'valid factory' do |*traits|
  it 'builds a valid object' do
    model = build(described_class.name.underscore.to_sym, *traits)
    model.should be_valid
    model.save.should be_true
    model.should be_persisted
  end
end

shared_examples 'presence of' do |property, options = {}|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.should_not be_valid
    model.errors[property.to_sym].should include("can't be blank")
  end
end

shared_examples 'foreign key of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.send(:"#{property}_id=", 0xBADBEEFDEADBEEF)
    model.should_not be_valid
    model.errors[property.to_sym].should include("can't be blank")
  end
end

shared_examples 'inclusion of' do |property, accepted_values|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.should_not be_valid
    model.errors[property.to_sym].should include("is not included in the list")
  end

  if accepted_values
    accepted_values.each do |value|
      its "#{property}" do
        model = build_stubbed(described_class.name.underscore.to_sym)
        model.send(:"#{property}=", value)
        model.should be_valid
      end
    end
  end
end

shared_examples 'allows nil inclusion of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", 'BAADBEEFDEADBEEF')
    model.should_not be_valid
    model.errors[property.to_sym].should include("is not included in the list")
  end
end

shared_examples 'uniqueness of' do |property, *scopes|
  its "#{property}" do
    model = create(described_class.name.underscore.to_sym)
    duplicate = build_stubbed(described_class.name.underscore.to_sym,
                              scopes.inject({property => model.send(property)}){|h,v| h[v] = model.send(v); h})
    duplicate.should_not be_valid
    duplicate.errors[property.to_sym].should include("has already been taken")
  end
end

shared_examples 'allows blank uniqueness of' do |property, *scopes|
  its "#{property}" do
    create(described_class.name.underscore.to_sym, property => nil)
    create(described_class.name.underscore.to_sym, property => nil).should be_valid

    model = create(described_class.name.underscore.to_sym, property => 'test@gmail.com')
    duplicate = build_stubbed(described_class.name.underscore.to_sym,
                              scopes.inject({property => model.send(property)}){|h,v| h[v] = model.send(v); h})
    duplicate.should_not be_valid
    duplicate.errors[property.to_sym].should include("has already been taken")
  end
end

shared_examples 'length of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.should be_valid
    model.send(:"#{property}=", [])
    model.should_not be_valid
  end
end

shared_examples 'numericality of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.should be_valid
    model.send(:"#{property}=", 'BAADBEEF')
    model.should_not be_valid
    model.errors[property.to_sym].should include('is not a number')
  end
end

shared_examples 'integer numericality of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.should be_valid
    model.send(:"#{property}=", 1.1)
    model.should_not be_valid
    model.errors[property.to_sym].should include('must be an integer')
  end
end

# Using build_stubbed with these caused problems with PhoneCall (user is real)
shared_examples 'cannot transition from' do |transition, states|
  states.each do |state|
    it "cannot transition from #{state}" do
      model = build described_class.name.underscore.to_sym
      model.state = state

      begin
        model.send(transition)
      rescue StateMachine::InvalidTransition => e
        e.message.should =~ /State cannot transition/
      end
    end
  end
end

# Using build_stubbed with these caused problems with PhoneCall (user is real)
shared_examples 'can transition from' do |transition, states|
  states.each do |state|
    it "can transition from #{state}" do
      model = build described_class.name.underscore.to_sym
      model.state = state

      begin
        model.send(transition)
      rescue StateMachine::InvalidTransition => e
        e.message.should_not =~ /State cannot transition/
      end
    end
  end
end

shared_examples 'model with SOLR index' do
  describe 'after_commit' do
    it 'causes a reindex' do
      described_class.should_receive(:reindex).at_least(:once).and_call_original
      Sunspot.should_receive(:commit).at_least(:once).and_call_original
      create(described_class.name.underscore.to_sym)
    end

    it 'skips reindex when skip_reindex is set to true' do
      described_class.should_not_receive(:reindex)
      Sunspot.should_not_receive(:commit)
      create(described_class.name.underscore.to_sym, skip_reindex: true)
    end
  end
end

shared_examples 'phone number format of' do |property, disallow_nil, allow_blank|
  before do
    @model = build_stubbed described_class.name.underscore.to_sym
    @model.should be_valid
  end

  it 'isn\'t valid if length is less than 10' do
    @model.send :"#{property}=",'311'
    @model.should_not be_valid
  end

  it 'isn\'t valid if length is greater than 10' do
    @model.send :"#{property}=",'01234567890'
    @model.should_not be_valid
  end

  it 'isn\'t valid if its not all numbers' do
    @model.send :"#{property}=",'012345A789'
    @model.should_not be_valid
  end

  unless allow_blank
    it 'isn\'t valid if blank' do
      @model.send :"#{property}=",''
      @model.should_not be_valid
    end
  end

  unless disallow_nil
    it 'is valid if nil' do
      @model.send :"#{property}=",nil
      @model.should be_valid
    end
  end

  it 'is valid if length is equal to 10' do
    @model.send :"#{property}=",'0123456789'
    @model.should be_valid
  end

  it 'is changed before validation' do
    @model = build described_class.name.underscore.to_sym
    @model.send :"#{property}=",' (408) 391 - 3578'
    @model.save
    @model.should be_valid
    @model.send(:"#{property}").should == '4083913578'
  end
end
