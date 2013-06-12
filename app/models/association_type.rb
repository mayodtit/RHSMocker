class AssociationType < ActiveRecord::Base
  attr_accessible :name, :gender, :relationship_type

  def as_json options=nil
  	{
  		id:id,
  		name:name,
      gender:gender,
  		relationship_type:relationship_type
  	}
  end
end


