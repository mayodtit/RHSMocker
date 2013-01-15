# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create some default Users

nancy = User.create(firstName: "Nancy", lastName: "Smith", gender:"F", birthDate:"06/18/1950")
bob = User.create(firstName:  "Bob", lastName: "Jones", gender:"M", birthDate:"01/10/1973")

# Create Some Default Authors

sheldon = Author.create(name: "Sheldon G. Sheps, MD", imageURL: "drsheps.png", shortName: "Dr. Sheps")
varkey 	= Author.create(name: "Prathibha Varkey, MBBS", shortName: "Dr. Varkey")
limburg = Author.create(name: "Paul J. Limburg, M.D.", shortName: "Dr. Limburg")
shelly  = Author.create(name: "Shelly Norman", imageURL: "shelly.png", shortName: "Shelly")

#some default content
installed = Content.create(
	author: shelly,
	contentsType: 'message',
	headline: "Installed RHS"
	text:"Installed RHS")

welcome = Content.create( 
	author: shelly,
	contentsType: 'message',
	headline: 'I''m Sandra, one of your RHS Health Advocates here to support you in your quest for a healthier, fuller, life.',
	text:'<p>The more you use RHS, the smarter we will get in providing you a personalized health expierence and better care, so let''s get started.</p> 
	<p>Go ahead and click on the the "Done" button and let''s get to know each other a bit better</p>'
	)

bpWeather = Content.create(
	author: sheldon, 
	contentsType: 'article',
	headline: "It's 30 degrees outside...and it could effect your blood pressure.",
	text:"<p>Blood pressure generally is higher in the winter and lower in the summer. That's because low temperatures cause your blood vessels to narrow, which increases blood pressure because more pressure is needed to force blood through your narrowed veins and arteries.</p>
<p>In addition to cold weather, blood pressure may also be affected by a sudden change in weather patterns, such as a weather front or a storm. Your body, and blood vessels, may react to abrupt changes in humidity, atmospheric pressure, cloud cover or wind in much the same way it reacts to cold. These weather-related variations in blood pressure are more common in people age 65 and older.</p>
<p>Other seasonal causes of higher blood pressure include weight gain and decreased physical activity in winter. If you have high blood pressure already, continue to monitor your blood pressure readings as the seasons change and talk to your doctor. Your doctor may recommend changing the dose of your blood pressure medication or switching to another medication. Don't make any changes to your medications without talking to your doctor.</p>
<p>If you have questions about how weather may affect your blood pressure, ask your doctor.</p>")

nancyReadInstalled = UserReading.create(completed_date:Time.now, user:nancy, content:installed)
nancyReadWelcome = UserReading.create(completed_date:Time.now, user:nancy, content:welcome)
nancyUnreadBPWeather = UserReading.create(user:nancy, content:bpWeather)

# bobReadInstalled = UserReading.create(completed_date:Time.now, user:bob, content:installed)
# bobWelcome   = UserReading.create(user:bob, content:welcome)
# bobBPWeather = UserReading.create(user:bob, content:bpWeather)


