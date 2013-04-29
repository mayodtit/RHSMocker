class BloodPressure < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection_type
  attr_accessible :diastolic, :pulse, :systolic, :user, :collection_type_id

  validates :diastolic, :presence=>true
  validates :systolic, :presence=>true


  def mean_arterial_pressure
  	(Float(2*diastolic+systolic)/3).round
  end

  def as_json options=nil
  	{
  		diastolic:diastolic,
  		systolic:systolic,
  		pulse:pulse,
  		collection_type_id:collection_type_id
  	}
  end

end
