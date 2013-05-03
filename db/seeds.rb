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


EthnicGroup.find_or_create_by_name(:name=>"American Indian", :ethnicity_code=>"1", :order=>1)
EthnicGroup.find_or_create_by_name(:name=>"Alaskan Native", :ethnicity_code=>"1", :order=>2)
EthnicGroup.find_or_create_by_name(:name=>"Asian or Pacific Islander", :ethnicity_code=>"2", :order=>3)
EthnicGroup.find_or_create_by_name(:name=>"Black", :ethnicity_code=>"3", :order=>4)
EthnicGroup.find_or_create_by_name(:name=>"Hispanic", :ethnicity_code=>"4", :order=>5)
EthnicGroup.find_or_create_by_name(:name=>"White", :ethnicity_code=>"5", :order=>6)
EthnicGroup.find_or_create_by_name(:name=>"Don't want to say", :ethnicity_code=>"6", :order=>7)


Diet.find_or_create_by_name(:name=>"No dietary restrictions", :order=>1)
Diet.find_or_create_by_name(:name=>"Gluten-free", :order=>2)
Diet.find_or_create_by_name(:name=>"Vegetarian", :order=>3)
Diet.find_or_create_by_name(:name=>"Vegan", :order=>4)
Diet.find_or_create_by_name(:name=>"Dairy-free", :order=>5)
Diet.find_or_create_by_name(:name=>"Low sodium", :order=>6)
Diet.find_or_create_by_name(:name=>"Kosher", :order=>7)
Diet.find_or_create_by_name(:name=>"Halal", :order=>8)
Diet.find_or_create_by_name(:name=>"Organic", :order=>9)

AssociationType.find_or_create_by_name(:name=>"Sister", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Brother", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Mother", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Father", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Grandfather", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Grandmother", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Cousin", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Son", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Daughter", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Uncle", :relationship_type=>"family")
AssociationType.find_or_create_by_name(:name=>"Aunt", :relationship_type=>"family")

AssociationType.find_or_create_by_name(:name=>"Primary Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nurse", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Executive Health Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pediatrician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pharmacist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Lifestyle Coach", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nutritionist", :relationship_type=>"hcp")





