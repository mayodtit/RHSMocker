shared_examples 'valid factory' do
  it 'builds a valid object' do
    model = build(described_class.name.underscore.to_sym)
    model.should be_valid
    model.save.should be_true
    model.should be_persisted
  end
end

shared_examples 'presence of' do |property|
  it "requires a value for #{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.should_not be_valid
    model.errors[property.to_sym].should include("can't be blank")
  end
end

shared_examples 'scoped uniqueness of' do |property, scope|
  it "requires a value for #{property}" do
    model = create(described_class.name.underscore.to_sym)
    duplicate = build_stubbed(described_class.name.underscore.to_sym, property => model.send(property),
                                                                      scope => model.send(scope))
    duplicate.should_not be_valid
    duplicate.errors[property.to_sym].should include("has already been taken")
  end
end
