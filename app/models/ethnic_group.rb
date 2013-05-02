class EthnicGroup < ActiveRecord::Base
  attr_accessible :name, :ethnicity_code, :order

  def as_json options=nil
  	{
  		id:id,
  		name:name,
  		order:order
  	}
  end
end
