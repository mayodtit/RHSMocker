# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


#some default content
installed = Content.create!(
	contentsType: 'message',
	title: "Installed RHS",
	body:"Installed RHS")


welcome = Content.create!(
	contentsType: 'message',
	title: 'Welcome',
	body:'<p>I''m Sandra, one of your RHS Health Advocates here to support you in your quest for a healthier, fuller, life. The more you use RHS, the smarter we will get in providing you a personalized health expierence and better care</p>'
	)


# Create some default Users
nancy 	= User.create!(first_name: "Nancy", last_name: "Smith", 	gender:"F", birth_date:"06/18/1950", install_id: "123345")
bob 	= User.create!(first_name: "Bob", 	last_name: "Jones", 	gender:"M", birth_date:"01/10/1973", install_id: "122233")
limburg = User.create!(first_name: "Paul", 	last_name: "Limburg",	gender:"M", install_id: "144444")
shelly  = User.create!(first_name: "Shelly",last_name: "Norman", 	gender:"F", install_id: "555555")




#nancyReadInstalled = UserReading.create!(read_date:Time.zone.now.iso8601, user:nancy, content:installed)
#nancyReadWelcome = UserReading.create!(read_date:Time.zone.now.iso8601, user:nancy, content:welcome)

#bobReadInstalled = UserReading.create!(read_date:Time.now, user:bob, content:installed)
#bobWelcome   = UserReading.create!(user:bob, content:welcome)


