class Diet < ActiveRecord::Base
  attr_accessible :name

  def as_json options=nil
  	{
  		id:id,
  		name:name
  	}
  end
end
