# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create some default Users

nancy 	= User.create(firstName: "Nancy", 	lastName: "Smith", 	gender:"F", birthDate:"06/18/1950")
bob 	= User.create(firstName: "Bob", 	lastName: "Jones", 	gender:"M", birthDate:"01/10/1973")
limburg = User.create(firstName: "Paul", 	lastName: "Limburg",gender:"M",  )
shelly  = User.create(firstName: "Shelly", 	lastName: "Norman", gender:"F", imageURL: "shelly.png")
sheldon = User.create(firstName: "Sheldon",	lastName: "Sheps", 	gender:"M", imageURL: "drsheps.png")
varkey  = User.create(firstName: "Prathibha", lastName: "Varkey", gender:"F" )

#some default content
installed = Content.create(
	contentsType: 'message',
	headline: "Installed RHS",
	text:"Installed RHS")

ContentAuthor.create(user:shelly, content:installed)

welcome = Content.create( 
	contentsType: 'message',
	headline: 'Welcome message from Sandra',
	text:'<p>I''m Sandra, one of your RHS Health Advocates here to support you in your quest for a healthier, fuller, life. The more you use RHS, the smarter we will get in providing you a personalized health expierence and better care</p>'
	)
ContentAuthor.create(user:shelly, content:welcome)

bpWeather = Content.create(
	contentsType: 'article',
	headline: "Weather alert: Low Temps and your Blood Pressure.",
	text:"<p>Blood pressure generally is higher in the winter because low temperatures cause your blood vessels to narrow, which increases blood pressure because more pressure is needed to force blood through your narrowed veins and arteries.</p>"
	)
ContentAuthor.create(user:sheldon, content:bpWeather)


nancyReadInstalled = UserReading.create(read_date:Time.zone.now.iso8601, user:nancy, content:installed)
nancyReadWelcome = UserReading.create(read_date:Time.zone.now.iso8601, user:nancy, content:welcome)
nancyUnreadBPWeather = UserReading.create(user:nancy, content:bpWeather)

bobReadInstalled = UserReading.create(read_date:Time.now, user:bob, content:installed)
bobWelcome   = UserReading.create(user:bob, content:welcome)
bobBPWeather = UserReading.create(user:bob, content:bpWeather)


