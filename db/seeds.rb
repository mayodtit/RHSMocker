Content.upsert_attributes({:title => 'Welcome to Better!'},
                          {:content_type => 'Content',
                           :body => 'Thank you for installing Better!'})

Question.upsert_attributes({:view => :gender}, {:title => 'Your Gender'})

Content.upsert_attributes({:title => "Your Allergies",
                           :content_type => 'Question'},
                          {
                            :body => <<-EOF
	<div class = "content_subtitle">Are you allergic to anything?</div>
	<div style="float:left;width:110px;text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;goto_allergies&quot; } , {&quot;type&quot; : &quot;save_item&quot; } ]\'; window.location.href = &quot;http://dontload/&quot; ; ">
	<img alt="Have Allergies" width="110" src="/assets/allergy_icon.png"/></a>
	</div>
	<div style="float:right;width:110px;text-align:center;">
	<a href="#" onclick="document.actionJSON = \'[{&quot;type&quot; : &quot;add_allergy&quot; , &quot;body&quot; : {&quot;allergy_id&quot; : &quot;50&quot;} } , {&quot;type&quot; : &quot;save_item&quot; } ] \'; window.location.href = &quot;http://dontload/&quot; ;">
	<img alt="No Allergies" width="110" src="/assets/allergy_none_icon.png"/></a>
	</div>
    EOF
                          })

Question.upsert_attributes({:view => :diet}, {:title => 'Which of these do you eat?'})

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
Allergy.find_or_create_by_name(:name=>"No Allergies",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"None",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
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
Allergy.find_or_create_by_name(:name=>"Sunlight",:snomed_name=>"Photosensitization due to sun",:snomed_code=>"258155009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
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


#Condition.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Condition.find_or_create_by_name(:name=>"Hypertensive disorder",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"38341003")
Condition.find_or_create_by_name(:name=>"Hyperlipidemia",:snomed_name=>"Hyperlipidemia",:snomed_code=>"55822004")
Condition.find_or_create_by_name(:name=>"Depressive Disorder",:snomed_name=>"Depressive disorder",:snomed_code=>"35489007")
Condition.find_or_create_by_name(:name=>"Gastroesophageal reflux",:snomed_name=>"Gastroesophageal reflux",:snomed_code=>"235595009")
Condition.find_or_create_by_name(:name=>"Type 2 Diabetes",:snomed_name=>"Diabetes mellitus type 2",:snomed_code=>"44054006")
Condition.find_or_create_by_name(:name=>"Asthma",:snomed_name=>"Asthma",:snomed_code=>"195967001")
Condition.find_or_create_by_name(:name=>"Essential Hypertension",:snomed_name=>"Essential hypertension",:snomed_code=>"59621000")
Condition.find_or_create_by_name(:name=>"Obesity",:snomed_name=>"Obesity",:snomed_code=>"414916001")
Condition.find_or_create_by_name(:name=>"Diabetes",:snomed_name=>"Diabetes mellitus",:snomed_code=>"73211009")
Condition.find_or_create_by_name(:name=>"Allergic rhinitis",:snomed_name=>"Allergic rhinitis",:snomed_code=>"61582004")
Condition.find_or_create_by_name(:name=>"Hypothyroidism",:snomed_name=>"Hypothyroidism",:snomed_code=>"40930008")
Condition.find_or_create_by_name(:name=>"Upper respiratory infection",:snomed_name=>"Upper respiratory infection",:snomed_code=>"54150009")
Condition.find_or_create_by_name(:name=>"Coronary arteriosclerosis",:snomed_name=>"Coronary arteriosclerosis",:snomed_code=>"53741008")
Condition.find_or_create_by_name(:name=>"Hypercholesterolemia",:snomed_name=>"Hypercholesterolemia",:snomed_code=>"13644009")
Condition.find_or_create_by_name(:name=>"Urinary tract infectious disease",:snomed_name=>"Urinary tract infectious disease",:snomed_code=>"68566005")
Condition.find_or_create_by_name(:name=>"Anemia",:snomed_name=>"Anemia",:snomed_code=>"271737000")


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

o = Offering.find_or_create_by_name(name: 'Phone Call')
p = Plan.find_or_create_by_name(name: 'Silver', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 2, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Gold', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 3, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Platinum', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: nil, unlimited: true)

########################################################################
#
# ONLY SYMTPOMS CHECKER CONTENT AFTER THIS LINE!
#
#########################################################################
#FactorGroup
accompanied_by_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Accompanied by")
appearance_of_eye_factor_group= FactorGroup.find_or_create_by_name(:name=>"Appearance of eye includes")
blood_appears_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Blood appears")
cough_is_factor_group         = FactorGroup.find_or_create_by_name(:name=>"Cough is")
duration_is_factor_group      = FactorGroup.find_or_create_by_name(:name=>"Duration is")
duration_of_headache_is_factor_group = FactorGroup.find_or_create_by_name(:name=>"Duration of headache is")
eye_discomfort_described_as_factor_group = FactorGroup.find_or_create_by_name(:name=>"Eye discomfort best described as")
heart_rate_is_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Heart rate is")
located_factor_group          = FactorGroup.find_or_create_by_name(:name=>"Located")
located_in_factor_group       = FactorGroup.find_or_create_by_name(:name=>"Located in")
nasal_congestion_is_factor_group = FactorGroup.find_or_create_by_name(:name=>"Nasal congestion is")
nasal_discharge_is_factor_group = FactorGroup.find_or_create_by_name(:name=>"Nasal discharge is")
numbness_or_tingling_is_factor_group = FactorGroup.find_or_create_by_name(:name=>"Numbness or tingling")
onset_factor_group            = FactorGroup.find_or_create_by_name(:name=>"Onset")
onset_is_factor_group         = FactorGroup.find_or_create_by_name(:name=>"Onset is")
pain_factor_group             = FactorGroup.find_or_create_by_name(:name=>"Pain")
pain_best_described_as_factor_group       = FactorGroup.find_or_create_by_name(:name=>"Pain best described as")
pain_is_factor_group 		      = FactorGroup.find_or_create_by_name(:name=>"Pain is")
pain_located_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Pain located")
pain_started_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Pain started")
palpitations_often_occur_when_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Palpitations often occur when")
preceded_by_factor_group      = FactorGroup.find_or_create_by_name(:name=>"Preceded by")
preceded_by_use_of_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Preceded by use of")
problem_affects_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Problem affects")
problem_is_factor_group       = FactorGroup.find_or_create_by_name(:name=>"Problem is")
recurrence_of_headache_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Recurrence of headache")
related_pain_involves_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Related pain involves")
relieved_by_factor_group      = FactorGroup.find_or_create_by_name(:name=>"Relieved by")
swallowing_factor_group       = FactorGroup.find_or_create_by_name(:name=>"Swallowing")
swelling_occurs_factor_group  = FactorGroup.find_or_create_by_name(:name=>"Swelling occurs")
symptoms_are_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Symptoms are")
triggered_by_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Triggered by")
triggered_or_worsened_by_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Triggered or worsened by")
vision_improves_somewhat_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Vision improves somewhat with")
vision_problem_includes_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Vision problem includes")
wheezing_is_factor_group      = FactorGroup.find_or_create_by_name(:name=>"Wheezing is")
worsened_by_factor_group      = FactorGroup.find_or_create_by_name(:name=>"Worsened by")
you_feel_factor_group         = FactorGroup.find_or_create_by_name(:name=>"You feel")

#Special Case Factor Groups
important_factor_group 		  = FactorGroup.find_or_create_by_name(:name=>"Important")


#Factor
#_factor          = Factor.find_or_create_by_name(:name=>" ")

a_change_in_head_or_body_position_factor  = Factor.find_or_create_by_name(:name=>"A change in head or body position")
a_fever_of_102_F_or_higher_factor         = Factor.find_or_create_by_name(:name=>"A fever of 102 F (38.9 C) or higher")
a_few_minutes_factor                      = Factor.find_or_create_by_name(:name=>"A few minutes")
a_new_persistent_urge_to_urinate_factor   = Factor.find_or_create_by_name(:name=>"A new persistent urge to urinate")
a_spinning_sensation_factor               = Factor.find_or_create_by_name(:name=>"A spinning sensation")
abdomen_but_radiates_factor               = Factor.find_or_create_by_name(:name=>"Abdomen but radiates to other parts of the body")
abdominal_bloating_or_swelling_factor     = Factor.find_or_create_by_name(:name=>"Abdominal bloating or swelling")
abdominal_pain_factor                     = Factor.find_or_create_by_name(:name=>"Abdominal pain")
abdominal_pain_or_cramping_factor         = Factor.find_or_create_by_name(:name=>"Abdominal pain or cramping")
abdominal_pain_discomfort_cramps_factor   = Factor.find_or_create_by_name(:name=>"Abdominal pain, discomfort or cramps")
abdominal_swelling_factor                 = Factor.find_or_create_by_name(:name=>"Abdominal swelling")
abnormal_vaginal_bleeding_factor          = Factor.find_or_create_by_name(:name=>"Abnormal vaginal bleeding")
ache_factor                               = Factor.find_or_create_by_name(:name=>"Ache")
achy_joints_or_muscles_factor             = Factor.find_or_create_by_name(:name=>"Achy joints or muscles")
achy_or_gnawing_factor                    = Factor.find_or_create_by_name(:name=>"Achy or gnawing")
activity_or_overuse_factor                = Factor.find_or_create_by_name(:name=>"Activity or overuse")
acute_began_suddenly_factor               = Factor.find_or_create_by_name(:name=>"Acute, began suddenly")
affects_both_hands_factor                 = Factor.find_or_create_by_name(:name=>"Affects both hands")
affects_one_hand_factor                   = Factor.find_or_create_by_name(:name=>"Affects one hand")
allergens_or_irritants_factor             = Factor.find_or_create_by_name(:name=>"Allergens or irritants")
allergens_or_other_irritants_factor       = Factor.find_or_create_by_name(:name=>"Allergens or other irritants")
along_one_or_both_sides_of_the_knee_factor= Factor.find_or_create_by_name(:name=>"Along one or both sides of the knee")
along_whole_limb_factor                   = Factor.find_or_create_by_name(:name=>"Along whole limb")
alternates_with_diarrhea_factor           = Factor.find_or_create_by_name(:name=>"Alternates with diarrhea")
an_inability_to_raise_your_arm_factor     = Factor.find_or_create_by_name(:name=>"An inability to raise your arm")
anal_itching_factor                       = Factor.find_or_create_by_name(:name=>"Anal itching")
anal_or_rectal_pain_factor                = Factor.find_or_create_by_name(:name=>"Anal or rectal pain")
ankle_factor                              = Factor.find_or_create_by_name(:name=>"Ankle")
antacids_factor                           = Factor.find_or_create_by_name(:name=>"Antacids")
anxiety_factor                            = Factor.find_or_create_by_name(:name=>"Anxiety")
anxiety_or_stress_factor                  = Factor.find_or_create_by_name(:name=>"Anxiety or stress")
applying_pressure_or_trying_to_bear_weight_factor = Factor.find_or_create_by_name(:name=>"Applying pressure or trying to bear weight")
area_along_edge_of_toenail_factor         = Factor.find_or_create_by_name(:name=>"Area along edge of toenail")
arm_or_hand_pain_factor                   = Factor.find_or_create_by_name(:name=>"Arm or hand pain")
arm_or_hand_weakness_factor               = Factor.find_or_create_by_name(:name=>"Arm or hand weakness")
around_ankle_or_foot_factor               = Factor.find_or_create_by_name(:name=>"Around ankle or foot")
around_face_or_forehead_factor            = Factor.find_or_create_by_name(:name=>"Around face or forehead")
around_knee_factor                        = Factor.find_or_create_by_name(:name=>"Around knee")
around_one_eye_or_radiates_factor         = Factor.find_or_create_by_name(:name=>"Around one eye or radiates from one eye")
around_the_kneecap_factor                 = Factor.find_or_create_by_name(:name=>"Around the kneecap")
around_your_temples_factor                = Factor.find_or_create_by_name(:name=>"Around your temples")
avoiding_certain_foods_factor             = Factor.find_or_create_by_name(:name=>"Avoiding certain foods")
awaking_two_or_more_times_to_urinate_factor = Factor.find_or_create_by_name(:name=>"Awaking two or more times in the night to urinate")
back_of_ankle_factor                      = Factor.find_or_create_by_name(:name=>"Back of ankle")
back_of_heel_factor                       = Factor.find_or_create_by_name(:name=>"Back of heel")
back_or_side_pain_factor                  = Factor.find_or_create_by_name(:name=>"Back or side pain")
bad_breath_factor                         = Factor.find_or_create_by_name(:name=>"Bad breath")
began_suddenly_factor                     = Factor.find_or_create_by_name(:name=>"Began suddenly")
began_suddenly_and_affects_factor         = Factor.find_or_create_by_name(:name=>"Began suddenly and affects your ability to function")
beginning_suddenly_factor                 = Factor.find_or_create_by_name(:name=>"Beginning suddenly")
behind_the_knee_factor                    = Factor.find_or_create_by_name(:name=>"Behind the knee")
being_in_one_position_factor              = Factor.find_or_create_by_name(:name=>"Being in one position for a long time")
belching_factor                           = Factor.find_or_create_by_name(:name=>"Belching")
bending_forward_factor                    = Factor.find_or_create_by_name(:name=>"Bending forward")
bending_forward_leaning_factor            = Factor.find_or_create_by_name(:name=>"Bending over or leaning on something for support")
black_or_bloody_stool_factor              = Factor.find_or_create_by_name(:name=>"Black or bloody stool")
bleeding_on_surface_eye_factor            = Factor.find_or_create_by_name(:name=>"Bleeding on the surface of the white of the eye")
bloating_or_abdominal_swelling_factor     = Factor.find_or_create_by_name(:name=>"Bloating or abdominal swelling")
bloating_constipation_or_diarrhea_factor  = Factor.find_or_create_by_name(:name=>"Bloating, constipation or diarrhea")
blood_in_semen_factor                     = Factor.find_or_create_by_name(:name=>"Blood in semen")
blood_in_urine_factor                     = Factor.find_or_create_by_name(:name=>"Blood in urine")
blood_in_your_saliva_or_phlegm_factor     = Factor.find_or_create_by_name(:name=>"Blood in your saliva or phlegm")
blood_in_your_stool_or_black_stools_factor= Factor.find_or_create_by_name(:name=>"Blood in your stool or black, tarry stools")
bloody_or_cloudy_urine_factor             = Factor.find_or_create_by_name(:name=>"Bloody or cloudy urine")
bloody_phlegm_or_sputum_factor            = Factor.find_or_create_by_name(:name=>"Bloody phlegm or sputum")
bloody_stools_factor                      = Factor.find_or_create_by_name(:name=>"Bloody stools")
blue_colored_skin_or_lips_factor          = Factor.find_or_create_by_name(:name=>"Blue-colored skin or lips")
blurred_or_double_vision_factor           = Factor.find_or_create_by_name(:name=>"Blurred or double vision")
blurred_vision_factor                     = Factor.find_or_create_by_name(:name=>"Blurred vision")
blurry_distant_objects_factor             = Factor.find_or_create_by_name(:name=>"Blurry distant objects")
blurry_nearby_objects_factor              = Factor.find_or_create_by_name(:name=>"Blurry nearby objects")
blurry_or_blind_spot_in_vision_factor     = Factor.find_or_create_by_name(:name=>"Blurry or blind spot in center of vision")
blurry_vision_at_all_distances_factor     = Factor.find_or_create_by_name(:name=>"Blurry vision at all distances")
both_eyes_factor                          = Factor.find_or_create_by_name(:name=>"Both eyes")
bottom_of_foot_factor                     = Factor.find_or_create_by_name(:name=>"Bottom of foot")
bright_zigzag_lines_factor                = Factor.find_or_create_by_name(:name=>"Bright zigzag lines")
brownish_or_foamy_urine_factor            = Factor.find_or_create_by_name(:name=>"Brownish or foamy urine")
bruising_or_discoloring_factor            = Factor.find_or_create_by_name(:name=>"Bruising or discoloring")
bulge_or_lump_in_groin_area_factor        = Factor.find_or_create_by_name(:name=>"Bulge or lump in groin area")
bumps_blisters_or_open_sores_factor       = Factor.find_or_create_by_name(:name=>"Bumps, blisters or open sores")
bumps_blisters_or_open_sores_factor_genitals_factor = Factor.find_or_create_by_name(:name=>"Bumps, blisters or open sores around genitals")
burning_factor                            = Factor.find_or_create_by_name(:name=>"Burning")
burning_pain_factor                       = Factor.find_or_create_by_name(:name=>"Burning pain")
buzzing_or_ringing_in_ear_factor          = Factor.find_or_create_by_name(:name=>"Buzzing or ringing in ear")


##??
##abdomen_swollen_or_tender_factor = Factor.find_or_create_by_name(:name=>"Abdomen swollen or tender")



change_in_bowel_habits_factor   = Factor.find_or_create_by_name(:name=>"Change in your bowel habits")
changing_position_factor        = Factor.find_or_create_by_name(:name=>"Changing position")
chest_pain_or_tightness_factor  = Factor.find_or_create_by_name(:name=>"Chest pain or tightness")
chills_or_sweating_factor       = Factor.find_or_create_by_name(:name=>"Chills or sweating")

chronic_ongoing_factor  = Factor.find_or_create_by_name(:name=>"Chronic, ongoing")
constipation_factor     = Factor.find_or_create_by_name(:name=>"Constipation")
crampy_factor           = Factor.find_or_create_by_name(:name=>"Crampy")
cramping_factor         = Factor.find_or_create_by_name(:name=>"Cramping")
coughing_or_jarring_movements_factor = Factor.find_or_create_by_name(:name=>"Coughing or jarring movements")
cough_with_blood_phlegm_factor       = Factor.find_or_create_by_name(:name=>"Cough with blood or phlegm")


diarrhea_factor                         = Factor.find_or_create_by_name(:name=>"Diarrhea")
difficult_or_painful_swallowing_factor  = Factor.find_or_create_by_name(:name=>"Difficult or painful swallowing")
difficulty_breathing_factor             = Factor.find_or_create_by_name(:name=>"Difficulty breathing")
difficulty_swallowing_factor            = Factor.find_or_create_by_name(:name=>"Difficulty swallowing")


drinking_alcohol_factor = Factor.find_or_create_by_name(:name=>"Drinking alcohol")
drinking_alcohol_or_caffenine_factor = Factor.find_or_create_by_name(:name=>"Drinking alcohol or caffenine")
drinking_more_water_factor = Factor.find_or_create_by_name(:name=>"Drinking more water")
dry_factor              = Factor.find_or_create_by_name(:name=>"Dry")
dry_cough_factor        = Factor.find_or_create_by_name(:name=>"Dry cough")
dull_factor             = Factor.find_or_create_by_name(:name=>"Dull")

eating_or_drinking_factor   = Factor.find_or_create_by_name(:name=>"Eating or drinking")
eating_more_fibre_factor    = Factor.find_or_create_by_name(:name=>"Eating more fiber")
eating_certain_foods_factor = Factor.find_or_create_by_name(:name=>"Eating certain foods")
exertion_factor             = Factor.find_or_create_by_name(:name=>"Exertion")

fainting_or_dizziness_factor= Factor.find_or_create_by_name(:name=>"Fainting or dizziness")
fatigue_factor              = Factor.find_or_create_by_name(:name=>"Fatigue")

fatigue_or_weakness_factor  = Factor.find_or_create_by_name(:name=>"Fatigue or weakness")
fever_factor = Factor.find_or_create_by_name(:name=>"Fever")
frequent_urge_to_have_bowel_movement_factor  = Factor.find_or_create_by_name(:name=>"Frequent urge to have bowel movement")

gas_factor          = Factor.find_or_create_by_name(:name=>"Gas")
gnawing_factor      = Factor.find_or_create_by_name(:name=>"Gnawing")


halos_around_lights_factor                 = Factor.find_or_create_by_name(:name=>"Halos around lights")
hardening_of_skin_in_affected_area_factor  = Factor.find_or_create_by_name(:name=>"Hardening of skin in affected area")
have_something_stuck_in_your_throat_factor = Factor.find_or_create_by_name(:name=>"Have something stuck in your throat")
have_trouble_breathing_factor              = Factor.find_or_create_by_name(:name=>"Have trouble breathing")
headache_factor                            = Factor.find_or_create_by_name(:name=>"Headache")
headache_or_facial_pain_factor             = Factor.find_or_create_by_name(:name=>"Headache or facial pain")
hearing_loss_factor                        = Factor.find_or_create_by_name(:name=>"Hearing loss")
heartburn_factor                           = Factor.find_or_create_by_name(:name=>"Heartburn")
heaviness_in_affected_limb_factor          = Factor.find_or_create_by_name(:name=>"Heaviness in affected limb")
heel_factor                               = Factor.find_or_create_by_name(:name=>"Heel")
high_fever_factor                         = Factor.find_or_create_by_name(:name=>"High or persistent fever")
hives_or_rash_factor                      = Factor.find_or_create_by_name(:name=>"Hives or rash")
hoarse_or_muffled_voice_factor            = Factor.find_or_create_by_name(:name=>"Hoarse or muffled voice")
hoarse_voice_factor                       = Factor.find_or_create_by_name(:name=>"Hoarse voice")
hoarse_voice_for_more_than_week_factor    = Factor.find_or_create_by_name(:name=>"Hoarse voice for more than one week")
hoarse_voice_or_difficulty_speaking_factor = Factor.find_or_create_by_name(:name=>"Hoarse voice or difficulty speaking")
holding_objects_away_factor               = Factor.find_or_create_by_name(:name=>"Holding objects away from face")
holding_objects_close_factor              = Factor.find_or_create_by_name(:name=>"Holding objects close to face")
hormonal_changes_factor                   = Factor.find_or_create_by_name(:name=>"Hormonal changes")
hurts_factor                              = Factor.find_or_create_by_name(:name=>"Hurts")

in_or_on_stool_factor       = Factor.find_or_create_by_name(:name=>"In or on the stool")
in_or_on_toilet_bowl_factor = Factor.find_or_create_by_name(:name=>"In toilet bowl or on toilet tissue")
increased_sensitivity_to_cold_factor = Factor.find_or_create_by_name(:name=>"Increased sensitivity to cold")
intense_factor              = Factor.find_or_create_by_name(:name=>"Intense")
intermittent_factor         = Factor.find_or_create_by_name(:name=>"Intermittent")
intermittent_episodic_factor= Factor.find_or_create_by_name(:name=>"Intermittent, episodic")
inability_to_move_bowels_factor = Factor.find_or_create_by_name(:name=>"Inability to move bowels")
injury_factor               = Factor.find_or_create_by_name(:name=>"Injury")
injury_trauma_factor        = Factor.find_or_create_by_name(:name=>"Injury or trauma")


large_amounts_blood_factor = Factor.find_or_create_by_name(:name=>"Large amounts of blood")
lightheadedness_factor = Factor.find_or_create_by_name(:name=>"Lightheadedness")
lower_abdomen_factor = Factor.find_or_create_by_name(:name=>"Lower abdomen")
loss_of_appetite_factor = Factor.find_or_create_by_name(:name=>"Loss of appetite")
lying_down_for_a_long_period_factor = Factor.find_or_create_by_name(:name=>"Lying down for a long period")

middle_abdomen_factor   = Factor.find_or_create_by_name(:name=>"Middle abdomen")
muscle_aches_factor     = Factor.find_or_create_by_name(:name=>"Muscle aches")
menstrual_cycle_factor  = Factor.find_or_create_by_name(:name=>"Menstrual cycle")


narrow_stools_factor = Factor.find_or_create_by_name(:name=>"Narrow stools")
nausea_factor = Factor.find_or_create_by_name(:name=>"Nausea")
nausea_or_vomiting_factor = Factor.find_or_create_by_name(:name=>"Nausea or vomiting")
new_or_began_recently_factor = Factor.find_or_create_by_name(:name=>"New or began recently")
ongoing_or_recurrent_factor = Factor.find_or_create_by_name(:name=>"Ongoing or recurrent")


one_or_both_sides_factor = Factor.find_or_create_by_name(:name=>"One or both sides")

radiates_from_abdomen_factor = Factor.find_or_create_by_name(:name=>"Radiates from abdomen")
rapid_heart_rate_factor = Factor.find_or_create_by_name(:name=>"Rapid heart rate")
rash_factor             = Factor.find_or_create_by_name(:name=>"Rash")
recent_factor           = Factor.find_or_create_by_name(:name=>"Recent")
recently_factor         = Factor.find_or_create_by_name(:name=>"Recently")
rectal_pain_factor      = Factor.find_or_create_by_name(:name=>"Rectal pain")
rest_factor             = Factor.find_or_create_by_name(:name=>"Rest")
rapid_or_irregular_heartbeat_factor = Factor.find_or_create_by_name(:name=>"Rapid or irregular heartbeat")
runny_or_stuffy_nose_factor = Factor.find_or_create_by_name(:name=>"Runny or stuffy nose")


pain_in_neck_jaw_arms_shoulders_back_factor          = Factor.find_or_create_by_name(:name=>"Pain in neck, jaw, arms, shoulders or back")
pressing_on_chest_wall_factor          = Factor.find_or_create_by_name(:name=>"Pressing on chest wall")
passing_gas_factor = Factor.find_or_create_by_name(:name=>"Passing gas")
pain_from_accident_or_injury_factor = Factor.find_or_create_by_name(:name=>"Pain from accident or injury")
pain_in_chest_neck_shoulder_factor = Factor.find_or_create_by_name(:name=>"Pain in chest, neck, shoulder")
painful_bowel_movements_factor = Factor.find_or_create_by_name(:name=>"Painful bowel movements")
persistant_nausea_or_vomiting_factor = Factor.find_or_create_by_name(:name=>"Persistant nausea or vomiting")
pulsing_near_navel_factor = Factor.find_or_create_by_name(:name=>"Pulsing near navel")

producing_phlegm_or_sputum_factor = Factor.find_or_create_by_name(:name=>"Producing phlegm or sputum")
progressive_or_worsening_factor   = Factor.find_or_create_by_name(:name=>"Progressive or worsening")


sharp_factor              = Factor.find_or_create_by_name(:name=>"Sharp")
steady_factor             = Factor.find_or_create_by_name(:name=>"Steady")
straining_during_bowel_movements_factor = Factor.find_or_create_by_name(:name=>"Straining during bowel movements")
stress_factor             = Factor.find_or_create_by_name(:name=>"Stress")
stiff_neck_factor         = Factor.find_or_create_by_name(:name=>"Stiff neck")

stomach_growling_or_rumbling_factor = Factor.find_or_create_by_name(:name=>"Stomach growling or rumbling")
short_of_breath_or_dizzy_factor = Factor.find_or_create_by_name(:name=>"Short of breath or dizzy")
shortness_of_breath_factor = Factor.find_or_create_by_name(:name=>"Shortness of breath")
severe_factor              = Factor.find_or_create_by_name(:name=>"Severe")
sore_throat_factor         = Factor.find_or_create_by_name(:name=>"Sore throat")
squeezing_or_pressure_factor = Factor.find_or_create_by_name(:name=>"Squeezing or pressure")
sneezing_factor            = Factor.find_or_create_by_name(:name=>"Sneezing")
sudden_factor              = Factor.find_or_create_by_name(:name=>"Sudden")
sweating_factor            = Factor.find_or_create_by_name(:name=>"Sweating")

taking_a_deep_breath_factor       = Factor.find_or_create_by_name(:name=>"Taking a deep breath")
tearing_or_ripping_factor         = Factor.find_or_create_by_name(:name=>"Tearing or ripping")
tight_factor                      = Factor.find_or_create_by_name(:name=>"Tight")
thick_green_or_yellow_phlegm_or_sputum = Factor.find_or_create_by_name(:name=>"Thick green or yellow phlegm or sputum")


unexplained_fatigue_factor          = Factor.find_or_create_by_name(:name=>"Unexplained fatigue")
upper_abdomen_factor = Factor.find_or_create_by_name(:name=>"Upper abdomen")
unintended_weight_loss_factor = Factor.find_or_create_by_name(:name=>"Unintended weight loss")

weakness_factor = Factor.find_or_create_by_name(:name=>"Weakness")
watery_or_itchy_eyes_factor = Factor.find_or_create_by_name(:name=>"Watery or itchy eyes")
wheezing_factor = Factor.find_or_create_by_name(:name=>"Wheezing")


vomiting_blood_factor = Factor.find_or_create_by_name(:name=>"Vomiting blood ")


#Symptom
abdominal_pain_symptom  = Symptom.find_or_create_by_name_and_patient_type(:name=>"Abdominal Pain", :patient_type=>"adult")
blood_in_stool_symptom  = Symptom.find_or_create_by_name_and_patient_type(:name=>"Blood in Stool", :patient_type=>"adult")
chest_pain_symptom      = Symptom.find_or_create_by_name_and_patient_type(:name=>"Chest Pain", :patient_type=>"adult")
cough_symptom           = Symptom.find_or_create_by_name_and_patient_type(:name=>"Cough", :patient_type=>"adult")
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
nausea_or_vomiting_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Nausea of Vomiting", :patient_type=>"adult")
neck_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Neck Pain", :patient_type=>"adult")
numbness_in_hands_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Numbness in Hands", :patient_type=>"adult")
pelvic_pain_female_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Pelvic Pain (Female)", :patient_type=>"adult")
pelvic_pain_male_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Pelvic Pain (Male)", :patient_type=>"adult")
shortness_of_breath_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Shortness of Breath", :patient_type=>"adult")
shoulder_pain_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Shoulder Pain", :patient_type=>"adult")
sore_throat_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Sore Throat", :patient_type=>"adult")
urinary_problems_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Urinary Problems", :patient_type=>"adult")
vision_problems_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Vision Problems", :patient_type=>"adult")
wheezing_symptom = Symptom.find_or_create_by_name_and_patient_type(:name=>"Wheezing", :patient_type=>"adult")


#SymptomsFactor

## ABDOMINAL PAIN - ADULT
## #################################################################################################################################################
abdominal_pain_abdominal_swelling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>abdominal_swelling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>black_or_bloody_stool_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_constipation_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>constipation_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_diarrhea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>diarrhea_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_inability_to_move_bowels_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>inability_to_move_bowels_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_nausea_or_vomiting_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_passing_gas_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>passing_gas_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_pulsing_near_navel_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>pulsing_near_navel_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_rash_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>rash_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_stomach_growling_or_rumbling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>stomach_growling_or_rumbling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_unintended_weight_loss_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
abdominal_pain_acute_began_suddenly_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>acute_began_suddenly_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_burning_factor_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>burning_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_chronic_ongoing_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>chronic_ongoing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_crampy_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>crampy_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_dull_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>dull_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_gnawing_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>gnawing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_intense_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>intense_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_intermittent_episodic_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>intermittent_episodic_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_progressive_or_worsening_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>progressive_or_worsening_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_sharp_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>sharp_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_steady_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>steady_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
abdominal_pain_abdomen_but_radiates_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>abdomen_but_radiates_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
abdominal_pain_lower_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>lower_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
abdominal_pain_middle_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>middle_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
abdominal_pain_one_or_both_sides_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>one_or_both_sides_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
abdominal_pain_upper_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>upper_abdomen_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
abdominal_pain_antacids_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>antacids_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_avoiding_certain_foods_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>avoiding_certain_foods_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_changing_position_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>changing_position_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_drinking_more_water_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>drinking_more_water_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_eating_certain_foods_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_eating_more_fibre_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>eating_more_fibre_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
abdominal_pain_coughing_or_jarring_movements_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>coughing_or_jarring_movements_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
abdominal_pain_drinking_alcohol_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>drinking_alcohol_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
abdominal_pain_menstrual_cycle_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>menstrual_cycle_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
abdominal_pain_stress_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>stress_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
## Blood in Stool - ADULT
## ##################################################################################################################################
blood_stool_abdominal_pain_or_cramping_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>abdominal_pain_or_cramping_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_anal_itching_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>anal_itching_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_change_in_bowel_habits_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>change_in_bowel_habits_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_constipation_factor_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>constipation_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_diarrhea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>diarrhea_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_fatigue_or_weakness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>fatigue_or_weakness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_frequent_urge_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>frequent_urge_to_have_bowel_movement_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_narrow_stools_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>narrow_stools_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_nausea_or_vomiting_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_painful_bowel_movements_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>painful_bowel_movements_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_rectal_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>rectal_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_unintended_weight_loss_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
blood_stool_in_or_on_stool_blood_appears_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>in_or_on_stool_factor.id,
  :factor_group_id=>blood_appears_factor_group.id
)
blood_stool_in_or_on_toilet_bowl_blood_appears_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>in_or_on_toilet_bowl_factor.id,
  :factor_group_id=>blood_appears_factor_group.id
)
blood_stool_drinking_more_water_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>drinking_more_water_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
blood_stool_eating_certain_foods_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
blood_stool_eating_more_fibre_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>eating_more_fibre_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
blood_stool_drinking_alcohol_or_caffenine_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>drinking_alcohol_or_caffenine_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
blood_stool_eating_certain_foods_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
blood_stool_straining_during_bowel_movements_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>straining_during_bowel_movements_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
## Chest Pain - ADULT
## #############################
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>anxiety_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>belching_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>cough_with_blood_phlegm_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>difficult_or_painful_swallowing_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>dry_cough_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>fainting_or_dizziness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>headache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>pain_in_neck_jaw_arms_shoulders_back_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rapid_or_irregular_heartbeat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rash_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sweating_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>achy_or_gnawing_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>intermittent_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>severe_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sharp_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>squeezing_or_pressure_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sudden_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>tearing_or_ripping_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>tight_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>antacids_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>bending_forward_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rest_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>eating_or_drinking_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>exertion_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>injury_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>injury_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>lying_down_for_a_long_period_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>pressing_on_chest_wall_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>stress_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>taking_a_deep_breath_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)



#########################################
##
##
##  Content and Symptoms Factors
##
##
#########################################

#Abdominal Pain - DS01194
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01194').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01194').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_pulsing_near_navel_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01194').first.id
)
#Abdominal Pain - DS00274
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_lower_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_one_or_both_sides_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_coughing_or_jarring_movements_triggered_or_worsened_by_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id,
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id, 
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00274').first.id
)
#Abdominal Pain - DS00319
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stomach_growling_or_rumbling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00319').first.id
)
#Abdominal Pain - DS01153
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS01153').first.id
)
#Abdominal Pain - DS00035
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_progressive_or_worsening_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
#Abdominal Pain - DS00063
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_more_fibre_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_more_water_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
#Abdominal Pain - DS00104
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
#Abdominal Pain - DS00292
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00292').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00292').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00292').first.id
)
#Abdominal Pain - DS00070
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_coughing_or_jarring_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
#Abdominal Pain - DS00289
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_lower_abdomen_pain_located_SF,
:content_id=>Content.where(:mayo_doc_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_menstrual_cycle_triggered_or_worsened_by_SF,
:content_id=>Content.where(:mayo_doc_id=>'DS00289').first.id
)
#Abdominal Pain - DS00981
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00981').first.id
)
#Abdominal Pain - DS00165
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=> abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00165').first.id
)
#Abdominal Pain - DS00080
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00080').first.id
)
#Abdominal Pain - DS00488
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_alcohol_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
#Abdominal Pain - DS00823
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00823').first.id
)
#Abdominal Pain - DS00106
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00106').first.id
)
#Abdominal Pain - DS00282
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_one_or_both_sides_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00282').first.id
)
#Abdominal Pain - DS00530
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stomach_growling_or_rumbling_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00530').first.id
)
#Abdominal Pain - DS00506
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_menstrual_cycle_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00506').first.id
)
#Abdominal Pain - DS00524
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_antacids_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00524').first.id
)
#Abdominal Pain - DS00371
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_changing_position_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00371').first.id
)
#Abdominal Pain - DS00242
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_progressive_or_worsening_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_alcohol_triggered_or_worsened_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_antacids_relieved_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
#Abdominal Pain - DS00098
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00098').first.id
)
#Abdominal Pain - DS00598
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_inability_to_move_bowels_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
#Abdominal Pain - DS00085
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00085').first.id
)
#BLOOD IN STOOL - DS00762
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_straining_during_bowel_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00762').first.id
)
#BLOOD IN STOOL - DS00035
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_narrow_stools_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00035').first.id
)
#BLOOD IN STOOL - DS00511
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_narrow_stools_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00511').first.id
)
#BLOOD IN STOOL - DS00063
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_more_water_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_more_fibre_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00063').first.id
)
#BLOOD IN STOOL - DS00104
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id ,
:content_id=>Content.where(:mayo_doc_id=>'DS00104').first.id
)
#BLOOD IN STOOL - DS00070
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00070').first.id
)
#BLOOD IN STOOL - DS00488
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_alcohol_or_caffenine_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00488').first.id
)
#BLOOD IN STOOL - DS00096
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_straining_during_bowel_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_anal_itching_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00096').first.id
)
#BLOOD IN STOOL - DS00459
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00459').first.id
)
#BLOOD IN STOOL - DS00242
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_alcohol_or_caffenine_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00242').first.id
)
#BLOOD IN STOOL - DS00705
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00705').first.id
)
#BLOOD IN STOOL - DS00598
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:mayo_doc_id=>'DS00598').first.id
)

########################################################################
#
# DO NOT PUT ANY CONTENT AT BOTTOM OF THIS FILE. GO BEFORE SYMPTOMS CHECKER
#
#########################################################################

