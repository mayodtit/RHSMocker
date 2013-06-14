# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


#some default content
unless Content.find_by_title("Installed Better")
	installed = Content.create!(
		contentsType: 'message',
		title: "Installed Better",
		body:"Installed Better")
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

hcp = Role.find_or_create_by_name(:name => 'hcp')
Role.find_or_create_by_name(:name => 'admin')

[
  {:install_id => 'test-1', :first_name => 'Jack', :last_name => 'Kevorkian', :gender => 'M'},
  {:install_id => 'test-2', :first_name => 'Emmett', :last_name => 'Brown', :gender => 'M'},
  {:install_id => 'test-3', :first_name => 'Hannibal', :last_name => 'Lecter', :gender => 'M'}
].each do |u|
  user = User.find_or_create_by_install_id(u)
  user.roles << hcp unless user.hcp?
end

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

#Disease.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Disease.find_or_create_by_name(:name=>"Hypertensive disorder",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"38341003")
Disease.find_or_create_by_name(:name=>"Hyperlipidemia",:snomed_name=>"Hyperlipidemia",:snomed_code=>"55822004")
Disease.find_or_create_by_name(:name=>"Depressive Disorder",:snomed_name=>"Depressive disorder",:snomed_code=>"35489007")
Disease.find_or_create_by_name(:name=>"Gastroesophageal reflux",:snomed_name=>"Gastroesophageal reflux",:snomed_code=>"235595009")
Disease.find_or_create_by_name(:name=>"Type 2 Diabetes",:snomed_name=>"Diabetes mellitus type 2",:snomed_code=>"44054006")
Disease.find_or_create_by_name(:name=>"Asthma",:snomed_name=>"Asthma",:snomed_code=>"195967001")

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


#FactorGroup
pain_is_factor_group =FactorGroup.find_or_create_by_name(:name=>"Pain is")
caused_by_factor_group = FactorGroup.find_or_create_by_name(:name=>"Caused by")
problem_is_factor_group = FactorGroup.find_or_create_by_name(:name=>"Problem is")
accompanied_by_factor_group = FactorGroup.find_or_create_by_name(:name=>"Accompanied by")
relieved_by_factor_group = FactorGroup.find_or_create_by_name(:name=>"Relieved by")
important_factor_group = FactorGroup.find_or_create_by_name(:name=>"Important")
triggered_by_factor_group = FactorGroup.find_or_create_by_name(:name=>"Triggered by")
pain_located_factor_group = FactorGroup.find_or_create_by_name(:name=>"Pain located")

#Factor
intense_factor = Factor.find_or_create_by_name(:name=>"intense")
drinking_alcohol_factor = Factor.find_or_create_by_name(:name=>"drinking alcohol")
dry_factor = Factor.find_or_create_by_name(:name=>"dry")
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

d50k9k4crm3p9c=> select * from factors;

 id |              name              |         created_at         |         updated_at
----+--------------------------------+----------------------------+----------------------------
  1 | intense                        | 2013-04-08 14:38:11.235675 | 2013-04-08 14:38:11.235675
  2 | drinking alcohol               | 2013-04-08 14:38:26.712653 | 2013-04-08 14:38:26.712653
  3 | dry                            | 2013-04-08 14:38:39.972431 | 2013-04-08 14:38:39.972431
  4 | recently                       | 2013-04-08 14:38:57.705158 | 2013-04-08 14:38:57.705158
  5 | Acute, began suddenly          | 2013-04-08 19:03:41.580162 | 2013-04-08 19:03:41.580162
  6 | Burning                        | 2013-04-08 19:04:00.244302 | 2013-04-08 19:04:00.244302
  7 | Chronic, ongoing               | 2013-04-08 19:04:10.456678 | 2013-04-08 19:04:10.456678
  8 | Crampy                         | 2013-04-08 19:04:19.282019 | 2013-04-08 19:04:19.282019
  9 | Dull                           | 2013-04-08 19:04:24.959328 | 2013-04-08 19:04:24.959328
 10 | Gnawing                        | 2013-04-08 19:04:33.266411 | 2013-04-08 19:04:33.266411
 11 | Intense                        | 2013-04-08 19:04:40.533056 | 2013-04-08 19:04:40.533056
 12 | Intermittent, Episodic         | 2013-04-08 19:05:00.004419 | 2013-04-08 19:05:00.004419
 13 | Worsens over time              | 2013-04-08 19:05:13.914666 | 2013-04-08 19:05:13.914666
 14 | Sharp                          | 2013-04-08 19:05:22.519167 | 2013-04-08 19:05:22.519167
 15 | Steady                         | 2013-04-08 19:05:29.73206  | 2013-04-08 19:05:29.73206
 16 | Coughing or Jarring Movements  | 2013-04-08 19:13:37.872049 | 2013-04-08 19:13:37.872049
 17 | Drinking Alchohol              | 2013-04-08 19:13:53.114299 | 2013-04-08 19:13:53.114299
 18 | Eating certain foods           | 2013-04-08 19:14:07.819065 | 2013-04-08 19:14:07.819065
 19 | Stress                         | 2013-04-08 19:14:18.833526 | 2013-04-08 19:14:18.833526
 20 | Antacids                       | 2013-04-08 19:18:38.089534 | 2013-04-08 19:18:38.089534
 21 | Avoiding certain foods         | 2013-04-08 19:18:46.956859 | 2013-04-08 19:18:46.956859
 22 | Changing position              | 2013-04-08 19:19:01.728172 | 2013-04-08 19:19:01.728172
 23 | Drinking more water            | 2013-04-08 19:19:12.998946 | 2013-04-08 19:19:12.998946
 24 | Eating certain foods           | 2013-04-08 19:19:26.280495 | 2013-04-08 19:19:26.280495
 25 | Eating more fiber              | 2013-04-08 19:19:35.944416 | 2013-04-08 19:19:35.944416
 26 | Abdominal swelling             | 2013-04-08 19:23:10.544517 | 2013-04-08 19:23:10.544517
 27 | Black or bloody stool          | 2013-04-08 19:23:24.608838 | 2013-04-08 19:23:24.608838
 28 | Constipation                   | 2013-04-08 19:23:37.693568 | 2013-04-08 19:23:37.693568
 29 | Diarrhea                       | 2013-04-08 19:23:49.169514 | 2013-04-08 19:23:49.169514
 30 | Fever                          | 2013-04-08 19:23:57.020324 | 2013-04-08 19:23:57.020324
 31 | Inability to move bowels       | 2013-04-08 19:24:09.792199 | 2013-04-08 19:24:09.792199
 32 | Nausea or vomiting             | 2013-04-08 19:24:22.911068 | 2013-04-08 19:24:22.911068
 33 | Passing gas                    | 2013-04-08 19:24:33.396249 | 2013-04-08 19:24:33.396249
 34 | Pulsing near navel             | 2013-04-08 19:24:45.142818 | 2013-04-08 19:24:45.142818
 35 | Rash                           | 2013-04-08 19:24:53.590972 | 2013-04-08 19:24:53.590972
 36 | Stomach growling or rumbling   | 2013-04-08 19:25:06.76592  | 2013-04-08 19:25:06.76592
 37 | Unintended weight loss         | 2013-04-08 19:25:25.62599  | 2013-04-08 19:25:25.62599
 38 | Pain from accident or injury   | 2013-04-08 20:55:53.106558 | 2013-04-08 20:55:53.106558
 39 | Pain in chest, neck, shoulder  | 2013-04-08 21:17:11.465386 | 2013-04-08 21:17:11.465386
 40 | Short of breath or dizzy       | 2013-04-08 21:17:34.574634 | 2013-04-08 21:17:34.574634
 41 | Vomiting blood                 | 2013-04-08 21:17:48.729472 | 2013-04-08 21:17:48.729472
 42 | Black or bloody stool          | 2013-04-08 21:17:59.608207 | 2013-04-08 21:17:59.608207
 43 | Blood in urine                 | 2013-04-08 21:18:12.973096 | 2013-04-08 21:18:12.973096
 44 | Abdomen swollen or tender      | 2013-04-08 21:18:27.126701 | 2013-04-08 21:18:27.126701
 45 | High Fever                     | 2013-04-08 21:18:42.588638 | 2013-04-08 21:18:42.588638
 46 | Persistant nausea or vomiting  | 2013-04-08 21:19:44.941665 | 2013-04-08 21:19:44.941665
 47 | Radiates from Abdomen          | 2013-04-09 01:15:08.508172 | 2013-04-09 01:15:08.508172
 48 | Lower abdomen                  | 2013-04-09 01:15:32.43729  | 2013-04-09 01:15:32.43729
 49 | Middle abdomen                 | 2013-04-09 01:15:39.200714 | 2013-04-09 01:15:39.200714
 50 | Upper abdomen                  | 2013-04-09 01:15:55.515221 | 2013-04-09 01:15:55.515221
 51 | One or both sides              | 2013-04-09 01:16:05.473565 | 2013-04-09 01:16:05.473565



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

d50k9k4crm3p9c=> select * from symptoms;
 id |         name          |         created_at         |         updated_at         | patient_type
----+-----------------------+----------------------------+----------------------------+--------------
  5 | Blood in Stool        | 2013-04-08 18:45:35.252679 | 2013-04-08 18:45:35.252679 | adult
  6 | Chest Pain            | 2013-04-08 18:45:56.537634 | 2013-04-08 18:45:56.537634 | adult
  7 | Constipation          | 2013-04-08 18:46:06.712211 | 2013-04-08 18:46:06.712211 | adult
  8 | Diarrhea              | 2013-04-08 18:46:21.063892 | 2013-04-08 18:46:21.063892 | adult
  9 | Difficulty Swallowing | 2013-04-08 18:46:31.623682 | 2013-04-08 18:46:31.623682 | adult
 10 | Dizziness             | 2013-04-08 18:46:41.880681 | 2013-04-08 18:46:41.880681 | adult
 11 | Eye Discomfort        | 2013-04-08 18:46:58.914723 | 2013-04-08 18:46:58.914723 | adult
 12 | Foot/Ankle Pain       | 2013-04-08 18:47:15.222806 | 2013-04-08 18:47:15.222806 | adult
 13 | Foot/Leg Swelling     | 2013-04-08 18:47:25.685762 | 2013-04-08 18:47:25.685762 | adult
 14 | Headache              | 2013-04-08 18:47:42.887861 | 2013-04-08 18:47:42.887861 | adult
 15 | Heart Palpitations    | 2013-04-08 18:47:55.722536 | 2013-04-08 18:47:55.722536 | adult
 16 | Hip Pain              | 2013-04-08 18:48:06.8191   | 2013-04-08 18:48:06.8191   | adult
 17 | Knee Pain             | 2013-04-08 18:48:16.948782 | 2013-04-08 18:48:16.948782 | adult
 18 | Low Back Pain         | 2013-04-08 18:48:26.418408 | 2013-04-08 18:48:26.418408 | adult
 19 | Nasal Congestion      | 2013-04-08 18:48:41.783138 | 2013-04-08 18:48:41.783138 | adult
 20 | Neck Pain             | 2013-04-08 18:48:51.828553 | 2013-04-08 18:48:51.828553 | adult
 21 | Numbness in Hands     | 2013-04-08 18:49:04.128484 | 2013-04-08 18:49:04.128484 | adult
 22 | Pelvic Pain (Male)    | 2013-04-08 18:49:21.947199 | 2013-04-08 18:49:21.947199 | adult
 23 | Pelvic Pain (Female)  | 2013-04-08 18:49:29.799045 | 2013-04-08 18:49:29.799045 | adult
 24 | Shortness of Breath   | 2013-04-08 18:49:45.475803 | 2013-04-08 18:49:45.475803 | adult
 25 | Shoulder Pain         | 2013-04-08 18:49:58.907826 | 2013-04-08 18:49:58.907826 | adult
 26 | Sore Throat           | 2013-04-08 18:50:09.842771 | 2013-04-08 18:50:09.842771 | adult
 27 | Urinary Problems      | 2013-04-08 18:50:24.656783 | 2013-04-08 18:50:24.656783 | adult
 28 | Vision Problems       | 2013-04-08 18:50:37.292701 | 2013-04-08 18:50:37.292701 | adult
 29 | Wheezing              | 2013-04-08 18:50:46.914783 | 2013-04-08 18:50:46.914783 | adult
  2 | Abdominal Pain        | 2013-04-08 14:36:45.29799  | 2013-04-08 14:36:45.29799  | adult
  3 | Cough                 | 2013-04-08 14:37:06.615344 | 2013-04-08 14:37:06.615344 | adult



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
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>pain_in_chest_neck_shoulder_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>short_of_breath_or_dizzy_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>vomiting_blood_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>blood_in_urine_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>abdomen_swollen_or_tender_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>high_fever_factor.id,
  :factor_group_id=>triggered_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>true,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>persistant_nausea_or_vomiting_factor.id,
  :factor_group_id=>triggered_factor_group.id
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


d50k9k4crm3p9c=> select * from symptoms_factors;
 id | doctor_call_worthy | er_worthy | symptom_id | factor_id | factor_group_id |         created_at         |         updated_at
----+--------------------+-----------+------------+-----------+-----------------+----------------------------+----------------------------
  4 | f                  | f         |          3 |         3 |               1 | 2013-04-08 14:44:53.57617  | 2013-04-08 14:44:53.57617
  6 | f                  | f         |          2 |         5 |               1 | 2013-04-08 19:08:42.880659 | 2013-04-08 19:08:42.880659
  7 | f                  | f         |          2 |         6 |               1 | 2013-04-08 19:08:49.192375 | 2013-04-08 19:08:49.192375
  8 | f                  | f         |          2 |         7 |               1 | 2013-04-08 19:09:07.629429 | 2013-04-08 19:09:07.629429
  9 | f                  | f         |          2 |         8 |               1 | 2013-04-08 19:09:13.796395 | 2013-04-08 19:09:13.796395
 10 | f                  | f         |          2 |         9 |               1 | 2013-04-08 19:09:20.780844 | 2013-04-08 19:09:20.780844
 11 | f                  | f         |          2 |        10 |               1 | 2013-04-08 19:09:26.037539 | 2013-04-08 19:09:26.037539
 12 | f                  | f         |          2 |        11 |               1 | 2013-04-08 19:09:31.947869 | 2013-04-08 19:09:31.947869
 13 | f                  | f         |          2 |        12 |               1 | 2013-04-08 19:09:38.470269 | 2013-04-08 19:09:38.470269
 14 | f                  | f         |          2 |        13 |               1 | 2013-04-08 19:09:44.255579 | 2013-04-08 19:09:44.255579
 15 | f                  | f         |          2 |        14 |               1 | 2013-04-08 19:09:48.75509  | 2013-04-08 19:09:48.75509
 16 | f                  | f         |          2 |        15 |               1 | 2013-04-08 19:09:54.278932 | 2013-04-08 19:09:54.278932
 17 | f                  | f         |          2 |        16 |               4 | 2013-04-08 19:16:09.070668 | 2013-04-08 19:16:09.070668
 18 | f                  | f         |          2 |        17 |               4 | 2013-04-08 19:16:14.964108 | 2013-04-08 19:16:14.964108
 19 | f                  | f         |          2 |        18 |               4 | 2013-04-08 19:16:22.483559 | 2013-04-08 19:16:22.483559
 20 | f                  | f         |          2 |        19 |               4 | 2013-04-08 19:16:28.469426 | 2013-04-08 19:16:28.469426
 21 | f                  | f         |          2 |        20 |               5 | 2013-04-08 19:20:21.0488   | 2013-04-08 19:20:21.0488
 22 | f                  | f         |          2 |        21 |               5 | 2013-04-08 19:20:27.058052 | 2013-04-08 19:20:27.058052
 23 | f                  | f         |          2 |        22 |               5 | 2013-04-08 19:20:31.500677 | 2013-04-08 19:20:31.500677
 24 | f                  | f         |          2 |        23 |               5 | 2013-04-08 19:20:36.226647 | 2013-04-08 19:20:36.226647
 25 | f                  | f         |          2 |        24 |               5 | 2013-04-08 19:20:41.096902 | 2013-04-08 19:20:41.096902
 26 | f                  | f         |          2 |        25 |               5 | 2013-04-08 19:20:45.68859  | 2013-04-08 19:20:45.68859
 27 | f                  | f         |          2 |        26 |               6 | 2013-04-08 19:26:32.128108 | 2013-04-08 19:26:32.128108
 28 | f                  | f         |          2 |        27 |               6 | 2013-04-08 19:26:36.809703 | 2013-04-08 19:26:36.809703
 29 | f                  | f         |          2 |        28 |               6 | 2013-04-08 19:26:41.476581 | 2013-04-08 19:26:41.476581
 30 | f                  | f         |          2 |        29 |               6 | 2013-04-08 19:26:47.767851 | 2013-04-08 19:26:47.767851
 31 | f                  | f         |          2 |        30 |               6 | 2013-04-08 19:26:53.484694 | 2013-04-08 19:26:53.484694
 32 | f                  | f         |          2 |        31 |               6 | 2013-04-08 19:26:57.620828 | 2013-04-08 19:26:57.620828
 33 | f                  | f         |          2 |        32 |               6 | 2013-04-08 19:27:03.371926 | 2013-04-08 19:27:03.371926
 34 | f                  | f         |          2 |        33 |               6 | 2013-04-08 19:27:10.381722 | 2013-04-08 19:27:10.381722
 35 | f                  | f         |          2 |        34 |               6 | 2013-04-08 19:27:15.981734 | 2013-04-08 19:27:15.981734
 36 | f                  | f         |          2 |        35 |               6 | 2013-04-08 19:27:21.837267 | 2013-04-08 19:27:21.837267
 37 | f                  | f         |          2 |        36 |               6 | 2013-04-08 19:27:26.168885 | 2013-04-08 19:27:26.168885
 38 | f                  | f         |          2 |        37 |               6 | 2013-04-08 19:27:30.860603 | 2013-04-08 19:27:30.860603
 39 | f                  | t         |          2 |        38 |               7 | 2013-04-08 21:21:23.440909 | 2013-04-08 21:21:23.440909
 40 | f                  | t         |          2 |        39 |               7 | 2013-04-08 21:21:28.898265 | 2013-04-08 21:21:28.898265
 41 | f                  | t         |          2 |        40 |               7 | 2013-04-08 21:21:34.301152 | 2013-04-08 21:21:34.301152
 42 | f                  | t         |          2 |        41 |               7 | 2013-04-08 21:21:38.408061 | 2013-04-08 21:21:38.408061
 43 | f                  | t         |          2 |        42 |               7 | 2013-04-08 21:21:42.802763 | 2013-04-08 21:21:42.802763
 44 | f                  | t         |          2 |        43 |               7 | 2013-04-08 21:23:44.701811 | 2013-04-08 21:23:44.701811
 45 | f                  | t         |          2 |        44 |               7 | 2013-04-08 21:23:51.731708 | 2013-04-08 21:23:51.731708
 46 | f                  | t         |          2 |        45 |               7 | 2013-04-08 21:23:56.288734 | 2013-04-08 21:23:56.288734
 47 | f                  | t         |          2 |        46 |               7 | 2013-04-08 21:24:01.261554 | 2013-04-08 21:24:01.261554
 48 | f                  | f         |          2 |        47 |               8 | 2013-04-09 01:17:05.880623 | 2013-04-09 01:17:05.880623
 49 | f                  | f         |          2 |        48 |               8 | 2013-04-09 01:17:10.819673 | 2013-04-09 01:17:10.819673
 50 | f                  | f         |          2 |        49 |               8 | 2013-04-09 01:17:15.757983 | 2013-04-09 01:17:15.757983
 51 | f                  | f         |          2 |        50 |               8 | 2013-04-09 01:17:23.867694 | 2013-04-09 01:17:23.867694
 52 | f                  | f         |          2 |        51 |               8 | 2013-04-09 01:17:28.55885  | 2013-04-09 01:17:28.55885
(48 rows)

#ContentsSymptomsFactor

d50k9k4crm3p9c=> select * from contents_symptoms_factors;
 id | content_id | symptoms_factor_id |         created_at         |         updated_at
----+------------+--------------------+----------------------------+----------------------------
  1 |       3031 |                  1 | 2013-04-08 14:51:37.576334 | 2013-04-08 14:51:37.576334
  2 |       3032 |                  2 | 2013-04-08 14:52:27.638389 | 2013-04-08 14:52:27.638389
  3 |       3031 |                  4 | 2013-04-08 14:52:39.636978 | 2013-04-08 14:52:39.636978
  4 |       3461 |                  8 | 2013-04-08 19:55:55.022687 | 2013-04-08 19:55:55.022687
  5 |       3461 |                  9 | 2013-04-08 19:56:15.06977  | 2013-04-08 19:56:15.06977
  6 |       3461 |                 25 | 2013-04-08 19:56:21.126317 | 2013-04-08 19:56:21.126317
  7 |       3461 |                 22 | 2013-04-08 19:56:25.311644 | 2013-04-08 19:56:25.311644
  8 |       3461 |                 30 | 2013-04-08 19:56:30.507656 | 2013-04-08 19:56:30.507656
  9 |       3461 |                 34 | 2013-04-08 19:56:38.147305 | 2013-04-08 19:56:38.147305
 10 |       3461 |                 36 | 2013-04-08 19:56:43.638943 | 2013-04-08 19:56:43.638943
 11 |       3461 |                 37 | 2013-04-08 19:56:47.64333  | 2013-04-08 19:56:47.64333
 12 |       3461 |                 38 | 2013-04-08 19:56:56.361098 | 2013-04-08 19:56:56.361098
 13 |       5706 |                  6 | 2013-04-08 20:43:27.951739 | 2013-04-08 20:43:27.951739
 14 |       5706 |                  9 | 2013-04-08 20:43:36.387303 | 2013-04-08 20:43:36.387303
 15 |       5706 |                 10 | 2013-04-08 20:43:53.985959 | 2013-04-08 20:43:53.985959
 16 |       5706 |                 12 | 2013-04-08 20:44:01.27833  | 2013-04-08 20:44:01.27833
 17 |       5706 |                 15 | 2013-04-08 20:44:08.06052  | 2013-04-08 20:44:08.06052
 18 |       5706 |                 16 | 2013-04-08 20:44:16.070325 | 2013-04-08 20:44:16.070325
 19 |       5706 |                 17 | 2013-04-08 20:44:26.457038 | 2013-04-08 20:44:26.457038
 20 |       5706 |                 27 | 2013-04-08 20:44:38.00241  | 2013-04-08 20:44:38.00241
 21 |       5706 |                 29 | 2013-04-08 20:44:41.984208 | 2013-04-08 20:44:41.984208
 22 |       5706 |                 30 | 2013-04-08 20:44:48.409215 | 2013-04-08 20:44:48.409215
 23 |       5706 |                 31 | 2013-04-08 20:44:53.583715 | 2013-04-08 20:44:53.583715
 24 |       5706 |                 33 | 2013-04-08 20:44:58.050654 | 2013-04-08 20:44:58.050654
 25 |       5706 |                 49 | 2013-04-09 01:21:29.545281 | 2013-04-09 01:21:29.545281
 26 |       5706 |                 50 | 2013-04-09 01:21:35.258906 | 2013-04-09 01:21:35.258906
 27 |       5706 |                 52 | 2013-04-09 01:21:41.628766 | 2013-04-09 01:21:41.628766
 28 |       3064 |                 48 | 2013-04-09 01:21:54.525053 | 2013-04-09 01:21:54.525053
 29 |       3064 |                 50 | 2013-04-09 01:22:02.278565 | 2013-04-09 01:22:02.278565
 30 |       3064 |                 35 | 2013-04-09 01:22:06.707397 | 2013-04-09 01:22:06.707397





