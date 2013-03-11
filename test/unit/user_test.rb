require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save without installId" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp')
  	assert !user.save, "Saved User without Install ID"
  end

  test "should save with installId" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234')
  	!user.save
  end

  test "should not save with short phone" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', phone:'7054')
  	assert !user.save, "Should not save with short phone number"
  end

  test "should not save with long phone" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', phone:'6507767054-1234')
  	assert !user.save, "Should not save with long phone number"
  end

  test "should save with seven-digit phone" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', phone:'7767054')
  	!user.save
  end


   test "should allow all fields" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', gender: 'M', birth_date:"06/18/1950", image_url: "shelly.png", 
  						generic_call_time:'Morning', email:"Foo@foo.com", height:'100', phone:'6507767054')
  	!user.save
  end

  test "allowed generic call times" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', generic_call_time:'Morning')
  	!user.save
  	user.generic_call_time = 'Evening'
  	!user.save
  	user.generic_call_time = 'Afternoon'
  	!user.save
  end

  test "should not allow bad generic call times" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234', generic_call_time:'foo')
  	assert !user.save, "Saved with Bad generic_call_time"
  	user.generic_call_time = 'Afternoon'
  	!user.save
  end

  test "should not return empty search terms" do
  	user = User.new(first_name:'Geoff', last_name:'Clapp', install_id: '1234')
  	!user.save
  	assert_not_nil( user.keywords, "Failed: User keywords should never be nil" ) 
  	assert !(user.keywords.empty?), "Failed: User search terms should never be empty"
  	assert_equal 4, user.keywords.count, "Failed: New User should return default set"
  end
end
