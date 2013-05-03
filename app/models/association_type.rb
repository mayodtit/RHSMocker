class AssociationType < ActiveRecord::Base
  attr_accessible :name, :relationship_type

  def as_json options=nil
  	{
  		id:id,
  		name:name,
  		relationship_type:relationship_type
  	}
  end
end
