shared_examples 'valid factory' do
  it 'builds a valid object' do
    model = build(described_class.name.underscore.to_sym)
    model.should be_valid
    model.save.should be_true
    model.should be_persisted
  end
end

shared_examples 'presence of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.should_not be_valid
    model.errors[property.to_sym].should include("can't be blank")
  end
end

shared_examples 'inclusion of' do |property|
  its "#{property}" do
    model = build_stubbed(described_class.name.underscore.to_sym)
    model.send(:"#{property}=", nil)
    model.should_not be_valid
    model.errors[property.to_sym].should include("is not included in the list")
  end
end

shared_examples 'uniqueness of' do |property|
  its "#{property}" do
    model = create(described_class.name.underscore.to_sym)
    duplicate = build_stubbed(described_class.name.underscore.to_sym, property => model.send(property))
    duplicate.should_not be_valid
    duplicate.errors[property.to_sym].should include("has already been taken")
  end
end

shared_examples 'scoped uniqueness of' do |property, scope|
  its "#{property} per #{scope}" do
    model = create(described_class.name.underscore.to_sym)
    duplicate = build_stubbed(described_class.name.underscore.to_sym, property => model.send(property),
                                                                      scope => model.send(scope))
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
