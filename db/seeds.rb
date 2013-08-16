# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


#some default content
unless Content.find_by_title("Welcome to Better!")
	installed = Content.create!(
		content_type: 'Content',
		title: "Welcome to Better!",
		body:"Thank you for installing Better!")
end

unless Content.find_by_title("Which hand do you hold your phone in?")
	welcome = Content.create!(
		content_type: 'Question',
		title: 'Which hand do you hold your phone in?',
		body:'<div id="panel-1">
	<div class = "content_subtitle">
	Try answering questions in Better:
	</div>
	<div style="float:left; width:140px; text-align:center; padding-top:5px;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;move_thumb&quot; , &quot;body&quot; : {&quot;side&quot; : &quot;right&quot;} }, {&quot;type&quot; : &quot;set_available_user_actions&quot; , &quot;body&quot; : { &quot;actions&quot; : [&quot;dismiss&quot; ] } } ] \'; window.location.href = &quot;http://dontload/&quot; ; document.getElementById(&quot;panel-1&quot;).style.display = &quot;none&quot; ; document.getElementById(&quot;panel-2&quot;).style.display = &quot;block&quot;;">
	<img style="display : block; margin : auto; padding-top:5px;" alt="Left" width="54" height="60" src="/assets/lefthand_sm.png"/></a>
	</div>
	<div style="margin-left:140px; text-align:center; padding-top:5px;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;move_thumb&quot; , &quot;body&quot; : {&quot;side&quot; : &quot;left&quot;} }, {&quot;type&quot; : &quot;set_available_user_actions&quot; , &quot;body&quot; : { &quot;actions&quot; : [&quot;dismiss&quot; ] } } ] \'; window.location.href = &quot;http://dontload/&quot; ; document.getElementById(&quot;panel-1&quot;).style.display = &quot;none&quot; ; document.getElementById(&quot;panel-2&quot;).style.display = &quot;block&quot;;">
	<img style="display : block; margin : auto; padding-top:5px;" alt="Right" width="54" height="60" src="/assets/righthand_sm.png"/></a>
	</div>
	</div>
	<div id="panel-2" style="display:none">
	<script type="text/javascript">
   		document.actionJSON = "\'[{&quot;type&quot; : &quot;set_available_user_actions&quot; , &quot;body&quot; : { &quot;actions&quot; : [&quot;dismiss&quot; ] } } ]\';  window.location.href = &quot;http://dontload/&quot;""
	</script>
	<div class="content_subtitle">
	Thank you!
	</div>
	<div class = "content_text">
	We\'ve now positioned the thumb controller to it\'s most comfortable (and healthy!) position.
	</div>
	</div>'
	)
end


unless Content.find_by_title("What is your gender?")
	gender = Content.create!(
		content_type: 'Question',
		title: 'What is your gender?',
		body:'<div id="panel-1">
	<div class = "content_subtitle">
	Gender helps us personalize your Better experience.
	</div>
	<div style="float:left; width:140px;text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;set_gender&quot; , &quot;body&quot; : {&quot;gender&quot; : &quot;male&quot;} }, {&quot;type&quot; : &quot;save_item&quot; } ]\'; window.location.href = &quot;http://dontload/&quot; ; ">
	<img style="display : block; margin : auto;" alt="Male" width="24" height="62" src="/assets/male.png"/></a>
	</div>
	<div style="margin-left:140px; text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;set_gender&quot; , &quot;body&quot; : {&quot;gender&quot; : &quot;female&quot;}},{&quot;type&quot; : &quot;save_item&quot; }] \'; window.location.href = &quot;http://dontload/&quot; ; ">
	<img style="display : block; margin : auto;" alt="Female" width="24" height="62" src="/assets/female.png"/></a>
	</div>
	</div>
	<div id="panel-2" style="display:none">
	<div class="content_subtitle">
	Thank you!
	</div>
	<div class = "content_text">
	Your <a href="#" onclick="document.actionJSON = \'[{ &quot;type&quot; : &quot;goto_profile&quot;} ]\'; window.location.href = &quot;http://dontload/&quot;">
	health profile</a> has been updated with your gender. This will help us personalize your Better experience.
	</div>
	</div>'
		)
end

Content.upsert_attributes({:title => "Do you have allergies?",
                           :content_type => 'Question'},
                          {
                            :body => <<-EOF
<div id="panel-1">
	<div class = "content_subtitle">
	Understanding your allergies will help us provide you great care.
	</div>
	<div style="float:left; width:140px;text-align:center;">

	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;goto_allergies&quot; } , {&quot;type&quot; : &quot;save_item&quot; } ]\'; window.location.href = &quot;http://dontload/&quot; ; ">
	<img style="display : block; margin : auto;" alt="Have Allergies" width="53" height="53" src="/assets/allergy_icon.png"/></a>
	</div>
	<div style="margin-left:140px; text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;add_allergy&quot; , &quot;body&quot; : {&quot;allergy_id&quot; : &quot;50&quot;} } , {&quot;type&quot; : &quot;save_item&quot; } ] \'; window.location.href = &quot;http://dontload/&quot; ;">
	<img style="display : block; margin : auto;" alt="No Allergies" width="53" height="53" src="/assets/allergy_none_icon.png"/></a>
	</div>
	</div>
	<div id="panel-2" style="display:none">
	<div class="content_subtitle">
	Thank you!
	</div>
	<div class = "content_text">
	Your <a href="#" onclick="document.actionJSON = \'[ { &quot;type&quot; : &quot;goto_profile&quot;} ]\';  window.location.href = &quot;http://dontload/&quot;">
	health profile</a> has been updated with your allergy information. This will help us personalize your Better experience.
	</div>
	</div>
                                     EOF
                          })


Content.upsert_attributes({:title => 'Which of these do you eat?',
                           :content_type => 'Question'},
                          {
                            :body => <<-EOF
<div id="panel-1">
  <div class="content_text">
    <div style="position: absolute; left: 25px; top: 65px;">
      <a href="#" onclick="toggleElement('vegetables')"><img class="vegetables" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/vegetables_unselect.png"/></a>
      <a href="#" onclick="toggleElement('vegetables')"><img class="vegetables" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/vegetables_select.png"/></a>
    </div>
    <div style="position: absolute; left: 115px; top: 65px;">
      <a href="#" onclick="toggleElement('meat')"><img class="meat" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/meat_unselect.png"/></a>
      <a href="#" onclick="toggleElement('meat')"><img class="meat" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/meat_select.png"/></a>
    </div>
    <div style="position: absolute; left: 205px; top: 65px;">
      <a href="#" onclick="toggleElement('fish')"><img class="fish" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/fish_unselect.png"/></a>
      <a href="#" onclick="toggleElement('fish')"><img class="fish" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/fish_select.png"/></a>
    </div>
    <div style="position: absolute; left: 25px; top: 125px">
      <a href="#" onclick="toggleElement('bread')"><img class="bread" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/bread_unselect.png"/></a>
      <a href="#" onclick="toggleElement('bread')"><img class="bread" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/bread_select.png"/></a>
    </div>
    <div style="position: absolute; left: 115px; top: 125px">
      <a href="#" onclick="toggleElement('dairy')"><img class="dairy" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/dairy_unselect.png"/></a>
      <a href="#" onclick="toggleElement('dairy')"><img class="dairy" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/dairy_select.png"/></a>
    </div>
    <div style="position: absolute; left: 205px; top: 125px">
      <a href="#" onclick="toggleElement('eggs')"><img class="eggs" style="display: block; margin: auto; padding-top: 5px; width:70; height:55;" alt="Left" src="/assets/eggs_unselect.png"/></a>
      <a href="#" onclick="toggleElement('eggs')"><img class="eggs" style="display: block; margin: auto; padding-top: 5px; width:70; height:55; display: none;" alt="Left" src="/assets/eggs_select.png"/></a>
    </div>
  </div>
</div>

<script type="text/javascript">
document.actionJSON = JSON.stringify([{type: "set_available_user_actions", body: {actions: ["save"]}}]);

function toggleElement(type) {
  $('.' + type).toggle();
};
</script>
                                    EOF
                          })

Content.upsert_attributes({:title => 'Enter your blood pressure',
                           :content_type => 'Question'},
                          {
                             :body => <<-EOF
<div style="color:#999999;margin-left:35px;font-size:16px;font-weight:bold;float:left;">SYS</div><div style="color:#999999;margin-left:70px;font-size:16px;font-weight:bold;float:left;">DIA</div><div style="color:#999999;margin-left:55px;font-size:16px;font-weight:bold;float:left;">PULSE</div><br />
<form width="100%" align="center" action="http://dontload" method="post">
  <input type="text" pattern="[0-9]*" name="systolic" id="systolic" style="width:60px;height:47px;" size="3" maxlength="3" onblur="submitBloodPressure(this)" /><img src="/assets/bp_slash.png" style="width:15px;height:47px;margin-bottom:10px;margin-left:4px;"/>
  <input type="text" pattern="[0-9]*" name="diastolic" id="diastolic" style="width:60px;height:47px;" size="3" maxlength="3" onblur="submitBloodPressure(this)" />
  <input type="text" pattern="[0-9]*" name="pulse" id="pulse" style="margin-left:10px;width:60px;height:47px;" size="3" maxlength="3" onblur="submitBloodPressure(this)" />
</form>

<script>
  function quoteForJSONIfString(object) {
   if(Object.prototype.toString.call(object) === '[object String]') {
    return '\"' + object + '\"';
   } else {
    return object;
   }
  }
  function JSONWithTypeAndBody(type, body) {
   if(Object.prototype.toString.call(body) === '[object Object]') {
    var bodyString = '{';
    for (var i in body) {
     bodyString += quoteForJSONIfString(i) + ':' + quoteForJSONIfString(body[i]) + ',';
    }
    bodyString = bodyString.replace(/,+$/, \"\") + '}';
    body = bodyString;
   }
   return '{\"type\":\"'+type+'\",\"body\":'+body+'}';
  }
  
  function submitBloodPressure(e) {
  var eValue = e.value*1;
  if(isNaN(eValue)) e.value = 0;
  var systolicInput = document.getElementById('systolic');
  var diastolicInput = document.getElementById('diastolic');
  var pulseInput = document.getElementById('pulse');
  
  if(systolicInput.value != ''  && diastolicInput.value != '' && pulseInput.value != '') {
 
  var bloodpressureDictionary = {'systolic' : systolicInput.value*1,'diastolic' : diastolicInput.value*1, 'pulse' : pulseInput.value*1};
  var actionJSON = '[' + JSONWithTypeAndBody('available_user_actions','[\"dismiss\"]');
  actionJSON += ',' + JSONWithTypeAndBody('add_blood_pressure',bloodpressureDictionary) + ']';
  console.log(actionJSON);
  document.actionJSON = actionJSON;
  window.location.href = 'http://dontload';
  }
  }
</script>
                                      EOF
                          })

Content.upsert_attributes({:title => 'Enter your weight',
                           :content_type => 'Question'},
                          {
                            :body => <<-EOF
<div align="center">
<img src="/assets/weight_meter.png" style="width:64px; height:29px;"/>
<p style="margin-top:2px;margin-bottom:2px;color:#999999;font-size:16px;font-weight:bold;f">LBS</p>
<form width="100%" align="center" action="http://dontload" method="post" >
  <input type="text" pattern="[0-9]*" name="weight" id="weight" style="width:171px;height:48px;" size="3" maxlength="3" onblur="submitWeight(this)" />
</form>
</div>

<script>
  function quoteForJSONIfString(object) {
  if(Object.prototype.toString.call(object) === '[object String]') {
  return '\"' + object + '\"';
  } else {
  return object;
  }
  }
  function JSONWithTypeAndBody(type, body) {
  if(Object.prototype.toString.call(body) === '[object Object]') {
  var bodyString = '{';
  for (var i in body) {
  bodyString += quoteForJSONIfString(i) + ':' + quoteForJSONIfString(body[i]);
  }
  bodyString += '}';
  body = bodyString;
  }
  return '{\"type\":\"'+type+'\",\"body\":'+body+'}';
  }

  function submitWeight(weightInput) {
  var weight = weightInput.value * 1;
  if(isNaN(weight)) weightInput.value = weight = 0;

  if(weight < 5) {
  weightInput.value = 5;
  weight = 5;
  }

  if(weight > 750) {
  weightInput.value = 750;
  weight = 750;
  }

  weight *= 0.453592;

  var weightDictionary = {'weight' : weight};
  var actionJSON = '[' + JSONWithTypeAndBody('available_user_actions','[\"dismiss\"]');
  actionJSON += ',' + JSONWithTypeAndBody('add_weight',weightDictionary) + ']';
  document.actionJSON = actionJSON;
  console.log(actionJSON);
  window.location.href = 'http://dontload';
  }
</script>
                                     EOF
                          })

# Create some default Members
#nancy 	= Member.create!(first_name: "Nancy", last_name: "Smith", 	gender:"F", birth_date:"06/18/1950", install_id: "123345")
#bob 	= Member.create!(first_name: "Bob", 	last_name: "Jones", 	gender:"M", birth_date:"01/10/1973", install_id: "122233")
#limburg = Member.create!(first_name: "Paul", 	last_name: "Limburg",	gender:"M", install_id: "144444")
#shelly  = Member.create!(first_name: "Shelly",last_name: "Norman", 	gender:"F", install_id: "555555")

hcp = Role.find_or_create_by_name(:name => 'hcp')
Role.find_or_create_by_name(:name => 'admin')

[
  {:install_id => 'test-1', :first_name => 'Jack', :last_name => 'Kevorkian', :gender => 'M'},
  {:install_id => 'test-2', :first_name => 'Emmett', :last_name => 'Brown', :gender => 'M'},
  {:install_id => 'test-3', :first_name => 'Hannibal', :last_name => 'Lecter', :gender => 'M'}
].each do |u|
  user = Member.find_or_create_by_install_id(u)
  user.roles << hcp unless user.hcp?
end

EthnicGroup.find_or_create_by_name(:name=>"American Indian", :ethnicity_code=>"1", :ordinal=>1)
EthnicGroup.find_or_create_by_name(:name=>"Alaskan Native", :ethnicity_code=>"1", :ordinal=>2)
EthnicGroup.find_or_create_by_name(:name=>"Asian or Pacific Islander", :ethnicity_code=>"2", :ordinal=>3)
EthnicGroup.find_or_create_by_name(:name=>"Black", :ethnicity_code=>"3", :ordinal=>4)
EthnicGroup.find_or_create_by_name(:name=>"Hispanic", :ethnicity_code=>"4", :ordinal=>5)
EthnicGroup.find_or_create_by_name(:name=>"White", :ethnicity_code=>"5", :ordinal=>6)
EthnicGroup.find_or_create_by_name(:name=>"Don't want to say", :ethnicity_code=>"6", :ordinal=>7)


Diet.find_or_create_by_name(:name=>"No dietary restrictions", :ordinal=>1)
Diet.find_or_create_by_name(:name=>"Gluten-free", :ordinal=>2)
Diet.find_or_create_by_name(:name=>"Vegetarian", :ordinal=>3)
Diet.find_or_create_by_name(:name=>"Vegan", :ordinal=>4)
Diet.find_or_create_by_name(:name=>"Dairy-free", :ordinal=>5)
Diet.find_or_create_by_name(:name=>"Low sodium", :ordinal=>6)
Diet.find_or_create_by_name(:name=>"Kosher", :ordinal=>7)
Diet.find_or_create_by_name(:name=>"Halal", :ordinal=>8)
Diet.find_or_create_by_name(:name=>"Organic", :ordinal=>9)

sister=AssociationType.find_or_create_by_name(:name=>"Sister", :gender=>"female", :relationship_type=>"family")
sister.update_attribute :gender, "female"

brother = AssociationType.find_or_create_by_name(:name=>"Brother", :gender=>"male", :relationship_type=>"family")
brother.update_attribute :gender, "male"

mother = AssociationType.find_or_create_by_name(:name=>"Mother", :gender=>"female", :relationship_type=>"family")
mother.update_attribute :gender, "female"

father = AssociationType.find_or_create_by_name(:name=>"Father", :gender=>"male", :relationship_type=>"family")
father.update_attribute :gender, "male"

grandfather = AssociationType.find_or_create_by_name(:name=>"Grandfather", :gender=>"male", :relationship_type=>"family")
grandfather.update_attribute :gender, "male"

grandmother = AssociationType.find_or_create_by_name(:name=>"Grandmother", :gender=>"female", :relationship_type=>"family")
grandmother.update_attribute :gender, "female"

cousin = AssociationType.find_or_create_by_name(:name=>"Cousin", :gender=>nil, :relationship_type=>"family")
son = AssociationType.find_or_create_by_name(:name=>"Son", :gender=>"male", :relationship_type=>"family")
son.update_attribute :gender, "male"

daughter = AssociationType.find_or_create_by_name(:name=>"Daughter", :gender=>"female", :relationship_type=>"family")
daughter.update_attribute :gender, "female"

uncle = AssociationType.find_or_create_by_name(:name=>"Uncle", :gender=>"male", :relationship_type=>"family")
uncle.update_attribute :gender, "male"

aunt = AssociationType.find_or_create_by_name(:name=>"Aunt", :gender=>"female", :relationship_type=>"family")
aunt.update_attribute :gender, "female"

wife=AssociationType.find_or_create_by_name(:name=>"Wife", :gender=>"female", :relationship_type=>"family")
wife.update_attribute :gender, "female"

husband = AssociationType.find_or_create_by_name(:name=>"Husband", :gender=>"male", :relationship_type=>"family")
husband.update_attribute :gender, "male"


AssociationType.find_or_create_by_name(:name=>"Primary Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nurse", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Executive Health Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pediatrician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pharmacist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Lifestyle Coach", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nutritionist", :relationship_type=>"hcp")

#Allergy.create!(:name=>"",:snomed_name=>"",:snomed_code=>"",:food_allergen=>"",:environment_allergen=>"",:medication_allergen=>"")
Allergy.find_or_create_by_name(:name=>"Alcohol",:snomed_name=>"Alcohol products allergy",:snomed_code=>"294420000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Almond Oil",:snomed_name=>"Allergy to almond oil",:snomed_code=>"418606003",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Aluminum",:snomed_name=>"Allergy to aluminum",:snomed_code=>"402306009",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Ant Sting",:snomed_name=>"Ant Sting",:snomed_code=>"403141006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Aspartame",:snomed_name=>"Allergy to aspartame",:snomed_code=>"419180003",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Bee Sting",:snomed_name=>"Allergy to bee venom",:snomed_code=>"424213003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Boric Acid",:snomed_name=>"Boric acid allergy",:snomed_code=>"294434000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Caffeine",:snomed_name=>"Caffeine allergy",:snomed_code=>"418344001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Carrot",:snomed_name=>"Carrot allergy",:snomed_code=>"420080006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Castor Oil",:snomed_name=>"Castor Oil allergy",:snomed_code=>"294318004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cat Dander",:snomed_name=>"Cat Dander allergy",:snomed_code=>"232346004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cheese",:snomed_name=>"Cheese allergy",:snomed_code=>"300914000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Chemical",:snomed_name=>"Chemical allergy",:snomed_code=>"419199007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Chocolate",:snomed_name=>"Chocolate allergy",:snomed_code=>"300912001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cinnamon",:snomed_name=>"Cinnamon allergy",:snomed_code=>"418397007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Coal Tar",:snomed_name=>"Coal Tar allergy",:snomed_code=>"294169006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Coconut oil",:snomed_name=>"Coconut oil allergy",:snomed_code=>"419814004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Corn",:snomed_name=>"Corn allergy",:snomed_code=>"419573007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cosmetic",:snomed_name=>"Cosmetic allergy",:snomed_code=>"417982003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cow's milk",:snomed_name=>"Cow's milk allergy",:snomed_code=>"15911003",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Dairy",:snomed_name=>"Dairy product allergy",:snomed_code=>"425525006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Dander",:snomed_name=>"Dander allergy",:snomed_code=>"232347008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Dog Dander",:snomed_name=>"Dog Dander allergy",:snomed_code=>"419271008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Dust",:snomed_name=>"Dust allergy",:snomed_code=>"390952000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Dye",:snomed_name=>"Dye allergy",:snomed_code=>"418545001",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Egg",:snomed_name=>"Egg allergy",:snomed_code=>"91930004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Feather",:snomed_name=>"Feather allergy",:snomed_code=>"232348003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Food",:snomed_name=>"Food allergy",:snomed_code=>"414285001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Food Preservative",:snomed_name=>"Food preservative allergy",:snomed_code=>"419421008",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Fruit",:snomed_name=>"Fruit",:snomed_code=>"91932007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Gastrointestinal Food Allergy",:snomed_name=>"Gastrointestinal food allergy",:snomed_code=>"414314005",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Gauze",:snomed_name=>"Gauze allergy",:snomed_code=>"418968001",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Gelatin",:snomed_name=>"Gelatin allergy",:snomed_code=>"294847001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Glycine",:snomed_name=>"Glycine allergy",:snomed_code=>"294298002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Gold",:snomed_name=>"Gold allergy",:snomed_code=>"294238000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Grass Pollen",:snomed_name=>"Grass pollen allergy",:snomed_code=>"418689008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Guar Gum",:snomed_name=>"Guar gum allergy",:snomed_code=>"294741005",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Gluten",:snomed_name=>"Gluten allergy",:snomed_code=>"BAADBEEF",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Hornet Sting",:snomed_name=>"Hornet sting",:snomed_code=>"307427009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Horse Dander",:snomed_name=>"Horse dander allergy",:snomed_code=>"419063004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"House Dust",:snomed_name=>"House dust allergy",:snomed_code=>"232349006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Latex",:snomed_name=>"Latex allergy",:snomed_code=>"300916003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Legumes",:snomed_name=>"Legumes allergy",:snomed_code=>"409136006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Lithium",:snomed_name=>"Lithium allergy",:snomed_code=>"293817009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Lubricant",:snomed_name=>"Lubricant allergy",:snomed_code=>"294321002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Metal",:snomed_name=>"Metal allergy",:snomed_code=>"300915004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Multiple Environmental",:snomed_name=>"Multiple environmental allergies",:snomed_code=>"444026000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Mushroom",:snomed_name=>"Mushroom allergy",:snomed_code=>"447961002",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Nickel",:snomed_name=>"Nickel allergy",:snomed_code=>"419788000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"No Known Allergies",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Nut",:snomed_name=>"Nut allergy",:snomed_code=>"91934008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Oat",:snomed_name=>"Oats allergy",:snomed_code=>"419342009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Olive oil",:snomed_name=>"Olive oil allergy",:snomed_code=>"294316000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Other Allergy (Not Listed)",:snomed_name=>"Other Allergy (Not Listed)",:snomed_code=>"106190000",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Paraffin",:snomed_name=>"Paraffin allergy",:snomed_code=>"294324005",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Peanut",:snomed_name=>"Peanut allergy",:snomed_code=>"91935009",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Perfume",:snomed_name=>"Perfume allergy",:snomed_code=>"300908007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pesticide",:snomed_name=>"Pesticide allergy",:snomed_code=>"294619002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Photosensitization",:snomed_name=>"Photosensitization due to sun",:snomed_code=>"258155009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Plant",:snomed_name=>"Plant allergy",:snomed_code=>"402594000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pollen",:snomed_name=>"Pollen allergy",:snomed_code=>"300910009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pollen-food",:snomed_name=>"Pollen-food allergy",:snomed_code=>"432807008",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pork",:snomed_name=>"Pork allergy",:snomed_code=>"417918006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Potato",:snomed_name=>"Potato allergy",:snomed_code=>"419619007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Red Meat",:snomed_name=>"Red meat allergy",:snomed_code=>"418815008",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Rubber",:snomed_name=>"Rubber allergy",:snomed_code=>"419412007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Rye",:snomed_name=>"Rye allergy",:snomed_code=>"418184004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Scorpion sting",:snomed_name=>"Scorpion sting",:snomed_code=>"42292100",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seafood",:snomed_name=>"Seafood allergy",:snomed_code=>"91937001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seasonal",:snomed_name=>"Seasonal allergy",:snomed_code=>"444316004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seed",:snomed_name=>"Seed allergy",:snomed_code=>"419101002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Shellfish",:snomed_name=>"Shellfish allergy",:snomed_code=>"300913006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Shrimp",:snomed_name=>"Shrimp allergy",:snomed_code=>"419972009",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Silicone",:snomed_name=>"Silicone allergy",:snomed_code=>"294328008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Spider bite",:snomed_name=>"Spider bite allergy",:snomed_code=>"427487000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Sulfur",:snomed_name=>"Sulfur allergy",:snomed_code=>"294179008",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tape",:snomed_name=>"Tape allergy",:snomed_code=>"405649006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tomato",:snomed_name=>"Tomato allergy",:snomed_code=>"418779002",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tryptophan",:snomed_name=>"Tryptophan allergy",:snomed_code=>"293842000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Vitamin A",:snomed_name=>"Vitamin A allergy",:snomed_code=>"294923007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Vitamin D",:snomed_name=>"Vitamin D allergy",:snomed_code=>"294924001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Vitamin K",:snomed_name=>"Vitamin K allergy",:snomed_code=>"294925000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Walnut",:snomed_name=>"Walnut allergy",:snomed_code=>"91940001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wasp sting",:snomed_name=>"Wasp sting allergy",:snomed_code=>"423058007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wheat",:snomed_name=>"Wheat allergy",:snomed_code=>"402595004",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wool",:snomed_name=>"Wool allergy",:snomed_code=>"425605001",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Zinc",:snomed_name=>"Zinc allergy",:snomed_code=>"294950002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")


#Disease.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Disease.find_or_create_by_name(:name=>"Hypertensive disorder",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"38341003")
Disease.find_or_create_by_name(:name=>"Hyperlipidemia",:snomed_name=>"Hyperlipidemia",:snomed_code=>"55822004")
Disease.find_or_create_by_name(:name=>"Depressive Disorder",:snomed_name=>"Depressive disorder",:snomed_code=>"35489007")
Disease.find_or_create_by_name(:name=>"Gastroesophageal reflux",:snomed_name=>"Gastroesophageal reflux",:snomed_code=>"235595009")
Disease.find_or_create_by_name(:name=>"Type 2 Diabetes",:snomed_name=>"Diabetes mellitus type 2",:snomed_code=>"44054006")
Disease.find_or_create_by_name(:name=>"Asthma",:snomed_name=>"Asthma",:snomed_code=>"195967001")
Disease.find_or_create_by_name(:name=>"Essential Hypertension",:snomed_name=>"Essential hypertension",:snomed_code=>"59621000")
Disease.find_or_create_by_name(:name=>"Obesity",:snomed_name=>"Obesity",:snomed_code=>"414916001")
Disease.find_or_create_by_name(:name=>"Diabetes",:snomed_name=>"Diabetes mellitus",:snomed_code=>"73211009")
Disease.find_or_create_by_name(:name=>"Allergic rhinitis",:snomed_name=>"Allergic rhinitis",:snomed_code=>"61582004")
Disease.find_or_create_by_name(:name=>"Hypothyroidism",:snomed_name=>"Hypothyroidism",:snomed_code=>"40930008")
Disease.find_or_create_by_name(:name=>"Upper respiratory infection",:snomed_name=>"Upper respiratory infection",:snomed_code=>"54150009")
Disease.find_or_create_by_name(:name=>"Coronary arteriosclerosis",:snomed_name=>"Coronary arteriosclerosis",:snomed_code=>"53741008")
Disease.find_or_create_by_name(:name=>"Hypercholesterolemia",:snomed_name=>"Hypercholesterolemia",:snomed_code=>"13644009")
Disease.find_or_create_by_name(:name=>"Urinary tract infectious disease",:snomed_name=>"Urinary tract infectious disease",:snomed_code=>"68566005")
Disease.find_or_create_by_name(:name=>"Anemia",:snomed_name=>"Anemia",:snomed_code=>"271737000")


#Treatment.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Treatment::Tests.find_or_create_by_name(:name=>"Adult health examination", :snomed_name=>"Adult health examination",:snomed_code=>"268565007")
Treatment::Tests.find_or_create_by_name(:name=>"Well child visit", :snomed_name=>"Well child visit",:snomed_code=>"410620009")
Treatment::Tests.find_or_create_by_name(:name=>"Gynecologic examination", :snomed_name=>"Gynecologic examination",:snomed_code=>"83607001")
Treatment::Surgery.find_or_create_by_name(:name=>"Hysterectomy", :snomed_name=>"Hysterectomy",:snomed_code=>"236886002")
Treatment::Medicine.find_or_create_by_name(:name=>"Influenza vaccination", :snomed_name=>"Influenza vaccination",:snomed_code=>"86198006")
Treatment::Surgery.find_or_create_by_name(:name=>"Arthroscopy of knee", :snomed_name=>"Arthroscopy of knee joint",:snomed_code=>"309431009")
Treatment::Medicine.find_or_create_by_name(:name=>"Anticoagulant Therapy", :snomed_name=>"Anticoagulant Therapy",:snomed_code=>"182764009")
Treatment::Surgery.find_or_create_by_name(:name=>"Cholecystectomy", :snomed_name=>"Cholecystectomy",:snomed_code=>"38102005")
Treatment::Surgery.find_or_create_by_name(:name=>"Appendectomy",:snomed_name=>"Appendectomy",:snomed_code=>"80146002")
Treatment::Medicine.find_or_create_by_name(:name => "Captopril", :snomed_name => "Captopril", :snomed_code => 'DEADBEEF')


#FactorGroup
pain_is_factor_group 		= FactorGroup.find_or_create_by_name(:name=>"Pain is")
caused_by_factor_group 		= FactorGroup.find_or_create_by_name(:name=>"Caused by")
problem_is_factor_group 	= FactorGroup.find_or_create_by_name(:name=>"Problem is")
accompanied_by_factor_group = FactorGroup.find_or_create_by_name(:name=>"Accompanied by")
relieved_by_factor_group 	= FactorGroup.find_or_create_by_name(:name=>"Relieved by")
important_factor_group 		= FactorGroup.find_or_create_by_name(:name=>"Important")
triggered_by_factor_group 	= FactorGroup.find_or_create_by_name(:name=>"Triggered by")
pain_located_factor_group 	= FactorGroup.find_or_create_by_name(:name=>"Pain located")

#Factor
intense_factor = Factor.find_or_create_by_name(:name=>"Intense")
drinking_alcohol_factor = Factor.find_or_create_by_name(:name=>"Drinking alcohol")
dry_factor = Factor.find_or_create_by_name(:name=>"Dry")
recently_factor = Factor.find_or_create_by_name(:name=>"recently")
acute_began_suddenly_factor = Factor.find_or_create_by_name(:name=>"Acute, began suddenly")
burning_factor = Factor.find_or_create_by_name(:name=>"Burning")
chronic_ongoing_factor = Factor.find_or_create_by_name(:name=>"Chronic, ongoing")
crampy_factor = Factor.find_or_create_by_name(:name=>"Crampy")
dull_factor = Factor.find_or_create_by_name(:name=>"Dull")
gnawing_factor = Factor.find_or_create_by_name(:name=>"Gnawing")
intense_factor = Factor.find_or_create_by_name(:name=>"Intense")
intermittent_episodic_factor = Factor.find_or_create_by_name(:name=>"Intermittent, Episodic")
worsens_over_time_factor = Factor.find_or_create_by_name(:name=>"Worsens over time")
sharp_factor = Factor.find_or_create_by_name(:name=>"Sharp")
steady_factor = Factor.find_or_create_by_name(:name=>"Steady")
coughing_or_jarring_movements_factor = Factor.find_or_create_by_name(:name=>"Coughing or Jarring Movements")
drinking_alcohol_factor = Factor.find_or_create_by_name(:name=>"Drinking Alchohol")
eating_certain_foods_factor = Factor.find_or_create_by_name(:name=>"Eating certain foods")
stress_factor = Factor.find_or_create_by_name(:name=>"Stress")
antacids_factor = Factor.find_or_create_by_name(:name=>"Antacids")
avoiding_certain_foods_factor = Factor.find_or_create_by_name(:name=>"Avoiding certain foods")
changing_position_factor = Factor.find_or_create_by_name(:name=>"Changing position")
drinking_more_water_factor = Factor.find_or_create_by_name(:name=>"Drinking more water")
eating_more_fibre_factor = Factor.find_or_create_by_name(:name=>"Eating more fiber")
abdominal_swelling_factor = Factor.find_or_create_by_name(:name=>"Abdominal swelling")
black_or_bloody_stool_factor = Factor.find_or_create_by_name(:name=>"Black or bloody stool")
constipation_factor = Factor.find_or_create_by_name(:name=>"Constipation")
diarrhea_factor = Factor.find_or_create_by_name(:name=>"Diarrhea")
fever_factor = Factor.find_or_create_by_name(:name=>"Fever")
inability_to_move_bowels_factor = Factor.find_or_create_by_name(:name=>"Inability to move bowels")
nausea_or_vomiting_factor = Factor.find_or_create_by_name(:name=>"Nausea or vomiting ")
passing_gas_factor = Factor.find_or_create_by_name(:name=>"Passing gas")
pulsing_near_navel_factor = Factor.find_or_create_by_name(:name=>"Pulsing near navel")
rash_factor = Factor.find_or_create_by_name(:name=>"Rash")
stomach_growling_or_rumbling_factor = Factor.find_or_create_by_name(:name=>"Stomach growling or rumbling")
unintended_weight_loss_factor = Factor.find_or_create_by_name(:name=>"Unintended weight loss")
pain_from_accident_or_injury_factor = Factor.find_or_create_by_name(:name=>"Pain from accident or injury")
pain_in_chest_neck_shoulder_factor = Factor.find_or_create_by_name(:name=>"Pain in chest, neck, shoulder")
short_of_breath_or_dizzy_factor = Factor.find_or_create_by_name(:name=>"Short of breath or dizzy")
vomiting_blood_factor = Factor.find_or_create_by_name(:name=>"Vomiting blood ")
blood_in_urine_factor = Factor.find_or_create_by_name(:name=>"Blood in urine")
abdomen_swollen_or_tender_factor = Factor.find_or_create_by_name(:name=>"Abdomen swollen or tender")
high_fever_factor = Factor.find_or_create_by_name(:name=>"High Fever")
persistant_nausea_or_vomiting_factor = Factor.find_or_create_by_name(:name=>"Persistant nausea or vomiting")
radiates_from_abdomen_factor = Factor.find_or_create_by_name(:name=>"Radiates from Abdomen")
lower_abdomen_factor = Factor.find_or_create_by_name(:name=>"Lower abdomen")
middle_abdomen_factor = Factor.find_or_create_by_name(:name=>"Middle abdomen")
upper_abdomen_factor = Factor.find_or_create_by_name(:name=>"Upper abdomen")
one_or_both_sides_factor = Factor.find_or_create_by_name(:name=>"One or both sides")


#Symptom
blood_in_stool_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Blood in Stool", :patient_type=>"adult")
chest_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Chest Pain", :patient_type=>"adult")
constipation_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Constipation", :patient_type=>"adult")
diarrhea_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Diarrhea", :patient_type=>"adult")
difficulty_swallowing_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Difficulty Swallowing", :patient_type=>"adult")
dizziness_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Dizziness", :patient_type=>"adult")
eye_discomfort_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Eye Discomfort", :patient_type=>"adult")
foot_ankle_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Foot/Ankle Pain", :patient_type=>"adult")
foot_leg_swelling_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Foot/Leg Swelling", :patient_type=>"adult")
headache_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Headache", :patient_type=>"adult")
heart_palpitations_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Heart Palpitations", :patient_type=>"adult")
hip_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Hip Pain", :patient_type=>"adult")
knee_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Knee Pain", :patient_type=>"adult")
low_back_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Low Back Pain", :patient_type=>"adult")
nasal_congestion_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Nasal Congestion", :patient_type=>"adult")
neck_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Neck Pain", :patient_type=>"adult")
numbness_in_hands_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Numbness in Hands", :patient_type=>"adult")
pelvic_pain_male_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Pelvic Pain (Male)", :patient_type=>"adult")
pelvic_pain_female_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Pelvic Pain (Female)", :patient_type=>"adult")
shortness_of_breath_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Shortness of Breath", :patient_type=>"adult")
shoulder_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Shoulder Pain", :patient_type=>"adult")
sore_throat_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Sore Throat", :patient_type=>"adult")
urinary_problems_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Urinary Problems", :patient_type=>"adult")
vision_problems_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Vision Problems", :patient_type=>"adult")
wheezing_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Wheezing", :patient_type=>"adult")
abdominal_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Abdominal Pain", :patient_type=>"adult")
cough_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Cough", :patient_type=>"adult")


#SymptomsFactor
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>dry_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>acute_began_suddenly_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>burning_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>chronic_ongoing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>crampy_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>dull_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>gnawing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>intense_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>intermittent_episodic_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>worsens_over_time_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>sharp_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>steady_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)


SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>coughing_or_jarring_movements_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>drinking_alcohol_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>stress_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>antacids_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>avoiding_certain_foods_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>changing_position_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>drinking_more_water_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>eating_more_fibre_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)

SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>abdominal_swelling_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>black_or_bloody_stool_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>constipation_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>diarrhea_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>inability_to_move_bowels_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>passing_gas_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>pulsing_near_navel_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>rash_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>stomach_growling_or_rumbling_factor.id,
  :factor_group_id=>important_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>important_factor_group.id
)

SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>pain_from_accident_or_injury_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>pain_in_chest_neck_shoulder_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>short_of_breath_or_dizzy_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>vomiting_blood_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>blood_in_urine_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>abdomen_swollen_or_tender_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>high_fever_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>persistant_nausea_or_vomiting_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)

SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>radiates_from_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>lower_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>middle_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>upper_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>one_or_both_sides_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)

o = Offering.find_or_create_by_name(name: 'Phone Call')
p = Plan.find_or_create_by_name(name: 'Silver', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 2, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Gold', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 3, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Platinum', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: nil, unlimited: true)
