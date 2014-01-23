require './lib/ext/string'

describe String do
  describe '#event_actor' do
    it 'adds er to a string' do
      'claim'.event_actor.should == 'claimer'
    end

    it 'special cases assign' do
      'assign'.event_actor.should == 'assignor'
    end
  end

  describe '#event_actor_id' do
    it 'adds _id to #event_actor' do
      str = 'blah'
      str.stub(:event_actor) { 'blahster' }
      str.event_actor_id.should == 'blahster_id'
    end
  end

  describe '#event_state' do
    it 'adds ed to a string' do
      'claim'.event_state.should == 'claimed'
    end
  end

  describe '#event_timestamp' do
    it 'adds _at to #event_state' do
      str = 'blah'
      str.stub(:event_state) { 'blahhed' }
      str.event_timestamp.should == 'blahhed_at'
    end
  end
end
