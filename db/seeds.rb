# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


#some default content
unless Content.find_by_title("Installed RHS")
	installed = Content.create!(
		contentsType: 'message',
		title: "Installed RHS",
		body:"Installed RHS")
end

unless Content.find_by_title("Which hand do you hold your phone in?")
	welcome = Content.create!(
		contentsType: 'Question',
		title: 'Which hand do you hold your phone in?',
		body:'<div id="panel-1">
	<div class = "content_subtitle">
	Let us know to customize your experience.
	</div>
	<div style="float:left; width:140px;text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;move_thumb&quot; , &quot;body&quot; : {&quot;side&quot; : &quot;right&quot;} } ]\'; window.location.href = &quot;http://dontload/&quot; ; document.getElementById(&quot;panel-1&quot;).style.display = &quot;none&quot;; document.getElementById(&quot;panel-2&quot;).style.display = &quot;block&quot;;">
	<img style="display : block; margin : auto;" alt="Left" width="43" height="63" src="/assets/lefthand_sm.png"/></a>
	</div>
	<div style="margin-left:140px;text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;move_thumb&quot; , &quot;body&quot; : {&quot;side&quot; : &quot;left&quot;} } ]\'; window.location.href = &quot;http://dontload/&quot; ; document.getElementById(&quot;panel-1&quot;).style.display =&quot;none&quot;; document.getElementById(&quot;panel-2&quot;).style.display = &quot;block&quot;;">
	<img style="display : block; margin : auto;" alt="Right" width="43" height="63" src="/assets/righthand_sm.png"/></a>
	</div>      
	</div>
	<div id="panel-2" style="display:none">
	<div class="content_subtitle">
	Thank you!
	</div>
	<div class = "content_text">
	We\'ve now positioned the thumb controller to it\'s most comfortable (and healthy!) position. 
	</div>
	</div>'
		)
end
# Create some default Users
#nancy 	= User.create!(first_name: "Nancy", last_name: "Smith", 	gender:"F", birth_date:"06/18/1950", install_id: "123345")
#bob 	= User.create!(first_name: "Bob", 	last_name: "Jones", 	gender:"M", birth_date:"01/10/1973", install_id: "122233")
#limburg = User.create!(first_name: "Paul", 	last_name: "Limburg",	gender:"M", install_id: "144444")
#shelly  = User.create!(first_name: "Shelly",last_name: "Norman", 	gender:"F", install_id: "555555")


EthnicGroup.find_or_create_by_name("American Indian or Alaskan Native")
EthnicGroup.find_or_create_by_name("Asian or Pacific Islander")
EthnicGroup.find_or_create_by_name("Black")
EthnicGroup.find_or_create_by_name("Hispanic")
EthnicGroup.find_or_create_by_name("White")
EthnicGroup.find_or_create_by_name("Don't want to say")


Diet.find_or_create_by_name("Gluten-free")
Diet.find_or_create_by_name("Vegetarian")
Diet.find_or_create_by_name("Vegan")
Diet.find_or_create_by_name("Dairy-free")
Diet.find_or_create_by_name("Low sodium")
Diet.find_or_create_by_name("Kosher")
Diet.find_or_create_by_name("Halal")
Diet.find_or_create_by_name("Organic")
Diet.find_or_create_by_name("No dietary restrictions")