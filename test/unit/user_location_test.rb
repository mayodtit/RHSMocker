require 'test_helper'

class UserLocationTest < ActiveSupport::TestCase
 test "should not save without lat" do
 	@user = users(:one)
  	userLocation = UserLocation.new(user:@user, long:'10.23456')
  	assert !userLocation.save, "Saved User without lat"
  end

  test "should not save without long" do
 	@user = users(:one)
  	userLocation = UserLocation.new(user:@user, lat:'11.7894')
  	assert !userLocation.save, "Saved User without long"
  end

  test "should save with valid parameters" do
 	@user = users(:one)
  	userLocation = UserLocation.new(user:@user, long:'10.23456', lat:'11.7894')
  	!userLocation.save
  end

end
