class ChangeServiceTypeInServiceType < ActiveRecord::Migration
  def change
    ServiceType.find_by_name('benefit evaluation').try(:update_attribute, :name, 'insurance review')
  end
end
