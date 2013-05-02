class Diet < ActiveRecord::Base
  attr_accessible :name, :order

  def as_json options=nil
  	{
  		id:id,
  		name:name,
  		order:order
  	}
  end
end
