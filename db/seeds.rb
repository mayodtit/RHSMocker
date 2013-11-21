#encoding: utf-8

Content.upsert_attributes({title: 'Welcome to Better!'},
                          {type: 'CustomContent',
                           content_type: 'Content',
                           raw_body: 'Thank you for installing Better!',
                           document_id: 'RHS0000',
                           show_call_option: false,
                           show_checker_option: false,
                           show_mayo_copyright: false})

Question.upsert_attributes({:view => :gender}, {:title => 'Your Gender'})
Question.upsert_attributes({:view => :allergies}, {:title => 'Your Allergies'})
Question.upsert_attributes({:view => :diet}, {:title => 'Which of these do you eat?'})

# Create some default Members
#nancy  = Member.create!(first_name: "Nancy", last_name: "Smith",   gender:"F", birth_date:"06/18/1950", install_id: "123345")
#bob  = Member.create!(first_name: "Bob",   last_name: "Jones",   gender:"M", birth_date:"01/10/1973", install_id: "122233")
#limburg = Member.create!(first_name: "Paul",   last_name: "Limburg", gender:"M", install_id: "144444")
#shelly  = Member.create!(first_name: "Shelly",last_name: "Norman",   gender:"F", install_id: "555555")

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

o = Offering.find_or_create_by_name(name: 'Consult')
p = Plan.find_or_create_by_name(name: 'Silver', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 2, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Gold', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: 3, unlimited: false)
p = Plan.find_or_create_by_name(name: 'Platinum', monthly: true)
PlanOffering.find_or_create_by_plan_id_and_offering_id(plan_id: p.id, offering_id: o.id, amount: nil, unlimited: true)

Agreement.find_or_create_by_type(type: :terms_of_service, active: true, text: 'Seeded test agreement')

########################################################################
#
# ONLY SYMTPOMS CHECKER CONTENT AFTER THIS LINE!
#
#########################################################################

############## CLEAR OUT EXISTING DATA
ContentsSymptomsFactor.delete_all
SymptomMedicalAdviceItem.delete_all
SymptomMedicalAdvice.delete_all
SymptomSelfcare.delete_all
SymptomSelfcareItem.delete_all
SymptomsFactor.delete_all
FactorGroup.delete_all
Factor.delete_all


#FactorGroup
accompanied_by_factor_group           = FactorGroup.find_or_create_by_name(:name=>"Accompanied by")
appearance_of_eye_factor_group        = FactorGroup.find_or_create_by_name(:name=>"Appearance of eye includes")
blood_appears_factor_group            = FactorGroup.find_or_create_by_name(:name=>"Blood appears")
cough_is_factor_group                 = FactorGroup.find_or_create_by_name(:name=>"Cough is")
duration_is_factor_group              = FactorGroup.find_or_create_by_name(:name=>"Duration is")
duration_of_headache_is_factor_group  = FactorGroup.find_or_create_by_name(:name=>"Duration of headache is")
eye_discomfort_described_as_factor_group = FactorGroup.find_or_create_by_name(:name=>"Eye discomfort best described as")
heart_rate_is_factor_group             = FactorGroup.find_or_create_by_name(:name=>"Heart rate is")
located_factor_group                   = FactorGroup.find_or_create_by_name(:name=>"Located")
located_in_factor_group                = FactorGroup.find_or_create_by_name(:name=>"Located in")
nasal_congestion_is_factor_group       = FactorGroup.find_or_create_by_name(:name=>"Nasal congestion is")
nasal_discharge_is_factor_group        = FactorGroup.find_or_create_by_name(:name=>"Nasal discharge is")
numbness_or_tingling_is_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Numbness or tingling")
onset_factor_group                     = FactorGroup.find_or_create_by_name(:name=>"Onset")
onset_is_factor_group                  = FactorGroup.find_or_create_by_name(:name=>"Onset is")
pain_factor_group                      = FactorGroup.find_or_create_by_name(:name=>"Pain")
pain_best_described_as_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Pain best described as")
pain_is_factor_group                   = FactorGroup.find_or_create_by_name(:name=>"Pain is")
pain_located_factor_group             = FactorGroup.find_or_create_by_name(:name=>"Pain located")
pain_located_in_factor_group             = FactorGroup.find_or_create_by_name(:name=>"Pain located in")
pain_started_factor_group              = FactorGroup.find_or_create_by_name(:name=>"Pain started")
palpitations_often_occur_when_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Palpitations often occur when")
preceded_by_factor_group               = FactorGroup.find_or_create_by_name(:name=>"Preceded by")
preceded_by_use_of_factor_group        = FactorGroup.find_or_create_by_name(:name=>"Preceded by use of")
problem_affects_factor_group           = FactorGroup.find_or_create_by_name(:name=>"Problem affects")
problem_is_factor_group                = FactorGroup.find_or_create_by_name(:name=>"Problem is")
recurrence_of_headache_factor_group    = FactorGroup.find_or_create_by_name(:name=>"Recurrence of headache")
related_pain_involves_factor_group     = FactorGroup.find_or_create_by_name(:name=>"Related pain involves")
relieved_by_factor_group               = FactorGroup.find_or_create_by_name(:name=>"Relieved by")
swallowing_factor_group                = FactorGroup.find_or_create_by_name(:name=>"Swallowing")
swelling_occurs_factor_group           = FactorGroup.find_or_create_by_name(:name=>"Swelling occurs")
symptoms_are_factor_group              = FactorGroup.find_or_create_by_name(:name=>"Symptoms are")
triggered_by_factor_group              = FactorGroup.find_or_create_by_name(:name=>"Triggered by")
triggered_or_worsened_by_factor_group  = FactorGroup.find_or_create_by_name(:name=>"Triggered or worsened by")
vision_improves_somewhat_factor_group  = FactorGroup.find_or_create_by_name(:name=>"Vision improves somewhat with")
vision_problem_includes_factor_group   = FactorGroup.find_or_create_by_name(:name=>"Vision problem includes")
wheezing_is_factor_group               = FactorGroup.find_or_create_by_name(:name=>"Wheezing is")
worsened_by_factor_group               = FactorGroup.find_or_create_by_name(:name=>"Worsened by")
you_feel_factor_group                  = FactorGroup.find_or_create_by_name(:name=>"You feel")

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
black_or_bloody_stool_factor              = Factor.find_or_create_by_name(:name=>"Black or bloody stools")
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
bumps_blisters_or_open_sores_factor     = Factor.find_or_create_by_name(:name=>"Bumps, blisters or open sores")
bumps_blisters_or_open_sores_factor_genitals_factor = Factor.find_or_create_by_name(:name=>"Bumps, blisters or open sores around genitals")
burning_factor                          = Factor.find_or_create_by_name(:name=>"Burning")
burning_pain_factor                     = Factor.find_or_create_by_name(:name=>"Burning pain")
buzzing_or_ringing_in_ear_factor        = Factor.find_or_create_by_name(:name=>"Buzzing or ringing in ear")
caffeine_or_alcohol_factor              = Factor.find_or_create_by_name(:name=>"Caffeine or alcohol")
clenching_grinding_teeth_factor         = Factor.find_or_create_by_name(:name=>"Clenching or grinding teeth")
cigarettes_or_recreational_drugs_factor = Factor.find_or_create_by_name(:name=>"Cigarettes or recreational drugs")
change_in_bowel_habits_factor           = Factor.find_or_create_by_name(:name=>"Change in your bowel habits")
changing_position_factor                = Factor.find_or_create_by_name(:name=>"Changing position")
change_sleep_patterns_factor            = Factor.find_or_create_by_name(:name=>"Change in sleep patterns")
change_personality_factor               = Factor.find_or_create_by_name(:name=>"Change in personality, behaviors or mental status")
chest_pain_or_tightness_factor          = Factor.find_or_create_by_name(:name=>"Chest pain or tightness")
chest_pain_or_pressure_factor           = Factor.find_or_create_by_name(:name=>"Chest pain or pressure")
chest_pain_or_discomfort_factor         = Factor.find_or_create_by_name(:name=>"Chest pain or discomfort")
chewing_factor                          = Factor.find_or_create_by_name(:name=>"Chewing")
chills_or_sweating_factor               = Factor.find_or_create_by_name(:name=>"Chills or sweating")
chronic_ongoing_factor                  = Factor.find_or_create_by_name(:name=>"Chronic, ongoing")
constipation_factor                     = Factor.find_or_create_by_name(:name=>"Constipation")
crampy_factor                           = Factor.find_or_create_by_name(:name=>"Crampy")
cramping_factor                         = Factor.find_or_create_by_name(:name=>"Cramping")
crusted_eyelashes_after_sleeping        = Factor.find_or_create_by_name(:name=>"Crusted eyelashes after sleeping")
confusion_factor                        = Factor.find_or_create_by_name(:name=>"Confusion")
cough_factor                            = Factor.find_or_create_by_name(:name=>"Cough")
coughing_or_jarring_movements_factor    = Factor.find_or_create_by_name(:name=>"Coughing or jarring movements")
cough_with_blood_phlegm_factor          = Factor.find_or_create_by_name(:name=>"Cough with blood or phlegm")
dark_floating_spots_in_vision_factor    = Factor.find_or_create_by_name(:name=>"Dark, floating spots in vision")
diarrhea_factor                         = Factor.find_or_create_by_name(:name=>"Diarrhea")
decreased_range_motion_factor           = Factor.find_or_create_by_name(:name=>"Decreased range of motion")
difficult_or_painful_swallowing_factor  = Factor.find_or_create_by_name(:name=>"Difficult or painful swallowing")
difficulty_breathing_factor             = Factor.find_or_create_by_name(:name=>"Difficulty breathing")
difficulty_pushing_off_with_toes_factor = Factor.find_or_create_by_name(:name=>"Difficulty pushing off with toes")
difficulty_swallowing_factor            = Factor.find_or_create_by_name(:name=>"Difficulty swallowing")
difficulty_speaking_factor              = Factor.find_or_create_by_name(:name=>"Difficulty speaking")
dizziness_or_lightheadedness_factor     = Factor.find_or_create_by_name(:name=>"Dizziness or lightheadedness")
drinking_alcohol_factor                 = Factor.find_or_create_by_name(:name=>"Drinking alcohol")
drinking_alcohol_or_caffeine_factor     = Factor.find_or_create_by_name(:name=>"Drinking alcohol or caffeine")
drinking_more_water_factor              = Factor.find_or_create_by_name(:name=>"Drinking more water")
dry_factor                              = Factor.find_or_create_by_name(:name=>"Dry")
dry_cough_factor                        = Factor.find_or_create_by_name(:name=>"Dry cough")
dry_eyes_factor                         = Factor.find_or_create_by_name(:name=>"Dry eyes")
dry_mouth_factor                        = Factor.find_or_create_by_name(:name=>"Dry mouth")
dry_or_itchy_factor                     = Factor.find_or_create_by_name(:name=>"Dry or itchy")
dry_warm_air_factor                     = Factor.find_or_create_by_name(:name=>"Dry, warm air")
dull_factor                             = Factor.find_or_create_by_name(:name=>"Dull")
dull_achy_factor                        = Factor.find_or_create_by_name(:name=>"Dull or achy")
earache_factor                          = Factor.find_or_create_by_name(:name=>"Earache")
ear_pain_or_pressure_factor             = Factor.find_or_create_by_name(:name=>"Ear pain or pressure")
easy_bruising_or_bleeding_factor        = Factor.find_or_create_by_name(:name=>"Easy bruising or bleeding")
eating_or_drinking_factor               = Factor.find_or_create_by_name(:name=>"Eating or drinking")
eating_more_fibre_factor                = Factor.find_or_create_by_name(:name=>"Eating more fiber")
eating_certain_foods_factor             = Factor.find_or_create_by_name(:name=>"Eating certain foods")
enlarged_or_purplish_vein_factor        = Factor.find_or_create_by_name(:name=>"Enlarged or purplish vein in affected leg")
entire_leg_or_calf_being_pale_and_cool_factor = Factor.find_or_create_by_name(:name=>"Entire leg or calf being pale and cool")
eye_movement_factor                     = Factor.find_or_create_by_name(:name=>"Eye Movement")
everday_act_factor                      = Factor.find_or_create_by_name(:name=>"Everyday activities")
excessive_tearing_factor                = Factor.find_or_create_by_name(:name=>"Excessive tearing")
exertion_factor                         = Factor.find_or_create_by_name(:name=>"Exertion")
extreme_factor                          = Factor.find_or_create_by_name(:name=>"Extreme")
facial_numbness_factor                  = Factor.find_or_create_by_name(:name=>"Facial Numbness")
faster_than_normal_factor               = Factor.find_or_create_by_name(:name=>"Faster than normal")
fainting_factor                         = Factor.find_or_create_by_name(:name=>"Fainting")
fainting_or_dizziness_factor            = Factor.find_or_create_by_name(:name=>"Fainting or dizziness")
fatigue_factor                          = Factor.find_or_create_by_name(:name=>"Fatigue")
fatigue_or_weakness_factor              = Factor.find_or_create_by_name(:name=>"Fatigue or weakness")
feeling_somthing_stuck_throat_factor    = Factor.find_or_create_by_name(:name=>"Feeling of something stuck in your throat")
feeling_of_instability_factor           = Factor.find_or_create_by_name(:name=>"Feeling of instability")
fever_factor                            = Factor.find_or_create_by_name(:name=>"Fever")
fever_chills_factor                     = Factor.find_or_create_by_name(:name=>"Fever or chills")
flattened_arch_factor                   = Factor.find_or_create_by_name(:name=>"Flattened arch")
frequent_urge_to_have_bowel_movement_factor  = Factor.find_or_create_by_name(:name=>"Frequent urge to have bowel movement")
gas_factor                                = Factor.find_or_create_by_name(:name=>"Gas")
gnawing_factor                            = Factor.find_or_create_by_name(:name=>"Gnawing")
gritty_sensation_factor                   = Factor.find_or_create_by_name(:name=>"Gritty sensation")
gradually_becomes_frequent_factor         = Factor.find_or_create_by_name(:name=>"Gradually becomes more frequent")
gradually_worsening_factor                = Factor.find_or_create_by_name(:name=>"Gradually worsening")
grating_sensation_factor                  = Factor.find_or_create_by_name(:name=>"Grating sensation")
halos_around_lights_factor                = Factor.find_or_create_by_name(:name=>"Halos around lights")
hardening_of_skin_in_affected_area_factor = Factor.find_or_create_by_name(:name=>"Hardening of skin in affected area")
have_something_stuck_in_your_throat_factor= Factor.find_or_create_by_name(:name=>"Have something stuck in your throat")
have_trouble_breathing_factor             = Factor.find_or_create_by_name(:name=>"Have trouble breathing")
headache_factor                           = Factor.find_or_create_by_name(:name=>"Headache")
headache_or_facial_pain_factor            = Factor.find_or_create_by_name(:name=>"Headache or facial pain")
hearing_loss_factor                       = Factor.find_or_create_by_name(:name=>"Hearing loss")
heartburn_factor                          = Factor.find_or_create_by_name(:name=>"Heartburn")
heaviness_in_affected_limb_factor         = Factor.find_or_create_by_name(:name=>"Heaviness in affected limb")
heel_factor                               = Factor.find_or_create_by_name(:name=>"Heel")
high_fever_factor                         = Factor.find_or_create_by_name(:name=>"High or persistent fever")
hives_or_rash_factor                      = Factor.find_or_create_by_name(:name=>"Hives or rash")
hoarse_or_muffled_voice_factor            = Factor.find_or_create_by_name(:name=>"Hoarse or muffled voice")
hoarse_voice_factor                       = Factor.find_or_create_by_name(:name=>"Hoarse voice")
hoarse_voice_for_more_than_week_factor    = Factor.find_or_create_by_name(:name=>"Hoarse voice for more than one week")
hoarse_voice_or_difficulty_speaking_factor= Factor.find_or_create_by_name(:name=>"Hoarse voice or difficulty speaking")
holding_objects_away_factor               = Factor.find_or_create_by_name(:name=>"Holding objects away from face")
holding_objects_close_factor              = Factor.find_or_create_by_name(:name=>"Holding objects close to face")
hormonal_changes_factor                   = Factor.find_or_create_by_name(:name=>"Hormonal changes")
hurts_factor                              = Factor.find_or_create_by_name(:name=>"Hurts")
ill_fitting_shoes_factor                  = Factor.find_or_create_by_name(:name=>"Ill-fitting shoes")
in_both_limbs_factor                      = Factor.find_or_create_by_name(:name=>"In both limbs")
in_knee_joint_factor                      = Factor.find_or_create_by_name(:name=>"In the knee joint")
in_one_limb_factor                        = Factor.find_or_create_by_name(:name=>"In one limb")
in_or_on_stool_factor                     = Factor.find_or_create_by_name(:name=>"In or on the stool")
in_or_on_toilet_bowl_factor               = Factor.find_or_create_by_name(:name=>"In toilet bowl or on toilet tissue")
inactivity_or_long_periods_rest_factor    = Factor.find_or_create_by_name(:name=>"Inactivity or long periods of rest")
increased_sensitivity_to_cold_factor      = Factor.find_or_create_by_name(:name=>"Increased sensitivity to cold")
intense_factor                            = Factor.find_or_create_by_name(:name=>"Intense")
intermittent_factor                       = Factor.find_or_create_by_name(:name=>"Intermittent")
intermittent_episodic_factor              = Factor.find_or_create_by_name(:name=>"Intermittent, episodic")
inability_to_bear_weight_factor           = Factor.find_or_create_by_name(:name=>"Inability to bear weight")
inability_to_move_bowels_factor           = Factor.find_or_create_by_name(:name=>"Inability to move bowels")
inability_to_point_forefoot_and_toes_down_factor = Factor.find_or_create_by_name(:name=>"Inability to point forefoot and toes down")
injury_factor                             = Factor.find_or_create_by_name(:name=>"Injury")
injury_trauma_factor                      = Factor.find_or_create_by_name(:name=>"Injury or trauma")
irregular_heartbeat_factor                = Factor.find_or_create_by_name(:name=>"Irregular heartbeat")
irregular_or_not_steady_factor            = Factor.find_or_create_by_name(:name=>"Irregular or not steady")
is_daily_factor                           = Factor.find_or_create_by_name(:name=>"Is daily")
is_gradual_factor                         = Factor.find_or_create_by_name(:name=>"Is gradual")
is_often_at_same_time_factor              = Factor.find_or_create_by_name(:name=>"Is often the same time every day")
is_preceded_by_meds_factor  = Factor.find_or_create_by_name(:name=>"Is preceded by frequent use of pain medication")
is_preceded_by_visual_factor = Factor.find_or_create_by_name(:name=>"Is preceded by visual or other sensory disturbances") 
is_sudden_factor                          = Factor.find_or_create_by_name(:name=>"Is sudden")
jaw_pain_factor                           = Factor.find_or_create_by_name(:name=>"Jaw pain")
jaw_pain_or_stiffness_factor              = Factor.find_or_create_by_name(:name=>"Jaw pain or stiffness")
joint_deformity_factor                    = Factor.find_or_create_by_name(:name=>"Joint deformity")
lack_appetite_factor                      = Factor.find_or_create_by_name(:name=>"Lack of appetite")
large_amounts_blood_factor                = Factor.find_or_create_by_name(:name=>"Large amounts of blood")
less_than_few_minutes_factor              = Factor.find_or_create_by_name(:name=>"Less than a few minutes")
lightheadedness_factor                    = Factor.find_or_create_by_name(:name=>"Lightheadedness")
lightneadedned_or_faint_factor            = Factor.find_or_create_by_name(:name=>"Lightheaded or faint")
locking_or_catching_factor                = Factor.find_or_create_by_name(:name=>"Locking or catching")
lower_abdomen_factor                      = Factor.find_or_create_by_name(:name=>"Lower abdomen")
long_periods_of_rest_factor               = Factor.find_or_create_by_name(:name=>"Long periods of rest")
loss_of_appetite_factor                   = Factor.find_or_create_by_name(:name=>"Loss of appetite")
loss_of_color_vision                      = Factor.find_or_create_by_name(:name=>"Loss of color vision")
loose_teeth_or_poorly_fitting_dentures    = Factor.find_or_create_by_name(:name=>"Loose teeth or poorly fitting dentures")
lump_in_front_of_neck_factor              = Factor.find_or_create_by_name(:name=>"Lump in front of neck")
lying_down_for_a_long_period_factor       = Factor.find_or_create_by_name(:name=>"Lying down for a long period")
lying_down_dark_factor                    = Factor.find_or_create_by_name(:name=>"Lying down in the dark")
medications_or_herbal_supplements_factor  = Factor.find_or_create_by_name(:name=>"Medications or herbal supplements")
mouth_sores_lumps_or_pain_factor          = Factor.find_or_create_by_name(:name=>"Mouth sores, lumps or pain")
moderate_to_severe_factor                 = Factor.find_or_create_by_name(:name=>"Moderate to severe")
movement_factor                           = Factor.find_or_create_by_name(:name=>"Movement")
middle_abdomen_factor                     = Factor.find_or_create_by_name(:name=>"Middle abdomen")
middle_part_of_foot_factor                = Factor.find_or_create_by_name(:name=>"Middle part of foot")
mild_to_moderate_factor                   = Factor.find_or_create_by_name(:name=>"Mild to moderate")
muscle_aches_factor                       = Factor.find_or_create_by_name(:name=>"Muscle aches")
muscle_or_joint_aches_factor              = Factor.find_or_create_by_name(:name=>"Muscle or joint aches")
muscle_cramps_or_twitching_factor         = Factor.find_or_create_by_name(:name=>"Muscle cramps or twitching in arms, shoulders, or tongue")
muscle_weakness_factor                    = Factor.find_or_create_by_name(:name=>"Muscle weakness")
muscle_weakness_hands_legs_factor         = Factor.find_or_create_by_name(:name=>"Muscle weakness in hands, feet or legs")
mucus_in_stools_factor                    = Factor.find_or_create_by_name(:name=>"Mucus in stools")
menstrual_cycle_factor                    = Factor.find_or_create_by_name(:name=>"Menstrual cycle")
narrow_stools_factor                      = Factor.find_or_create_by_name(:name=>"Narrow stools")
nausea_factor                             = Factor.find_or_create_by_name(:name=>"Nausea")
nausea_or_vomiting_factor                 = Factor.find_or_create_by_name(:name=>"Nausea or vomiting")
nervousness_factor                        = Factor.find_or_create_by_name(:name=>"Nervousness")
new_or_began_recently_factor              = Factor.find_or_create_by_name(:name=>"New or began recently")
new_or_began_suddenly_factor              = Factor.find_or_create_by_name(:name=>"New or began suddenly")
numbness_or_tingling_factor               = Factor.find_or_create_by_name(:name=>"Numbness or tingling")
numbness_pain_color_factor                = Factor.find_or_create_by_name(:name=>"Numbness, pain and color changes in fingers")
numbness_or_weakness_one_side             = Factor.find_or_create_by_name(:name=>"Numbness or weakness on one side of body")
orgasm_factor                             = Factor.find_or_create_by_name(:name=>"Orgasm")
on_both_sides_of_head_factor              = Factor.find_or_create_by_name(:name=>"On both sides of your head")
on_one_side_of_head_factor                = Factor.find_or_create_by_name(:name=>"On one side of your head")
ongoing_or_recurrent_factor               = Factor.find_or_create_by_name(:name=>"Ongoing or recurrent")
one_or_both_sides_factor                  = Factor.find_or_create_by_name(:name=>"One or both sides")
over_the_counter_meds_factor              = Factor.find_or_create_by_name(:name=>"Over-the-counter pain medication")
overuse_factor                            = Factor.find_or_create_by_name(:name=>"Overuse")
radiates_from_abdomen_factor              = Factor.find_or_create_by_name(:name=>"Radiates from abdomen")
rapid_heart_rate_factor                   = Factor.find_or_create_by_name(:name=>"Rapid heart rate")
rash_factor                               = Factor.find_or_create_by_name(:name=>"Rash")
recent_factor                             = Factor.find_or_create_by_name(:name=>"Recent")
recent_day_week_factor                    = Factor.find_or_create_by_name(:name=>"Recent (days to weeks)")
recently_factor                           = Factor.find_or_create_by_name(:name=>"Recently")
recurrent_or_ongoing_factor               = Factor.find_or_create_by_name(:name=>"Recurrent or ongoing")
rectal_pain_factor                        = Factor.find_or_create_by_name(:name=>"Rectal pain")
redness_factor                            = Factor.find_or_create_by_name(:name=>"Redness")
redness_or_warmth_factor                  = Factor.find_or_create_by_name(:name=>"Redness or warmth in affected area")
redness_without_discomfort_factor           = Factor.find_or_create_by_name(:name=>"Redness without actual discomfort")
red_painful_lump_on_eyelid                  = Factor.find_or_create_by_name(:name=>"Red, painful lump on the eyelid")
regurgitation_food_liquid_factor            = Factor.find_or_create_by_name(:name=>"Regurgitation of food or sour liquid")
rest_factor                                 = Factor.find_or_create_by_name(:name=>"Rest")
rest_or_inactivity_factor                   = Factor.find_or_create_by_name(:name=>"Rest or inactivity")
restlessness_or_agitation_factor            = Factor.find_or_create_by_name(:name=>"Restlessness or agitation")
rapid_or_irregular_heartbeat_factor         = Factor.find_or_create_by_name(:name=>"Rapid or irregular heartbeat")
runny_or_stuffy_nose_factor                 = Factor.find_or_create_by_name(:name=>"Runny or stuffy nose")
pale_dry_skin_factor                        = Factor.find_or_create_by_name(:name=>"Pale, dry skin")
pain_in_neck_jaw_arms_shoulders_back_factor = Factor.find_or_create_by_name(:name=>"Pain in neck, jaw, arms, shoulders or back")
preceded_by_eating_suspect_food_factor      = Factor.find_or_create_by_name(:name=>"Preceded by eating suspect food")
preceded_by_recent_antibiotic_use_factor    = Factor.find_or_create_by_name(:name=>"Preceded by recent antibiotic use")
pressing_on_chest_wall_factor               = Factor.find_or_create_by_name(:name=>"Pressing on chest wall")
prolonged_sitting_standing_factor = Factor.find_or_create_by_name(:name=>"Prolonged sitting or standing")
passing_gas_factor                          = Factor.find_or_create_by_name(:name=>"Passing gas")
pain_tenderness_aching_factor               = Factor.find_or_create_by_name(:name=>"Pain, tenderness or aching in affected area")
pain_from_accident_or_injury_factor         = Factor.find_or_create_by_name(:name=>"Pain from accident or injury")
pain_in_other_joints_factor                 = Factor.find_or_create_by_name(:name=>"Pain in other joints")
pain_stiffness_in_other_joints_factor       = Factor.find_or_create_by_name(:name=>"Pain or stiffness in other joints")
pain_in_chest_neck_factor                   = Factor.find_or_create_by_name(:name=>"Pain in chest or back")
pain_in_chest_neck_shoulder_factor          = Factor.find_or_create_by_name(:name=>"Pain in chest, neck, shoulder")
pain_in_chest_neck_shoulder_arm_factor      = Factor.find_or_create_by_name(:name=>"Pain in chest, neck, arm shoulder")
painful_bowel_movements_factor              = Factor.find_or_create_by_name(:name=>"Painful bowel movements")
persistent_cough_factor                     = Factor.find_or_create_by_name(:name=>"Persistent cough")
persistent_nausea_or_vomiting_factor        = Factor.find_or_create_by_name(:name=>"Persistent nausea or vomiting")
persistent_weakness_or_numbness_factor      = Factor.find_or_create_by_name(:name=>"Persistent weakness or numbness")
pulsing_near_navel_factor                   = Factor.find_or_create_by_name(:name=>"Pulsing near navel")
poor_posture_factor                         = Factor.find_or_create_by_name(:name=>"Poor posture")
popping_snapping_factor  = Factor.find_or_create_by_name(:name=>"Popping or snapping")
pressure_or_squeezing_factor                = Factor.find_or_create_by_name(:name=>"Pressure or squeezing sensation")
producing_phlegm_or_sputum_factor           = Factor.find_or_create_by_name(:name=>"Producing phlegm or sputum")
progressive_or_worsening_factor             = Factor.find_or_create_by_name(:name=>"Progressive or worsening")
sitting_or_standing_still_factor            = Factor.find_or_create_by_name(:name=>"Sitting or standing still for long periods")
sharp_factor                                = Factor.find_or_create_by_name(:name=>"Sharp")
sharp_severe_factor                         = Factor.find_or_create_by_name(:name=>"Sharp or severe")
short_of_breath_or_dizzy_factor             = Factor.find_or_create_by_name(:name=>"Short of breath or dizzy")
shortness_of_breath_factor    = Factor.find_or_create_by_name(:name=>"Shortness of breath")
shimmering_or_flash_of_light_factor = Factor.find_or_create_by_name(:name=>"Shimmering or flash of light")
seizures_factor               = Factor.find_or_create_by_name(:name=>"Seizures")
sensitivity_to_light          = Factor.find_or_create_by_name(:name=>"Sensitivity to light")
sensitivity_to_light_noise_factor = Factor.find_or_create_by_name(:name=>"Sensitivity to light or noise")
several_hours_to_days_factor  = Factor.find_or_create_by_name(:name=>"Several hours to several days")
several_minutes_to_few_hours_factor  = Factor.find_or_create_by_name(:name=>"Several minutes to a few hours")
severe_factor                 = Factor.find_or_create_by_name(:name=>"Severe")
severe_headache_factor        = Factor.find_or_create_by_name(:name=>"Severe headache")
severe_pain_factor            = Factor.find_or_create_by_name(:name=>"Severe pain")
sore_throat_factor            = Factor.find_or_create_by_name(:name=>"Sore throat")
skin_redness_factor = Factor.find_or_create_by_name(:name=>"Skin redness")
squeezing_or_pressure_factor  = Factor.find_or_create_by_name(:name=>"Squeezing or pressure")
sneezing_factor               = Factor.find_or_create_by_name(:name=>"Sneezing")
slurred_speech_factor         = Factor.find_or_create_by_name(:name=>"Slurred speech")
slurred_speech_difficulty_speaking_factor = Factor.find_or_create_by_name(:name=>"Slurred speech or difficulty speaking")
slower_than_normal_factor     = Factor.find_or_create_by_name(:name=>"Slower than normal")
sudden_factor                 = Factor.find_or_create_by_name(:name=>"Sudden")
sudden_intense_factor         = Factor.find_or_create_by_name(:name=>"Sudden and intense")
sudden_hours_days_factor      = Factor.find_or_create_by_name(:name=>"Sudden (hours to days)")
sudden_weight_loss_factor     = Factor.find_or_create_by_name(:name=>"Sudden weight loss")
stabbing_or_burning_factor    = Factor.find_or_create_by_name(:name=>"Stabbing or burning")
steady_factor                               = Factor.find_or_create_by_name(:name=>"Steady")
straining_during_bowel_movements_factor     = Factor.find_or_create_by_name(:name=>"Straining during bowel movements")
stress_factor                               = Factor.find_or_create_by_name(:name=>"Stress")
stiff_neck_factor                           = Factor.find_or_create_by_name(:name=>"Stiff neck")
stomach_growling_or_rumbling_factor         = Factor.find_or_create_by_name(:name=>"Stomach growling or rumbling")
stiffness_factor              = Factor.find_or_create_by_name(:name=>"Stiffness")
stiffness_or_limited_movement_factor = Factor.find_or_create_by_name(:name=>"Stiffness or limited movement")
stinging_or_burning_sensation_factor = Factor.find_or_create_by_name(:name=>"Stinging or burning sensation")
stringy_mucus_in_around_eye_factor = Factor.find_or_create_by_name(:name=>"Stringy mucus in or around the eye")
sweating_factor               = Factor.find_or_create_by_name(:name=>"Sweating")
swelling_factor               = Factor.find_or_create_by_name(:name=>"Swelling")
swelling_around_eye_factor    = Factor.find_or_create_by_name(:name=>"Swelling around the eye")
swelling_around_the_eyes_factor = Factor.find_or_create_by_name(:name=>"Swelling around eyes")
swelling_in_abdomen_other_parts_factor = Factor.find_or_create_by_name(:name=>"Swelling in abdomen or other parts of body")
taking_a_deep_breath_factor   = Factor.find_or_create_by_name(:name=>"Taking a deep breath")
tearing_or_ripping_factor     = Factor.find_or_create_by_name(:name=>"Tearing or ripping")
takes_effort_factor           = Factor.find_or_create_by_name(:name=>"Takes effort")
tender_scalp_factor           = Factor.find_or_create_by_name(:name=>"Tender scalp")
tight_factor                  = Factor.find_or_create_by_name(:name=>"Tight")
tight_hardened_skin           = Factor.find_or_create_by_name(:name=>"Tight, hardened skin")
thick_saliva_factor           = Factor.find_or_create_by_name(:name=>"Thick saliva")
thick_green_or_yellow_phlegm_or_sputum = Factor.find_or_create_by_name(:name=>"Thick green or yellow phlegm or sputum")
thickened_or_rough_skin_factor = Factor.find_or_create_by_name(:name=>"Thickened or rough skin")
throbbing_factor               = Factor.find_or_create_by_name(:name=>"Throbbing")
touching_face_eating_factor    = Factor.find_or_create_by_name(:name=>"Touching your face, eating or other facial movement")
toe_or_front_part_of_foot_factor = Factor.find_or_create_by_name(:name=>"Toe or front part of foot")
tremors_factor                = Factor.find_or_create_by_name(:name=>"Tremors")
trouble_sleeping_factor       = Factor.find_or_create_by_name(:name=>"Trouble sleeping")
upper_abdomen_factor          = Factor.find_or_create_by_name(:name=>"Upper abdomen")
unintended_weight_loss_factor = Factor.find_or_create_by_name(:name=>"Unintended weight loss")
unintended_weight_gain_factor = Factor.find_or_create_by_name(:name=>"Unintended weight gain")
unexplained_fatigue_factor = Factor.find_or_create_by_name(:name=>"Unexplained fatigue") 
unsteady_factor               = Factor.find_or_create_by_name(:name=>"Unsteady")
urgency_to_have_bowel_movement= Factor.find_or_create_by_name(:name=>"Urgency to have a bowel movement")
walking_factor                = Factor.find_or_create_by_name(:name=>"Walking")
warmth_to_touch_factor        = Factor.find_or_create_by_name(:name=>"Warmth to touch")
weakness_factor               = Factor.find_or_create_by_name(:name=>"Weakness")
watery_or_itchy_eyes_factor   = Factor.find_or_create_by_name(:name=>"Watery or itchy eyes")
wheezing_factor               = Factor.find_or_create_by_name(:name=>"Wheezing")
whole_foot_factor             = Factor.find_or_create_by_name(:name=>"Whole foot")
worsening_or_progressing_factor = Factor.find_or_create_by_name(:name=>"Worsening or progressing")
vaguely_uncomfortable_factor  = Factor.find_or_create_by_name(:name=>"Vaguely uncomfortable")
vomiting_blood_factor         = Factor.find_or_create_by_name(:name=>"Vomiting blood")
visible_deformity_factor      = Factor.find_or_create_by_name(:name=>"Visible deformity")
vision_loss_factor            = Factor.find_or_create_by_name(:name=>"Vision loss")
vision_problems_factor        = Factor.find_or_create_by_name(:name=>"Vision problems")
youre_anxious_or_stressed_factor = Factor.find_or_create_by_name(:name=>"You're anxious or stressed")
youre_exerting_factor           = Factor.find_or_create_by_name(:name=>"You're exerting yourself")
youre_resting_going_bed_factor  = Factor.find_or_create_by_name(:name=>"You're resting or going to bed")



#Symptoms - ADULT
##############################
abdominal_pain_symptom  = Symptom.upsert_attributes({:name=>"Abdominal Pain", :patient_type=>"adult"}, 
  {:description=>"Abdominal pain can indicate a wide variety of medical conditions. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"The following self-care tips may be beneficial for mild abdominal pain, but you should still see your doctor for a prompt diagnosis and appropriate treatment."  
  })
abdominal_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following self-care tips may be beneficial for mild abdominal pain, but you should still see your doctor for a prompt diagnosis and appropriate treatment:",
                                                                                  :symptom_id=>abdominal_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid foods that you suspect may cause or worsen symptoms, including alcohol", 
                                          :symptom_selfcare_id=>abdominal_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter antacid as directed on the label", 
                                          :symptom_selfcare_id=>abdominal_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter anti-diarrhea medication as directed on the label if your abdominal pain is accompanied by diarrhea", 
                                          :symptom_selfcare_id=>abdominal_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink plenty of water if your abdominal pain is accompanied by diarrhea or constipation", 
                                          :symptom_selfcare_id=>abdominal_pain_selfcare.id)

abdominal_pain_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Seek emergency care if:",
                                                                                  :symptom_id=>abdominal_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The pain is related to an accident or injury",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You also experience pain in your chest, neck or shoulder",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The pain is accompanied by shortness of breath or dizziness",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You vomit blood",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your stool is black or bloody",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You find blood in your urine",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your abdomen is swollen and tender",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You experience a high fever",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You experience persistent nausea or vomiting",
                                                          :symptom_medical_advice_id=>abdominal_pain_medadvice.id)

blood_in_stool_symptom  = Symptom.upsert_attributes({:name=>"Blood in Stool", :patient_type=>"adult"}, 
  {:description=>"Blood in the stool requires a prompt diagnosis. Identify possible common causes based on symptoms you’re experiencing."})
## NO SELFCARE
blood_in_stool_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Seek medical advice for any blood in stool. Seek emergency medical care if you notice:",
                                                                                  :symptom_id=>blood_in_stool_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Large amounts of blood",
                                                          :symptom_medical_advice_id=>blood_in_stool_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Lightheadedness",
                                                          :symptom_medical_advice_id=>blood_in_stool_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Rapid heart rate",
                                                          :symptom_medical_advice_id=>blood_in_stool_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Weakness",
                                                          :symptom_medical_advice_id=>blood_in_stool_medadvice.id)


chest_pain_symptom      = Symptom.upsert_attributes({:name=>"Chest Pain", :patient_type=>"adult" }, 
  {:description=>"Chest pain can indicate a serious condition. Identify possible common causes based on symptoms you're experiencing and learn when to get emergency care."})
## NO SELFCARE
chest_pain_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Seek emergency medical care if:",
                                                                                  :symptom_id=>chest_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have uncomfortable pressure, fullness or squeezing pain in your chest for longer than a few minutes",
                                                          :symptom_medical_advice_id=>chest_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your chest pain is accompanied by shortness of breath, sweating, nausea, dizziness or fainting",
                                                          :symptom_medical_advice_id=>chest_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The pain radiates beyond your chest to one or both of your arms or your neck",
                                                          :symptom_medical_advice_id=>chest_pain_medadvice.id)

cough_symptom           = Symptom.upsert_attributes({:name=>"Cough", :patient_type=>"adult"},
  {:description=>"Cough can signal a number of conditions. Identify possible common causes based on symptoms you’re experiencing.",
   :selfcare=>"To soothe your cough:"
  })
cough_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"To soothe your cough:",
                                                                                  :symptom_id=>cough_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink plenty of fluids, particularly warm water, tea or clear broth", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier or take a hot, steamy shower", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Suck on hard candy or throat lozenges", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Gargle with warm salt water", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid irritants, such as cigarette smoke or pet dander", 
                                          :symptom_selfcare_id=>cough_selfcare.id)
cough_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Consult your doctor if your cough lasts longer than a week or is accompanied by:",
                                                                                  :symptom_id=>cough_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Difficulty breathing",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Difficulty swallowing",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Thick green or yellow phlegm or sputum",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Wheezing",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Stiff neck",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"High or persistent fever",
                                                          :symptom_medical_advice_id=>cough_medadvice.id)

constipation_symptom  = Symptom.upsert_attributes({:name=>"Constipation", :patient_type=>"adult"},
  {:description=>"Constipation usually isn't serious and improves with a well-balanced diet and increased water intake. Identify other possible common causes based on symptoms you’re experiencing.",
   :selfcare=>"Constipation is a common problem and usually not the result of a serious illness. Lifestyle changes that can help you manage constipation include the following:"
  })
constipation_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Constipation is a common problem and usually not the result of a serious illness. Lifestyle changes that can help you manage constipation include the following:",
                                                                                  :symptom_id=>constipation_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Eat high-fiber foods — fruits, vegetables, and whole-grain cereals and breads", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Limit problem foods — those high in fat and sugar, but low in fiber", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink plenty of water", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Exercise regularly", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use the toilet when you have the urge", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Add fiber supplements to food or beverages — oat bran, flaxseed or an over-the-counter fiber supplement", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Don't rely on laxatives", 
                                          :symptom_selfcare_id=>constipation_selfcare.id)
constipation_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Consult your doctor if your constipation:",
                                                                                  :symptom_id=>constipation_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is more severe than usual",
                                                          :symptom_medical_advice_id=>constipation_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Lasts longer than usual",
                                                          :symptom_medical_advice_id=>constipation_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Alternates with diarrhea",
                                                          :symptom_medical_advice_id=>constipation_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is accompanied by abdominal or rectal pain, rectal bleeding, blood in your stool, black stools or unexplained weight loss",
                                                          :symptom_medical_advice_id=>constipation_medadvice.id)

diarrhea_symptom    = Symptom.upsert_attributes({:name=>"Diarrhea", :patient_type=>"adult"},
  {:description=>"Diarrhea in adults is common and only rarely due to a serious problem. Identify possible common causes based on symptoms you’re experiencing.",
    :selfcare=>"Most cases of diarrhea resolve without treatment within a couple of days. In the meantime:"
  })
diarrhea_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Most cases of diarrhea resolve without treatment within a couple of days. In the meantime:",
                                                                                  :symptom_id=>diarrhea_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink plenty of clear liquids — water, clear broth or tea", 
                                          :symptom_selfcare_id=>diarrhea_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"As your bowel movements return to normal, eat bland foods — bananas, soda crackers, toast, rice, boiled potatoes or boiled carrots", 
                                          :symptom_selfcare_id=>diarrhea_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid dairy products", 
                                          :symptom_selfcare_id=>diarrhea_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid fatty, greasy, high-fiber, sweet or spicy foods", 
                                          :symptom_selfcare_id=>diarrhea_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid caffeine and alcohol", 
                                          :symptom_selfcare_id=>diarrhea_selfcare.id)
diarrhea_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Consult your doctor if diarrhea lasts longer or is more severe than usual, or if you experience any of the following signs or symptoms:",
                                                                                  :symptom_id=>diarrhea_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Severe abdominal or rectal pain",
                                                          :symptom_medical_advice_id=>diarrhea_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Blood in your stool or black, tarry stools",
                                                          :symptom_medical_advice_id=>diarrhea_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"A fever of 102 F (38.9 C) or higher",
                                                          :symptom_medical_advice_id=>diarrhea_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Signs of dehydration, such as thirst, infrequent urination, dry skin, lightheadedness or dark urine",
                                                          :symptom_medical_advice_id=>diarrhea_medadvice.id)


difficulty_swallowing_symptom = Symptom.upsert_attributes({:name=>"Difficulty Swallowing", :patient_type=>"adult"},
  {:description=>"Difficulty swallowing means that it takes more time or effort to swallow. Identify possible common causes based on symptoms you're experiencing."})
## No Selfcare
difficulty_swallowing_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency care for difficulty swallowing if you:",
                                                                                  :symptom_id=>difficulty_swallowing_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Have something stuck in your throat",
                                                          :symptom_medical_advice_id=>difficulty_swallowing_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Can't swallow at all",
                                                          :symptom_medical_advice_id=>difficulty_swallowing_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Have trouble breathing",
                                                          :symptom_medical_advice_id=>difficulty_swallowing_medadvice.id)

dizziness_symptom       = Symptom.upsert_attributes({:name=>"Dizziness", :patient_type=>"adult"},
  {:description=>"Dizziness can signal a number of conditions. Identify possible common causes based on symptoms you’re experiencing."})
## No Selfcare
dizziness_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency medical care if you experience dizziness after a head injury or if the dizziness is accompanied by:",
                                                                                  :symptom_id=>dizziness_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Sudden, severe headache",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Chest pain",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Difficulty breathing",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Numbness or weakness",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Fainting",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Blurred or double vision",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Irregular heartbeat",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Confusion or trouble talking",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Nausea or vomiting",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Stumbling or difficulty walking",
                                                          :symptom_medical_advice_id=>dizziness_medadvice.id)

eye_discomfort_symptom    = Symptom.upsert_attributes({:name=>"Eye Discomfort and Redness", :patient_type=>"adult"},
  {:description=>"Eye discomfort and redness can be concerning and disrupt your ability to do everyday activities. Identify possible common causes based on symptoms you're experiencing."})
## No Selfcare
eye_discomfort_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency care if you have eye discomfort and redness accompanied by:",
                                                                                  :symptom_id=>eye_discomfort_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Severe eye pain or irritation",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Direct injury to the eye",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Swelling in or around your eyes",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Discharge of blood or pus from your eyes",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Double vision or loss of vision",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Sudden or new appearance of halos around lights",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Nausea or vomiting",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Sudden, severe headache",
                                                          :symptom_medical_advice_id=>eye_discomfort_medadvice.id)

foot_ankle_pain_symptom   = Symptom.upsert_attributes({:name=>"Foot Pain or Ankle Pain", :patient_type=>"adult"},
  {:description=>"Foot pain or ankle pain can be distressing and limit your ability to get around. Identify possible common causes based on symptoms you’re experiencing.",
   :selfcare=>"If you've injured your foot or ankle, follow these guidelines, often called the P.R.I.C.E. treatment:"
   })
foot_ankle_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"If you've injured your foot or ankle, follow these guidelines, often called the P.R.I.C.E. treatment:",
                                                                                  :symptom_id=>foot_ankle_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Protect: Protect the area from further injury", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest: Avoid activities that hurt", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Ice: Reduce pain and inflammation with an ice pack", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Compress: Reduce swelling with an elastic bandage", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Elevate: Raise your foot or ankle as you rest", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"You may temporarily lessen pain with an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers", 
                                          :symptom_selfcare_id=>foot_ankle_selfcare.id)
foot_ankle_emergency_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency care if:",
                                                                                  :symptom_id=>foot_ankle_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You see exposed bone or tendon",
                                                          :symptom_medical_advice_id=>foot_ankle_emergency_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You're unable to put weight on your foot",
                                                          :symptom_medical_advice_id=>foot_ankle_emergency_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have severe pain or swelling",
                                                          :symptom_medical_advice_id=>foot_ankle_emergency_medadvice.id)
foot_ankle_doctor_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"See your doctor as soon as possible if:",
                                                                                  :symptom_id=>foot_ankle_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have signs of infection, such as redness, warmth and tenderness in the affected area",
                                                          :symptom_medical_advice_id=>foot_ankle_doctor_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have a fever of more than 100 F (37.8 C)",
                                                          :symptom_medical_advice_id=>foot_ankle_emergency_medadvice.id)
foot_ankle_office_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Schedule an office visit if:",
                                                                                  :symptom_id=>foot_ankle_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Swelling doesn't improve after two or three days of home treatment",
                                                          :symptom_medical_advice_id=>foot_ankle_office_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Minor pain doesn't go away after several weeks",
                                                          :symptom_medical_advice_id=>foot_ankle_office_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have ankle swelling, stiffness and pain that's worse in the morning or after you've been active",
                                                          :symptom_medical_advice_id=>foot_ankle_office_medadvice.id)

foot_leg_swelling_symptom   = Symptom.upsert_attributes({:name=>"Foot Swelling or Leg Swelling", :patient_type=>"adult"},
  {:description=>"Foot or leg swelling occurs because of inflammation or the accumulation of fluid in tissues. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"If you experience leg or foot swelling not related to an injury or joint pain, you may try the following self-care strategies to lessen symptoms:"
   })
foot_leg_swelling_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get medical care as soon as possible if:",
                                                                                  :symptom_id=>foot_leg_swelling_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have unexplained, painful swelling of your feet or legs",
                                                          :symptom_medical_advice_id=>foot_leg_swelling_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The swollen area becomes warm, red or inflamed",
                                                          :symptom_medical_advice_id=>foot_leg_swelling_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The swelling is accompanied by a fever",
                                                          :symptom_medical_advice_id=>foot_leg_swelling_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You are pregnant and have new foot swelling",
                                                          :symptom_medical_advice_id=>foot_leg_swelling_medadvice.id)

headache_symptom      = Symptom.upsert_attributes({:name=>"Headaches", :patient_type=>"adult"},
  {:description=>"Headaches are common and usually aren't the result of serious illness. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"For occasional tension headaches, the following self-care strategies may provide relief:"
   })

headache_emergency_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency medical care if your headache:",
                                                                                  :symptom_id=>headache_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is sudden and severe or the 'worst headache ever'",
                                                          :symptom_medical_advice_id=>headache_emergency_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is accompanied by a fever, nausea or vomiting not related to a known illness",
                                                          :symptom_medical_advice_id=>headache_emergency_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is accompanied by stiff neck, rash, confusion, seizures, double vision, weakness, numbness or difficulty speaking",
                                                          :symptom_medical_advice_id=>headache_emergency_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Follows a head injury, fall or bump",
                                                          :symptom_medical_advice_id=>headache_emergency_medadvice.id)
headache_prompt_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get prompt medical care if your headache:",
                                                                                  :symptom_id=>headache_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Gets worse despite rest and over-the-counter pain medication",
                                                          :symptom_medical_advice_id=>headache_prompt_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Is new and you have a history of cancer or HIV/AIDS",
                                                          :symptom_medical_advice_id=>headache_prompt_medadvice.id)

heart_palpitations_symptom  = Symptom.upsert_attributes({:name=>"Heart Palpitations", :patient_type=>"adult"},
  {:description=>"Heart palpitations are racing, uncomfortable or irregular heartbeats or a 'flopping' sensation in your chest. Identify possible common causes based on symptoms you're experiencing."})
## No Selfcare
heart_palpitations_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"See your doctor if you experience heart palpitations. Most often heart palpitations don't present a significant health risk, but they can be caused by a serious illness. It's important to get a prompt, accurate diagnosis and appropriate care. Get emergency medical care if heart palpitations are accompanied by:",
                                                                                  :symptom_id=>heart_palpitations_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Chest pain that lasts more than a few minutes",
                                                          :symptom_medical_advice_id=>heart_palpitations_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Dizziness, lightheadedness or fainting",
                                                          :symptom_medical_advice_id=>heart_palpitations_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Shortness of breath",
                                                          :symptom_medical_advice_id=>heart_palpitations_medadvice.id)

hip_pain_symptom      = Symptom.upsert_attributes({:name=>"Hip Pain", :patient_type=>"adult"}, 
  {:description=>"Hip pain can affect your ability to move about normally. Identify possible common causes based on symptoms you’re experiencing.",
   :selfcare=>"The following self-care strategies may temporarily lessen pain in your hip:"
  })
hip_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following self-care strategies may temporarily lessen pain in your hip:",
                                                                                  :symptom_id=>hip_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use an ice pack to reduce pain and inflammation", 
                                          :symptom_selfcare_id=>hip_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest and avoid any activities that hurt", 
                                          :symptom_selfcare_id=>hip_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the package label, and do not take combinations of pain relievers", 
                                          :symptom_selfcare_id=>hip_pain_selfcare.id)
hippain_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Seek medical care immediately if:",
                                                                                  :symptom_id=>hip_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You're unable to bear weight",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your hip made a popping sound",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your hip became visibly deformed after a fall",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Your hip is more painful the day after a fall",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You're experiencing intense pain or sudden swelling",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You have osteoporosis and have injured your hip",
                                                          :symptom_medical_advice_id=>hippain_medadvice.id)

knee_pain_symptom       = Symptom.upsert_attributes({:name=>"Knee Pain", :patient_type=>"adult"},
  {:description=>"Knee pain can seriously impair walking and exercise. Identify possible common causes based on symptoms you're experiencing.",
  :selfcare=>"You may temporarily lessen pain with an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers. If you're experiencing knee pain, follow these guidelines, often called the P.R.I.C.E. treatment:"
  })
knee_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"If you're experiencing knee pain, follow these guidelines, often called the P.R.I.C.E. treatment:",
                                                                                  :symptom_id=>knee_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Protect: Protect the area from further injury", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest: Avoid activities that hurt", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Ice: Reduce pain and inflammation with an ice pack", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Compress: Reduce swelling with an elastic bandage", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Elevate: Raise your foot or ankle as you rest", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"You may temporarily lessen pain with an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers", 
                                          :symptom_selfcare_id=>knee_pain_selfcare.id)
knee_pain_medadvice = SymptomMedicalAdvice.find_or_create_by_description_and_symptom_id(:description=>"Get emergency care if knee pain is accompanied by any of the following factors:",
                                                                                  :symptom_id=>knee_pain_symptom.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You experience bleeding or severe pain after an injury",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"Bone or tendons are exposed",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The knee is visibly out of place",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"There's sudden swelling or redness",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You can't bend your knee or put weight on it",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"You heard a popping sound or snapping sensation",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)
SymptomMedicalAdviceItem.find_or_create_by_description_and_symptom_medical_advice_id(:description=>"The pain is associated with fever and chills",
                                                          :symptom_medical_advice_id=>knee_pain_medadvice.id)

low_back_pain_symptom     = Symptom.upsert_attributes({:name=>"Low Back Pain", :patient_type=>"adult"},
  {:description=>"Low back pain can signal a number of conditions. Identify possible common causes based on symptoms you’re experiencing.",
   :selfcare=>"Back pain usually improves on its own. In the meantime, try these strategies:"
  })
back_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Back pain usually improves on its own. In the meantime, try these strategies:",
                                                                                  :symptom_id=>low_back_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid heavy lifting, pushing, pulling, bending or twisting", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid sitting for long periods of time", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Continue your usual activities as much as possible", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Engage in gentle exercise, such as walking", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a heating pad or take a warm bath", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers", 
                                          :symptom_selfcare_id=>back_pain_selfcare.id)

nasal_congestion_symptom  = Symptom.upsert_attributes({:name=>"Nasal Congestion", :patient_type=>"adult"},
  {:description=>"Nasal congestion is a common problem in adults. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"To relieve a stuffy nose:"
   })
nasal_congestion_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"To relieve a stuffy nose:",
                                                                                  :symptom_id=>nasal_congestion_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Gently blow your nose, or sniff and swallow", 
                                          :symptom_selfcare_id=>nasal_congestion_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Breathe steam from a warm shower", 
                                          :symptom_selfcare_id=>nasal_congestion_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier", 
                                          :symptom_selfcare_id=>nasal_congestion_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a nasal saline spray", 
                                          :symptom_selfcare_id=>nasal_congestion_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Try an oral decongestant", 
                                          :symptom_selfcare_id=>nasal_congestion_selfcare.id)

nausea_or_vomiting_symptom  = Symptom.upsert_attributes({:name=>"Nausea or Vomiting", :patient_type=>"adult"},
  {:description=>"Nausea or vomiting is most often caused by the stomach flu. Identify other possible common causes based on symptoms you're experiencing.",
   :selfcare=>"If you're experiencing nausea or vomiting:"
   })
nausea_or_vomiting_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"If you're experiencing nausea or vomiting:",
                                                                                  :symptom_id=>nausea_or_vomiting_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink small amounts of water or sports drinks", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Eat foods with high water content, such as broth and gelatin", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Eat bland foods, such as crackers, toast and rice", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid unpleasant food odors", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid dairy products and fatty or heavily seasoned foods", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid caffeine and alcohol", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_selfcare.id)


neck_pain_symptom       = Symptom.upsert_attributes({:name=>"Neck Pain", :patient_type=>"adult"},
  {:description=>"Neck pain may be a short-term problem or a chronic disability. Identify possible common causes based on symptoms you're experiencing.",
  :selfcare=>"The following tips may help relieve mild to moderate neck pain:"
  })
neck_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following tips may help relieve mild to moderate neck pain:",
                                                                                      :symptom_id=>neck_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use ice to reduce pain and inflammation", 
                                          :symptom_selfcare_id=>neck_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Gently stretch or massage your neck", 
                                          :symptom_selfcare_id=>neck_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid activities that are painful", 
                                          :symptom_selfcare_id=>neck_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers", 
                                          :symptom_selfcare_id=>neck_pain_selfcare.id)

numbness_in_hands_symptom   = Symptom.upsert_attributes({:name=>"Numbness or Tingling in Hands", :patient_type=>"adult"},
  {:description=>"Numbness or tingling in hands is often triggered by injury or repetitive use. Identify possible common causes based on symptoms you're experiencing."})
## NO SELF CARE

pelvic_pain_female_symptom  = Symptom.upsert_attributes({:name=>"Pelvic Pain (Female)", :patient_type=>"adult"},
  {:description=>"Pelvic pain in women can be caused by a wide variety of diseases and conditions. Identify possible common causes based on symptoms you’re experiencing.",
    :gender=>"F"})
## NO SELF CARE

pelvic_pain_male_symptom  = Symptom.upsert_attributes({:name=>"Pelvic Pain (Male)", :patient_type=>"adult"},
  {:description=>"Pelvic pain in men can be concerning. Identify possible common causes based on symptoms you're experiencing.", 
     :gender=>"M"})
## NO SELF CARE

shortness_of_breath_symptom = Symptom.upsert_attributes({:name=>"Shortness of Breath", :patient_type=>"adult"},
  {:description=>"Shortness of breath can signal a number of conditions that need prompt medical care. Identify possible common causes based on symptoms you're experiencing."})
## NO SELF CARE

shoulder_pain_symptom     = Symptom.upsert_attributes({:name=>"Shoulder Pain", :patient_type=>"adult"},
  {:description=>"Shoulder pain often is due to a mechanical problem in the shoulder joint. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"The following self-care strategies may lessen mild to moderate shoulder pain:"
   })
shoulder_pain_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following self-care strategies may lessen mild to moderate shoulder pain:",
                                                                                      :symptom_id=>shoulder_pain_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use ice to reduce pain and inflammation", 
                                          :symptom_selfcare_id=>shoulder_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Do gentle exercises to move your arm through its normal range of motion", 
                                          :symptom_selfcare_id=>shoulder_pain_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers.", 
                                          :symptom_selfcare_id=>shoulder_pain_selfcare.id)

sore_throat_symptom     = Symptom.upsert_attributes({:name=>"Sore Throat", :patient_type=>"adult"},
  {:description=>"Sore throat is a common problem. Identify possible causes based on symptoms you're experiencing.",
  :selfcare=>"Most sore throats go away within about a week. In the meantime, try these tips:"
  })
sore_throat_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Most sore throats go away within about a week. In the meantime, try these tips:",
                                                                                      :symptom_id=>sore_throat_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Drink plenty of fluids", 
                                          :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Gargle with warm salt water", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Suck on hard candy or throat lozenges", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest your voice", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier or take a steamy shower", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid smoke and other air pollutants", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take an over-the-counter pain reliever, such as ibuprofen (Advil, Motrin, others), naproxen (Aleve, others) or acetaminophen (Tylenol, others). Use only as directed on the label, and do not take combinations of pain relievers.", 
                                           :symptom_selfcare_id=>sore_throat_selfcare.id)

urinary_problems_symptom  = Symptom.upsert_attributes({:name=>"Urinary Problems", :patient_type=>"adult"},
  {:description=>"Urinary problems are a common complaint among adults. Identify possible common causes based on symptoms you're experiencing."})
###NO URINARY SELFCARE


vision_problems_symptom   = Symptom.upsert_attributes({:name=>"Vision Problems", :patient_type=>"adult"},
  {:description=>"Vision problems, even those easily corrected, can greatly affect everyday activities. Identify possible common causes based on symptoms you're experiencing."})
### NO VISION SELFCARE

wheezing_symptom      = Symptom.upsert_attributes({:name=>"Wheezing", :patient_type=>"adult"}, 
  {:description=>"Wheezing is a high-pitched, whistling noise that occurs with breathing. Identify possible common causes based on symptoms you're experiencing.",
   :selfcare=>"Wheezing requires medical attention. But taking good care of yourself can help:"})
wheezing_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Wheezing requires medical attention. But taking good care of yourself can help:",
                                                                                      :symptom_id=>wheezing_symptom.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"If you smoke, quit", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid exposure to irritants, such as tobacco smoke", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Take a break when you begin to wheeze", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Practice deep-breathing exercises", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier or take hot, steamy showers to alleviate symptoms", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use an inhaler or other asthma medications as prescribed", 
                                          :symptom_selfcare_id=>wheezing_selfcare.id)
#######################################################################################################################################################################
#Symptoms - CHILD
#######################################################################################################################################################################
abdominal_pain_symptom_child    = Symptom.upsert_attributes({:name=>"Abdominal Pain", :patient_type=>"child"},
  {:description=>"Abdominal pain is common in children and often is the result of stomach flu. Identify other possible common causes based on your child's symptoms.",
   :selfcare=>"The following self-care tips may be beneficial for mild abdominal pain:"
  })
abdominal_pain_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following self-care tips may be beneficial for mild abdominal pain:",
                                                                                  :symptom_id=>abdominal_pain_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Don't serve foods that you suspect may cause or worsen symptoms", 
                                          :symptom_selfcare_id=>abdominal_pain_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Give your child plenty of water if the abdominal pain is accompanied by diarrhea or constipation", 
                                          :symptom_selfcare_id=>abdominal_pain_child_selfcare.id)

constipation_symptom_child    = Symptom.upsert_attributes({:name=>"Constipation", :patient_type=>"child"},
  {:description=>"Constipation in children is most often caused by poor diet or poor bowel habits. Identify other common causes of constipation based on your child's symptoms.",
   :selfcare=>"If your child is constipated:"
  })
constipation_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"If your child is constipated:",
                                                                                  :symptom_id=>constipation_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer plenty of water", 
                                          :symptom_selfcare_id=>constipation_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Feed your child fruits, vegetables and high-fiber foods", 
                                          :symptom_selfcare_id=>constipation_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Limit dairy products and fats", 
                                          :symptom_selfcare_id=>constipation_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use laxatives only as recommended by your doctor", 
                                          :symptom_selfcare_id=>constipation_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"If your child resists having bowels movements, create a regular schedule for attempting a bowel movement and consider a reward system for successful bowel movements", 
                                          :symptom_selfcare_id=>constipation_symptom_child_selfcare.id)

cough_symptom_child   = Symptom.upsert_attributes({:name=>"Cough", :patient_type=>"child"},
  {:description=>"Infections, allergies and asthma can cause coughs in children. Identify possible common causes based on symptoms your child is experiencing.",
   :selfcare=>"To soothe your child's cough:"
  })
cough_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"To soothe your child's cough:",
                                                                                  :symptom_id=>cough_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer plenty of water", 
                                          :symptom_selfcare_id=>cough_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Encourage rest", 
                                          :symptom_selfcare_id=>cough_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier or sit with your child in a steamy bathroom", 
                                          :symptom_selfcare_id=>cough_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer an older child hard candy or throat lozenges", 
                                          :symptom_selfcare_id=>cough_symptom_child_selfcare.id)

decreased_hearing_symptom_child   = Symptom.upsert_attributes({:name=>"Decreased Hearing", :patient_type=>"child"},
  {:description=>"Middle ear infection is the most common cause of decreased hearing in children. Identify other possible common causes based on your child's symptoms."
  })
## No selfcare

diarrhea_symptom_child    = Symptom.upsert_attributes({:name=>"Diarrhea", :patient_type=>"child"},
  {:description=>"Diarrhea in children is common and is only rarely due to a serious problem. Identify possible common causes based on symptoms your child is experiencing.",
   :selfcare=>"Most cases of diarrhea resolve without treatment within a couple of days. In the meantime, follow these recommendations:"
  })
diarrhea_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Most cases of diarrhea resolve without treatment within a couple of days. In the meantime, follow these recommendations:",
                                                                                  :symptom_id=>diarrhea_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer your child plenty of clear liquids — water, clear broth or beverages specifically intended for preventing dehydration in children", 
                                          :symptom_selfcare_id=>diarrhea_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"As your child's bowel movements return to normal, offer bland foods — bananas, soda crackers, toast, rice, boiled potatoes or boiled carrots", 
                                          :symptom_selfcare_id=>diarrhea_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid dairy products", 
                                          :symptom_selfcare_id=>diarrhea_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Avoid fatty, greasy, high-fiber, sweet or spicy foods", 
                                          :symptom_selfcare_id=>diarrhea_symptom_child_selfcare.id)

earache_symptom_child  = Symptom.upsert_attributes({:name=>"Earache", :patient_type=>"child"},
  {:description=>"Middle ear infection is the most common cause of earache in children. Identify other possible common causes based on symptoms your child is experiencing.",
   :selfcare=>"To relieve your child's discomfort:"})
earache_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"To relieve your child's discomfort:",
                                                                                  :symptom_id=>earache_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Give your child acetaminophen (Tylenol, others) or ibuprofen (Advil, Motrin, others) — not aspirin — as directed on the label", 
                                          :symptom_selfcare_id=>earache_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Hold a warm, moist cloth over your child's ear", 
                                          :symptom_selfcare_id=>earache_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Ask the pharmacist about numbing eardrops", 
                                          :symptom_selfcare_id=>earache_symptom_child_selfcare.id)

eye_discomfort_and_red_symptom_child  = Symptom.upsert_attributes({:name=>"Eye Discomfort and Redness", :patient_type=>"child"},
  {:description=>"Eye discomfort and redness can be concerning and disrupt your ability to do everyday activities. Identify possible common causes based on symptoms you're experiencing."})
#No Selfcare

fever_symptom_child = Symptom.upsert_attributes({:name=>"Fever", :patient_type=>"child"},
  {:description=>"Childhood fevers are common and not necessarily a serious concern. Identify common causes of fever based on your child's symptoms.",
   :selfcare=>"The goal for treating a fever is to make your child less uncomfortable and better able to rest. These self-care strategies may help:"
   })
fever_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The goal for treating a fever is to make your child less uncomfortable and better able to rest. These self-care strategies may help:",
                                                                                  :symptom_id=>fever_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Encourage your child to drink water or juice or to suck on frozen ice pops", 
                                          :symptom_selfcare_id=>fever_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Dress your child in lightweight clothing", 
                                          :symptom_selfcare_id=>fever_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"If your child feels chilled, use a light blanket until the chills end", 
                                          :symptom_selfcare_id=>fever_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Give your child acetaminophen (Tylenol, others) or ibuprofen (Advil, Motrin, others) — not aspirin — as directed on the label", 
                                          :symptom_selfcare_id=>fever_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Give your child a lukewarm bath", 
                                          :symptom_selfcare_id=>fever_symptom_child_selfcare.id)

headache_symptom_child  = Symptom.upsert_attributes({:name=>"Headaches", :patient_type=>"child"},
  {:description=>"Headaches are common and usually aren't the result of serious illness. Identify possible common causes based on your child's symptoms.",
   :selfcare=>"For occasional tension headaches, the following self-care strategies may provide relief for your child:"
   })


joint_muscle_pain_symptom_child = Symptom.upsert_attributes({:name=>"Joint Pain or Muscle Pain", :patient_type=>"child"},
  {:description=>"Joint pain and muscle pain is fairly common and often due to active lifestyles. Identify other possible causes based on your child's symptoms.",
   :selfcare=>"You may temporarily lessen pain with an over-the-counter children's pain reliever, such as ibuprofen (Advil, Motrin, others) or acetaminophen (Tylenol, others) — but not aspirin. Use only as directed on the label, and do not give your child combinations of pain relievers. If your child is experiencing pain from a sprain or fall, you may provide some relief with the following self-care strategies:"
   })
joint_muscle_pain_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"If your child is experiencing pain from a sprain or fall, you may provide some relief with the following self-care strategies:",
                                                                                  :symptom_id=>joint_muscle_pain_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Protect. Protect the area from further injury", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Rest. Avoid activities that hurt", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Ice. Reduce pain and inflammation with an ice pack", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Compress. Reduce swelling with an elastic bandage", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Elevate. Elevate the affected limb while your child rests", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"You may temporarily lessen pain with an over-the-counter children's pain reliever, such as ibuprofen (Advil, Motrin, others) or acetaminophen (Tylenol, others) — but not aspirin. Use only as directed on the label, and do not give your child combinations of pain relievers.", 
                                          :symptom_selfcare_id=>joint_muscle_pain_symptom_child_selfcare.id)

nasal_congestion_symptom_child = Symptom.upsert_attributes({:name=>"Nasal Congestion", :patient_type=>"child"},
  {:description=>"Nasal congestion is a common problem in children. Identify possible common causes based on symptoms your child is experiencing.",
   :selfcare=>"To relieve your child's stuffy nose:"
   })
nasal_congestion_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"To relieve your child's stuffy nose:",
                                                                                  :symptom_id=>nasal_congestion_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Help your child gently blow his or her nose", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a bulb syringe for a younger child", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer plenty of fluids", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Sit with your child in a steamy bathroom", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Put a humidifier in your child's room", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a nasal saline spray", 
                                          :symptom_selfcare_id=>nasal_congestion_symptom_child_selfcare.id)

nausea_or_vomiting_symptom_child = Symptom.upsert_attributes({:name=>"Nausea or Vomiting", :patient_type=>"child"},
  {:description=>"Nausea or vomiting is most often caused by the stomach flu. Identify other possible common causes based on symptoms you're experiencing.",
   :selfcare=>"The following strategies can lessen discomfort and prevent dehydration if your child experiences nausea or vomiting:"
   })
nausea_or_vomiting_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following strategies can lessen discomfort and prevent dehydration if your child experiences nausea or vomiting:",
                                                                                  :symptom_id=>nausea_or_vomiting_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Encourage rest", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"After your child vomits, give him or her small sips of a pediatric rehydrating solution every 10 to 20 minutes", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"When your child can tolerate more fluids, provide more rehydrating solution, water, and foods with high water content, such as broth, gelatin or ice pops", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"When solid foods can be tolerated, provide bland foods, such as crackers, toast and rice", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Help your child avoid unpleasant food odors, dairy products, fatty or heavily seasoned foods, and caffeine", 
                                          :symptom_selfcare_id=>nausea_or_vomiting_symptom_child_selfcare.id)

skin_rash_symptom_child = Symptom.upsert_attributes({:name=>"Skin Rashes", :patient_type=>"child"},
  {:description=>"Nausea or vomiting in children is a common problem. Identify possible causes based on the symptoms your child is experiencing."
  })
skin_rash_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"Call your child's doctor before treating a rash or skin irritation of unknown origin. If you know that a rash is caused by an insect bite or exposure to an irritating plant, such as poison ivy, use these self-care tips: ",
                                                                                  :symptom_id=>skin_rash_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Clean the affected area with soap or water", 
                                          :symptom_selfcare_id=>skin_rash_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Give your child a colloidal oatmeal bath", 
                                          :symptom_selfcare_id=>skin_rash_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Apply a soothing cream, such as calamine lotion", 
                                          :symptom_selfcare_id=>skin_rash_symptom_child_selfcare.id)

sore_throat_symptom_child = Symptom.upsert_attributes({:name=>"Sore Throat", :patient_type=>"child"},
  {:description=>"Sore throat is common during childhood. Identify possible causes based on your child's symptoms.",
  :selfcare=>"The following tips may help soothe your child's sore throat:"
  })
sore_throat_symptom_child_selfcare = SymptomSelfcare.find_or_create_by_description_and_symptom_id(:description=>"The following tips may help soothe your child's sore throat:",
                                                                                  :symptom_id=>sore_throat_symptom_child.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer plenty of fluids", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Encourage your child to rest his or her voice", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Use a humidifier or sit with your child in a steamy bathroom", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer an older child hard candy or throat lozenges", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Offer an older child warm salt water to gargle", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)
SymptomSelfcareItem.find_or_create_by_description_and_symptom_selfcare_id(:description=>"Help your child avoid smoke and other air pollutants", 
                                          :symptom_selfcare_id=>sore_throat_symptom_child_selfcare.id)

urinary_problems_symptom_child  = Symptom.upsert_attributes({:name=>"Urinary Problems", :patient_type=>"child"},
  {:description=>"Urinary problems are common. Consider what may be causing your child's signs and symptoms."})
vision_problems_symptom_child   = Symptom.upsert_attributes({:name=>"Vision Problems", :patient_type=>"child"},
  {:description=>"Vision problems in children can be difficult to detect. Identify possible common causes based on signs and symptoms your child may have."})
wheezing_symptom_child  = Symptom.upsert_attributes({:name=>"Wheezing", :patient_type=>"child"}, 
  {:description=>"Wheezing is a high-pitched, whistling noise that occurs with breathing. Identify possible common causes based on symptoms your child is experiencing."})

#SymptomsFactor

############## CLEAR OUT EXISTING DATA
SymptomsFactor.delete_all

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
  :factor_group_id=>pain_located_in_factor_group.id
)
abdominal_pain_lower_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>lower_abdomen_factor.id,
  :factor_group_id=>pain_located_in_factor_group.id
)
abdominal_pain_middle_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>middle_abdomen_factor.id,
  :factor_group_id=>pain_located_in_factor_group.id
)
abdominal_pain_one_or_both_sides_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>one_or_both_sides_factor.id,
  :factor_group_id=>pain_located_in_factor_group.id
)
abdominal_pain_upper_abdomen_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>abdominal_pain_symptom.id,
  :factor_id=>upper_abdomen_factor.id,
  :factor_group_id=>pain_located_in_factor_group.id
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
blood_stool_drinking_alcohol_or_caffeine_triggered_or_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>blood_in_stool_symptom.id,
  :factor_id=>drinking_alcohol_or_caffeine_factor.id,
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
chest_pain_anxiety_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>anxiety_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_belching_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>belching_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_cough_blood_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>cough_with_blood_phlegm_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_diff_swallow_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>difficult_or_painful_swallowing_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_dry_cough_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>dry_cough_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_faint_dizzy_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>fainting_or_dizziness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_fever_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_headache_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>headache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_nausea_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_pain_neck_arms_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>pain_in_neck_jaw_arms_shoulders_back_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_rapid_heartbeat_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rapid_or_irregular_heartbeat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_rash_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rash_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_shortness_breath_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_sweating_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sweating_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_unex_fatigue_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>unexplained_fatigue_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
chest_pain_achy_gnawing_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>achy_or_gnawing_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_vaguely_uncomfortable_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>vaguely_uncomfortable_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_achy_burning_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>burning_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_intermittent_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>intermittent_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_severe_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>severe_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_sharp_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sharp_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_squeezing_or_pressure_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>squeezing_or_pressure_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_sudden_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>sudden_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_tearing_or_ripping_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>tearing_or_ripping_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_tight_pain_described_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>tight_factor.id,
  :factor_group_id=>pain_best_described_as_factor_group.id
)
chest_pain_antacids_relieved_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>antacids_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
chest_pain_bending_forward_relieved_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>bending_forward_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
chest_pain_rest_relieved_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>rest_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
chest_pain_eating_drinking_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>eating_or_drinking_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_exertion_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>exertion_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_injury_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>injury_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_lying_down_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>lying_down_for_a_long_period_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_chest_wall_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>pressing_on_chest_wall_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_stress_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>stress_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
chest_pain_deep_breath_triggered_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>chest_pain_symptom.id,
  :factor_id=>taking_a_deep_breath_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)

## Constipation - ADULT
## #############################
constipation_ongoing_recurrent_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>ongoing_or_recurrent_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
constipation_recent_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>recent_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
constipation_progressive_or_worsening_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>progressive_or_worsening_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
constipation_abdominal_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>abdominal_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_anal_rectal_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>anal_or_rectal_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_bloody_stools_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>bloody_stools_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_cramping_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>cramping_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_diarrhea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>diarrhea_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_gas_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>gas_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_increased_sensitivity_to_cold_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>increased_sensitivity_to_cold_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_mucus_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>mucus_in_stools_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_muscle_joint_ache_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>muscle_or_joint_aches_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_muscle_weakness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>muscle_weakness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_nausea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_pale_dry_skin_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>pale_dry_skin_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_unex_fatigue_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>unexplained_fatigue_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_unintended_weight_loss_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
constipation_unintended_weight_gain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>constipation_symptom.id,
  :factor_id=>unintended_weight_gain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Cough - ADULT
## #############################
cough_dry_cough_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>dry_factor.id,
  :factor_group_id=>cough_is_factor_group.id
)
cough_producing_phlegm_or_sputum_cough_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>producing_phlegm_or_sputum_factor.id,
  :factor_group_id=>cough_is_factor_group.id
)
cough_new_recently_cough_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>new_or_began_recently_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
cough_ongoing_recurrent_cough_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>ongoing_or_recurrent_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
cough_progressive_worsening_cough_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>progressive_or_worsening_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
cough_allergens_irritants_triggered_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>allergens_or_irritants_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
cough_chest_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>chest_pain_or_tightness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_chills_sweating_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>chills_or_sweating_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_difficulty_swallowing_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>difficulty_swallowing_symptom.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_fatigue_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>fatigue_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_headache_facial_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>headache_or_facial_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_hoarse_voice_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>hoarse_voice_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_loss_appetite_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>loss_of_appetite_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_muscle_aches_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>muscle_aches_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_runny_or_stuffy_nose_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>runny_or_stuffy_nose_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_shortness_of_breath_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_sneezing_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>sneezing_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_sore_throat_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>sore_throat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_watery_itchy_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>watery_or_itchy_eyes_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
cough_wheezing_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>cough_symptom.id,
  :factor_id=>wheezing_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
## Diarrhea - ADULT
## #############################
diarrhea_ongoing_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>ongoing_or_recurrent_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
diarrhea_eating_suspect_food_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>preceded_by_eating_suspect_food_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
diarrhea_antibiotic_use_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>preceded_by_recent_antibiotic_use_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
diarrhea_recent_day_week_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>recent_day_week_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
diarrhea_sudden_hours_days_problem_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>sudden_hours_days_factor.id,
  :factor_group_id=>problem_is_factor_group.id
)
diarrhea_eating_certain_foods_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
diarrhea_avoiding_certain_foods_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>avoiding_certain_foods_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
diarrhea_abdominal_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>abdominal_pain_or_cramping_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_bloating_abdominal_swelling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>bloating_or_abdominal_swelling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_bloody_stools_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>bloody_stools_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_constipation_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>constipation_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_mucus_in_stool_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>mucus_in_stools_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_muscle_or_joint_aches_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>muscle_or_joint_aches_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_nausea_or_vomit_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_passing_gas_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>passing_gas_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_unintended_weight_loss_factor_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
diarrhea_urgency_to_have_bowel_movement_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>diarrhea_symptom.id,
  :factor_id=>urgency_to_have_bowel_movement.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Diff Swallowing - ADULT
## #############################
difficulty_swallowing_swallowing_hurts_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>hurts_factor.id,
  :factor_group_id=>swallowing_factor_group.id
)
difficulty_swallowing_takes_effort_swallowing_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>takes_effort_factor.id,
  :factor_group_id=>swallowing_factor_group.id
)
difficulty_swallowing_eating_certain_foods_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>eating_certain_foods_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
difficulty_swallowing_bad_breath_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>bad_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_cough_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>cough_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_difficulty_breathing_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>difficulty_breathing_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_dry_eyes_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>dry_eyes_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_dry_mouth_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>dry_mouth_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_earache_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>earache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_feeling_somthing_stuck_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>feeling_somthing_stuck_throat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_hoarse_voice_or_difficulty_speaking_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>heartburn_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_heartburn_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>hoarse_voice_or_difficulty_speaking_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_jaw_pain_or_stiffness_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>jaw_pain_or_stiffness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_loose_teeth_or_poorly_fitting_dentures_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>loose_teeth_or_poorly_fitting_dentures.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_lump_in_front_of_neck_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>lump_in_front_of_neck_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_mouth_sores_lumps_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>mouth_sores_lumps_or_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_muscle_cramps_or_twitching_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>muscle_cramps_or_twitching_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_muscle_weakness_hands_legs_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>muscle_weakness_hands_legs_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_numbness_pain_color_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>numbness_pain_color_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_pain_in_chest_neck_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>pain_in_chest_neck_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_regurgitation_food_liquid_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>regurgitation_food_liquid_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_slurred_speech_difficulty_speaking_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>slurred_speech_difficulty_speaking_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_sore_throat_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>sore_throat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_thick_saliva_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>thick_saliva_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_tight_hardened_skin_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>tight_hardened_skin.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
difficulty_swallowing_unintended_weight_loss_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>difficulty_swallowing_symptom.id,
  :factor_id=>unintended_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Dizzyness - ADULT
## #############################
dizzyness_spinning_sensation_you_feel_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>a_spinning_sensation_factor.id,
  :factor_group_id=>you_feel_factor_group.id
)
dizzyness_lightneadedned_or_faint_you_feel_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>lightneadedned_or_faint_factor.id,
  :factor_group_id=>you_feel_factor_group.id
)
dizzyness_unsteady_you_feel_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>unsteady_factor.id,
  :factor_group_id=>you_feel_factor_group.id
)
dizzyness_new_or_began_suddenly_symptoms_are_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>new_or_began_suddenly_factor.id,
  :factor_group_id=>symptoms_are_factor_group.id
)
dizzyness_recurrent_or_ongoing_symptoms_are_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>recurrent_or_ongoing_factor.id,
  :factor_group_id=>symptoms_are_factor_group.id
)
dizzyness_worsening_or_progressing_symptoms_are_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>worsening_or_progressing_factor.id,
  :factor_group_id=>symptoms_are_factor_group.id
)
dizzyness_change_in_head_or_body_position_triggered_or_worsened_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>a_change_in_head_or_body_position_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
dizzyness_anxiety_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>anxiety_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_blurred_or_double_vision_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>blurred_or_double_vision_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_buzzing_or_ringing_in_ear_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>buzzing_or_ringing_in_ear_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_chest_pain_or_pressure_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>chest_pain_or_pressure_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_confusion_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>confusion_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_ear_pain_or_pressure_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>ear_pain_or_pressure_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_facial_numbness_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>facial_numbness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_fever_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_hearing_loss_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>hearing_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_irregular_heartbeat_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>irregular_heartbeat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_nausea_vomit_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_numbness_or_weakness_one_side_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>numbness_or_weakness_one_side.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_pain_in_chest_neck_shoulder_arm_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>pain_in_chest_neck_shoulder_arm_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_severe_headache_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>severe_headache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_shortness_of_breath_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_slurred_speech_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>slurred_speech_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
dizzyness_sweating_accompanied_by_SF=SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>dizziness_symptom.id,
  :factor_id=>sweating_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Eye Discomfort - ADULT
## #############################
eye_discomfort_ache_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>ache_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_dry_itchy_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>dry_or_itchy_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_gritty_sensation_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>gritty_sensation_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_redness_without_discomfort_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>redness_without_discomfort_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_sensitivity_to_light_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>sensitivity_to_light.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_severe_pain_described_as_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>severe_pain_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_stinging_or_burning_sensation_described_as_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>stinging_or_burning_sensation_factor.id,
  :factor_group_id=>eye_discomfort_described_as_factor_group.id
)
eye_discomfort_bleeding_on_surface_eye_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>bleeding_on_surface_eye_factor.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_crusted_eyelashes_after_sleeping_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>crusted_eyelashes_after_sleeping.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_excessive_tearing_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>excessive_tearing_factor.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_red_painful_lump_on_eyelid_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>red_painful_lump_on_eyelid.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_redness_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>redness_factor.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_stringy_mucus_in_around_eye_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>stringy_mucus_in_around_eye_factor.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_swelling_around_eye_appearance_eye_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>swelling_around_eye_factor.id,
  :factor_group_id=>appearance_of_eye_factor_group.id
)
eye_discomfort_blurred_vision_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>blurred_vision_factor.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_dark_floating_spots_in_vision_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>dark_floating_spots_in_vision_factor.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_halos_around_lights_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>halos_around_lights_factor.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_loss_of_color_vision_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>loss_of_color_vision.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_shimmering_or_flash_of_light_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>shimmering_or_flash_of_light_factor.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_vision_loss_problem_includes_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>vision_loss_factor.id,
  :factor_group_id=>vision_problem_includes_factor_group.id
)
eye_discomfort_allergens_or_irritants_triggered_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>allergens_or_irritants_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
eye_discomfort_injury_trauma_triggered_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>injury_trauma_factor.id,
  :factor_group_id=>triggered_by_factor_group.id
)
eye_discomfort_dry_warm_air_worsened_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>dry_warm_air_factor.id,
  :factor_group_id=>worsened_by_factor_group.id
)
eye_discomfort_eye_movement_worsened_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>eye_movement_factor.id,
  :factor_group_id=>worsened_by_factor_group.id
)
eye_discomfort_dry_mouth_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>dry_mouth_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
eye_discomfort_headache_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>headache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
eye_discomfort_nausea_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
eye_discomfort_runny_or_stuff_nose_accompanied_by_SF =SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>eye_discomfort_symptom.id,
  :factor_id=>runny_or_stuffy_nose_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Foot and Ankle Pain - ADULT
## #############################
foot_ankle_ankle_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>ankle_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_toenail_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>area_along_edge_of_toenail_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_back_ankle_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>back_of_ankle_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_back_heel_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>back_of_heel_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_bottom_foot_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>bottom_of_foot_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_heel_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>heel_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_middle_foot_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>middle_part_of_foot_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_toe_front_foot_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>toe_or_front_part_of_foot_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_whole_foot_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>whole_foot_factor.id,
  :factor_group_id=>located_factor_group.id
)
foot_ankle_activity_triggered_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>activity_or_overuse_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_ankle_ill_fitting_shoes_triggered_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>ill_fitting_shoes_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_ankle_injury_triggered_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>injury_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_ankle_long_periods_rest_triggered_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>long_periods_of_rest_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_ankle_burning_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>burning_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_difficulty_pushing_off_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>difficulty_pushing_off_with_toes_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_feeling_of_instability_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>feeling_of_instability_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_flattened_arch_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>flattened_arch_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_inability_bear_weight_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>inability_to_bear_weight_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_joint_deformity_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>joint_deformity_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_numbness_tingling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>numbness_or_tingling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_redness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>redness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_stiffness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>stiffness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_swelling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>swelling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_thickened_skin_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>thickened_or_rough_skin_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_ankle_weakness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_ankle_pain_symptom.id,
  :factor_id=>weakness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Foot swelling or Leg Swelling - ADULT
## ######################################
foot_swelling_whole_limb_swelling_occurs_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>along_whole_limb_factor.id,
  :factor_group_id=>swelling_occurs_factor_group.id
)
foot_swelling_ankle_foot_swelling_occurs_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>around_ankle_or_foot_factor.id,
  :factor_group_id=>swelling_occurs_factor_group.id
)
foot_swelling_around_knee_swelling_occurs_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>around_knee_factor.id,
  :factor_group_id=>swelling_occurs_factor_group.id
)
foot_swelling_both_limbs_swelling_occurs_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>in_both_limbs_factor.id,
  :factor_group_id=>swelling_occurs_factor_group.id
)
foot_swelling_one_limb_swelling_occurs_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>in_one_limb_factor.id,
  :factor_group_id=>swelling_occurs_factor_group.id
)
foot_swelling_activity_overuse_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>activity_or_overuse_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_swelling_injury_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>injury_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
foot_swelling_inactivity_rest_preceded_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>inactivity_or_long_periods_rest_factor.id,
  :factor_group_id=>preceded_by_factor_group.id
)
foot_swelling_sitting_or_standing_preceded_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>sitting_or_standing_still_factor.id,
  :factor_group_id=>preceded_by_factor_group.id
)
foot_swelling_walking_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>walking_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
foot_swelling_brownish_urine_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>brownish_or_foamy_urine_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_easy_bleeding_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>easy_bruising_or_bleeding_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_enlarged_vein_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>enlarged_or_purplish_vein_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_entire_leg_cool_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>entire_leg_or_calf_being_pale_and_cool_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_fatigue_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>fatigue_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_entire_fatigue_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>fatigue_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_hardening_skin_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>hardening_of_skin_in_affected_area_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_heaviness_limb_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>heaviness_in_affected_limb_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_inability_bear_weight_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>inability_to_bear_weight_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_inability_point_forefoot_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>inability_to_point_forefoot_and_toes_down_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_joint_deformity_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>joint_deformity_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_lack_appetite_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>lack_appetite_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_nausea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>nausea_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_numbess_tingling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>numbness_or_tingling_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_pain_tenderness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>pain_tenderness_aching_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_persistant_cough_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>persistent_cough_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_rapid_irregular_heartbeat_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>rapid_or_irregular_heartbeat_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_redness_warmth_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>redness_or_warmth_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_shortness_breath_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_stiffness_limited_movement_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>stiffness_or_limited_movement_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_swelling_around_eyes_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>swelling_around_the_eyes_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
foot_swelling_abdommen_other_parts_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>foot_leg_swelling_symptom.id,
  :factor_id=>swelling_in_abdomen_other_parts_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

## Headache - ADULT
## ######################################
headache_extreme_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>extreme_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_mild_to_moderate_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>mild_to_moderate_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_moderate_to_severe_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>moderate_to_severe_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_pressure_or_squeezing_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>pressure_or_squeezing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_stabbing_or_burning_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>stabbing_or_burning_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_throbbing_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>throbbing_factor.id,
  :factor_group_id=>pain_is_factor_group.id
)
headache_around_face_forehead_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>around_face_or_forehead_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
headache_one_eye_radiates_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>around_one_eye_or_radiates_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
headache_around_temples_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>around_your_temples_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
headache_both_sides_head_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>on_both_sides_of_head_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
headache_one_side_head_pain_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>on_one_side_of_head_factor.id,
  :factor_group_id=>pain_located_factor_group.id
)
headache_gradual_onset_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_gradual_factor.id,
  :factor_group_id=>onset_factor_group.id
)
headache_preceded_meds_onset_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_preceded_by_meds_factor.id,
  :factor_group_id=>onset_factor_group.id
)
headache_preceded_by_visual_onset_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_preceded_by_visual_factor.id,
  :factor_group_id=>onset_factor_group.id
)
headache_sudden_onset_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_sudden_factor.id,
  :factor_group_id=>onset_factor_group.id
)
headache_less_few_min_duration_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>less_than_few_minutes_factor.id,
  :factor_group_id=>duration_is_factor_group.id
)
headache_several_hours_days_duration_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>several_hours_to_days_factor.id,
  :factor_group_id=>duration_is_factor_group.id
)
headache_several_minutes_to_hours_duration_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>several_minutes_to_few_hours_factor.id,
  :factor_group_id=>duration_is_factor_group.id
)
headache_gradually_becomes_frequent_recurrence_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>gradually_becomes_frequent_factor.id,
  :factor_group_id=>recurrence_of_headache_factor_group.id
)
headache_is_daily_recurrence_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_daily_factor.id,
  :factor_group_id=>recurrence_of_headache_factor_group.id
)
headache_is_often_at_same_time_every_date_recurrence_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>is_often_at_same_time_factor.id,
  :factor_group_id=>recurrence_of_headache_factor_group.id
)

headache_change_sleep_patterns_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>change_sleep_patterns_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_chewing_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>chewing_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_clenching_grinding_teeth_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>clenching_grinding_teeth_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_everyday_activities_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>everday_act_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_hormonal_changes_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>hormonal_changes_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_orgasm_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>orgasm_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_poor_posture_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>poor_posture_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_stress_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>stress_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_touching_face_triggered_or_worsened_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>touching_face_eating_factor.id,
  :factor_group_id=>triggered_or_worsened_by_factor_group.id
)
headache_lying_down_dark_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>lying_down_dark_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
headache_over_counter_meds_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>over_the_counter_meds_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
headache_rest_relieved_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>rest_factor.id,
  :factor_group_id=>relieved_by_factor_group.id
)
headache_achy_joints_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>achy_joints_or_muscles_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_change_personality_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>change_personality_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_confusion_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>confusion_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_difficulty_speaking_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>difficulty_speaking_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_fever_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>fever_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_jaw_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>jaw_pain_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_nausea_vomit_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>nausea_or_vomiting_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_persistant_weakness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>persistent_weakness_or_numbness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_restless_agitation_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>restlessness_or_agitation_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_runny_stuffy_nose_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>runny_or_stuffy_nose_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_seizures_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>seizures_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_sensitivty_light_noise_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>sensitivity_to_light_noise_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_stiff_neck_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>stiff_neck_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_tender_scalp_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>tender_scalp_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)
headache_vision_problems_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>headache_symptom.id,
  :factor_id=>vision_problems_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id
)

heart_palpitations_anxious_stressed_often_occur_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>youre_anxious_or_stressed_factor.id,
  :factor_group_id=>palpitations_often_occur_when_factor_group.id
)

heart_palpitations_exerting_often_occur_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>youre_exerting_factor.id,
  :factor_group_id=>palpitations_often_occur_when_factor_group.id
)
heart_palpitations_resting_going_bed_often_occur_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>youre_resting_going_bed_factor.id,
  :factor_group_id=>palpitations_often_occur_when_factor_group.id
)
heart_palpitations_faster_than_normal_heart_rate_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>faster_than_normal_factor.id,
  :factor_group_id=>heart_rate_is_factor_group.id
)
heart_palpitations_irregular_not_steady_heart_rate_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>irregular_or_not_steady_factor.id,
  :factor_group_id=>heart_rate_is_factor_group.id
)
heart_palpitations_slower_than_normal_heart_rate_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>slower_than_normal_factor.id,
  :factor_group_id=>heart_rate_is_factor_group.id
)
heart_palpitations_caffeine_alcohol_preceded_by_use_of_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>caffeine_or_alcohol_factor.id,
  :factor_group_id=>preceded_by_factor_group.id
)
heart_palpitations_cigarettes_or_rec_drugs_preceded_by_use_of_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>cigarettes_or_recreational_drugs_factor.id,
  :factor_group_id=>preceded_by_factor_group.id
)
heart_palpitations_medications_herbal_supplements_preceded_by_use_of_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>medications_or_herbal_supplements_factor.id,
  :factor_group_id=>preceded_by_factor_group.id
)
heart_palpitations_chest_pain_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>chest_pain_or_discomfort_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_dizziness_lightheadedness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>dizziness_or_lightheadedness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_fainting_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>fainting_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_headache_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>headache_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_nausea_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>nausea_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_nervousness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>nervousness_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_persistent_cough_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>persistent_cough_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_shortness_breath_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>shortness_of_breath_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_sudden_weight_loss_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>sudden_weight_loss_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_sweating_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>sweating_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_tremors_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>tremors_factor.id,
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_trouble_sleeping_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>trouble_sleeping_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id,
)
heart_palpitations_unexplained_fatigue_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>heart_palpitations_symptom.id,
  :factor_id=>unexplained_fatigue_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id,
)
## Hip Pain - ADULT
## ######################################
hip_pain_dull_achy_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>dull_achy_factor.id, 
  :factor_group_id=>pain_is_factor_group.id
)
hip_pain_sudden_intense_pain_is_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>sudden_intense_factor.id, 
  :factor_group_id=>pain_is_factor_group.id
)
hip_pain_everyday_act_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>everday_act_factor .id, 
  :factor_group_id=>triggered_by_factor_group.id
)
hip_pain_injury_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>injury_factor.id, 
  :factor_group_id=>triggered_by_factor_group.id
)
hip_pain_overuse_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>overuse_factor.id, 
  :factor_group_id=>triggered_by_factor_group.id
)
hip_pain_bruising_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>bruising_or_discoloring_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_decreased_range_motion_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>decreased_range_motion_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_bear_weight_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>inability_to_bear_weight_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_locking_catching_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>locking_or_catching_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_pain_other_joints_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>pain_in_other_joints_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_stiffness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>stiffness_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_swelling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>swelling_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_visibile_deformity_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>visible_deformity_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
hip_pain_applying_pressure_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>applying_pressure_or_trying_to_bear_weight_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
hip_pain_movement_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>movement_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
hip_pain_rest_inactivity_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>hip_pain_symptom.id,
  :factor_id=>rest_or_inactivity_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
## Knee Pain - Adult 
#########################################
knee_pain_begin_suddenly_pain_best_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>beginning_suddenly_factor.id, 
  :factor_group_id=>pain_best_described_as_factor_group.id
)
knee_pain_dull_achy_pain_best_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>dull_achy_factor.id, 
  :factor_group_id=>pain_best_described_as_factor_group.id
)
knee_pain_gradually_worse_pain_best_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>gradually_worsening_factor.id, 
  :factor_group_id=>pain_best_described_as_factor_group.id
)
knee_pain_sharp_severe_pain_best_described_as_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>sharp_severe_factor.id, 
  :factor_group_id=>pain_best_described_as_factor_group.id
)
knee_pain_one_both_sides_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>along_one_or_both_sides_of_the_knee_factor.id, 
  :factor_group_id=>located_factor_group.id
)
knee_pain_around_kneecap_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>around_the_kneecap_factor.id, 
  :factor_group_id=>located_factor_group.id
)
knee_pain_behind_knee_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>behind_the_knee_factor.id, 
  :factor_group_id=>located_factor_group.id
)
knee_pain_in_knee_joint_located_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>in_knee_joint_factor.id, 
  :factor_group_id=>located_factor_group.id
)
knee_pain_everyday_act_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>everday_act_factor.id, 
  :factor_group_id=>triggered_by_factor_group.id
)
knee_pain_injury_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>injury_factor.id, 
  :factor_group_id=>triggered_by_factor_group.id
)
knee_pain_overuse_triggered_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>overuse_factor.id, 
  :factor_group_id=>triggered_by_factor_group.id
)
knee_pain_movement_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>movement_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
knee_pain_prolonged_sitting_standing_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>prolonged_sitting_standing_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
knee_pain_rest_inactivity_worsened_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>rest_or_inactivity_factor.id, 
  :factor_group_id=>worsened_by_factor_group.id
)
knee_pain_bruising_discoloring_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>bruising_or_discoloring_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_decreased_range_motion_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>decreased_range_motion_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_instability_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>feeling_of_instability_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_fever_chills_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>fever_chills_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_grating_sensation_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>grating_sensation_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_inability_bear_weight_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>inability_to_bear_weight_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_locking_catching_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>locking_or_catching_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_pain_stiffness_other_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>pain_stiffness_in_other_joints_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_popping_snapping_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>popping_snapping_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_skin_redness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>skin_redness_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_stiffness_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>stiffness_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_swelling_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>swelling_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
)
knee_pain_warmth_touch_accompanied_by_SF = SymptomsFactor.find_or_create_by_doctor_call_worthy_and_er_worthy_and_symptom_id_and_factor_id_and_factor_group_id(
  :doctor_call_worthy=>false,
  :er_worthy=>false,
  :symptom_id=>knee_pain_symptom.id,
  :factor_id=>warmth_to_touch_factor.id, 
  :factor_group_id=>accompanied_by_factor_group.id
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
:content_id=>Content.where(:document_id=>'DS01194').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS01194').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_pulsing_near_navel_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01194').first.id
)
#Abdominal Pain - DS00274
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_lower_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_one_or_both_sides_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_coughing_or_jarring_movements_triggered_or_worsened_by_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id,
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id, 
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00274').first.id
)
#Abdominal Pain - DS00319
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stomach_growling_or_rumbling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
#Abdominal Pain - DS01153
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01153').first.id
)
#Abdominal Pain - DS00035
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_progressive_or_worsening_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
#Abdominal Pain - DS00063
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_more_fibre_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_more_water_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
#Abdominal Pain - DS00104
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
#Abdominal Pain - DS00292
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00292').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00292').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00292').first.id
)
#Abdominal Pain - DS00070
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_coughing_or_jarring_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
#Abdominal Pain - DS00289
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id ,
:content_id=>Content.where(:document_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_lower_abdomen_pain_located_SF,
:content_id=>Content.where(:document_id=>'DS00289').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_menstrual_cycle_triggered_or_worsened_by_SF,
:content_id=>Content.where(:document_id=>'DS00289').first.id
)
#Abdominal Pain - DS00981
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
#Abdominal Pain - DS00165
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=> abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00165').first.id
)
#Abdominal Pain - DS00080
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00080').first.id
)
#Abdominal Pain - DS00488
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_middle_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_alcohol_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
#Abdominal Pain - DS00823
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
#Abdominal Pain - DS00106
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
#Abdominal Pain - DS00282
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_one_or_both_sides_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00282').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00282').first.id
)
#Abdominal Pain - DS00530
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stomach_growling_or_rumbling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
#Abdominal Pain - DS00506
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_dull_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00506').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_menstrual_cycle_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00506').first.id
)
#Abdominal Pain - DS00524
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_antacids_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00524').first.id
)
#Abdominal Pain - DS00371
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_sharp_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_upper_abdomen_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_changing_position_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00371').first.id
)
#Abdominal Pain - DS00242
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_gnawing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_progressive_or_worsening_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_abdomen_but_radiates_pain_located_SF.id ,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_drinking_alcohol_triggered_or_worsened_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_stress_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_antacids_relieved_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
#Abdominal Pain - DS00098
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_burning_factor_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intense_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_steady_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
#Abdominal Pain - DS00598
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_chronic_ongoing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_intermittent_episodic_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_black_or_bloody_stool_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_inability_to_move_bowels_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
#Abdominal Pain - DS00085
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_acute_began_suddenly_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_crampy_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>abdominal_pain_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
#BLOOD IN STOOL - DS00762
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_straining_during_bowel_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
#BLOOD IN STOOL - DS00035
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_narrow_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
#BLOOD IN STOOL - DS00511
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_narrow_stools_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00511').first.id
)
#BLOOD IN STOOL - DS00063
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_more_water_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_more_fibre_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00063').first.id
)
#BLOOD IN STOOL - DS00104
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id ,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
#BLOOD IN STOOL - DS00070
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_change_in_bowel_habits_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_constipation_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
#BLOOD IN STOOL - DS00488
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_alcohol_or_caffeine_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00488').first.id
)
#BLOOD IN STOOL - DS00096
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_straining_during_bowel_movements_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_anal_itching_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00096').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00096').first.id
)
#BLOOD IN STOOL - DS00459
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00459').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00459').first.id
)
#BLOOD IN STOOL - DS00242
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_drinking_alcohol_or_caffeine_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_certain_foods_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_eating_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_nausea_or_vomiting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00242').first.id
)
#BLOOD IN STOOL - DS00705
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_painful_bowel_movements_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00705').first.id
)
#BLOOD IN STOOL - DS00598
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_stool_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_in_or_on_toilet_bowl_blood_appears_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_abdominal_pain_or_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fatigue_or_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_frequent_urge_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>blood_stool_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
#ChestPain - DS00994
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_gnawing_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_severe_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_squeezing_or_pressure_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_tight_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_exertion_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_anxiety_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_pain_neck_arms_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00994').first.id
)
#ChestPain - DS00605
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_severe_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sudden_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_tearing_or_ripping_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_faint_dizzy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rapid_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00605').first.id
)
#ChestPain - DS00939
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sudden_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00939').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_injury_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00939').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_chest_wall_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00939').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00939').first.id
)
#ChestPain - DS00626
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_gnawing_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00626').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_chest_wall_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00626').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00626').first.id
)
#ChestPain - DS00763
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_gnawing_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_burning_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_squeezing_or_pressure_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_tight_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_eating_drinking_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_diff_swallow_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
#ChestPain - DS00967
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_burning_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_burning_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_tight_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_eating_drinking_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_lying_down_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_antacids_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_belching_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_diff_swallow_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
#ChestPain - DS00094
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_severe_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_squeezing_or_pressure_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_anxiety_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_faint_dizzy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_pain_neck_arms_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rapid_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
#ChestPain - DS00061
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_intermittent_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_vaguely_uncomfortable_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_exertion_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
#ChestPain - DS00095
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_burning_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00095').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_eating_drinking_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00095').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_lying_down_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00095').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_antacids_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00095').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_belching_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00095').first.id
)
#ChestPain - DS01179
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01179').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01179').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01179').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_pain_neck_arms_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01179').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_exertion_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01179').first.id
)
#ChestPain - DS00338
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sudden_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_stress_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_anxiety_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_diff_swallow_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_faint_dizzy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rapid_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
#ChestPain - DS00505
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_achy_gnawing_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sharp_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_squeezing_or_pressure_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_bending_forward_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_dry_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00505').first.id
)
#ChestPain - DS00244
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sharp_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00244').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00244').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00244').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_dry_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00244').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00244').first.id
)
#ChestPain - DS00135
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_cough_blood_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
#ChestPain - DS00429
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_severe_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sharp_pain_described_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_exertion_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_cough_blood_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_faint_dizzy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rapid_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_deep_breath_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00429').first.id
)
#ChestPain - DS00098
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>chest_pain_rash_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00098').first.id
)

#Constipation - DS00762
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_recent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_anal_rectal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00762').first.id
)
#Constipation - DS00035
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_recent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_progressive_or_worsening_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_mucus_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00035').first.id
)
#Constipation - DS00070
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_recent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00070').first.id
)
#Constipation - DS00353
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_ongoing_recurrent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_progressive_or_worsening_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_increased_sensitivity_to_cold_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_muscle_joint_ache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_muscle_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_pale_dry_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_unex_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_unintended_weight_gain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00353').first.id
)
#Constipation - DS00823
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_recent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
#Constipation - DS00106
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_ongoing_recurrent_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_progressive_or_worsening_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_cramping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_diarrhea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>constipation_mucus_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
#Cough - DS00170
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_producing_phlegm_or_sputum_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00170').first.id
)
#Cough - DS00021
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_allergens_irritants_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_wheezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00021').first.id
)
#Cough - DS00031
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_producing_phlegm_or_sputum_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_progressive_worsening_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_wheezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00031').first.id
)
#Cough - DS00232
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_producing_phlegm_or_sputum_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00232').first.id
)
#Cough - DS00056
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_producing_phlegm_or_sputum_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sneezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_watery_itchy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
#Cough - DS00296
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_loss_appetite_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_wheezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00296').first.id
)
#Cough - DS00967
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_difficulty_swallowing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_hoarse_voice_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_wheezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
#Cough - DS00174
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_allergens_irritants_triggered_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sneezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_watery_itchy_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
#Cough - DS00081
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chills_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_loss_appetite_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_muscle_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sneezing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00081').first.id
)
#Cough - DS00366
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00366').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00366').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_hoarse_voice_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00366').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00366').first.id
)
#Cough - DS00135
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_dry_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_producing_phlegm_or_sputum_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_new_recently_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_ongoing_recurrent_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_progressive_worsening_cough_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_chills_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_headache_facial_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_muscle_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_runny_or_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>cough_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00135').first.id
)

#Diarrhea - DS00454
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_antibiotic_use_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_recent_day_week_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_mucus_in_stool_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00454').first.id
)
#Diarrhea - DS00319
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_eating_certain_foods_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloating_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_muscle_or_joint_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_unintended_weight_loss_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00319').first.id
)
#Diarrhea - DS00104
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_muscle_or_joint_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_unintended_weight_loss_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00104').first.id
)
#Diarrhea - DS00981
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_eating_suspect_food_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_sudden_hours_days_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00981').first.id
)
#Diarrhea - DS00823
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_recent_day_week_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_sudden_hours_days_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloating_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00823').first.id
)
#Diarrhea - DS00106
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_eating_certain_foods_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_constipation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_mucus_in_stool_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00106').first.id
)
#Diarrhea - DS00794
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_recent_day_week_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_sudden_hours_days_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_urgency_to_have_bowel_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00794').first.id
)
#Diarrhea - DS00530
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_eating_certain_foods_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_avoiding_certain_foods_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloating_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_passing_gas_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00530').first.id
)
#Diarrhea - DS00767
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_antibiotic_use_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_mucus_in_stool_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_urgency_to_have_bowel_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00767').first.id
)
#Diarrhea - DS00318
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_eating_suspect_food_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_recent_day_week_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloating_abdominal_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00318').first.id
)
#Diarrhea - DS00598
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_ongoing_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_bloody_stools_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_muscle_or_joint_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_unintended_weight_loss_factor_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_urgency_to_have_bowel_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00598').first.id
)
#Diarrhea - DS00085
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_recent_day_week_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_sudden_hours_days_problem_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_abdominal_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_muscle_or_joint_aches_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>diarrhea_nausea_or_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00085').first.id
)
#Diff Swallow - DS00395
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00359').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_muscle_cramps_or_twitching_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00359').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_muscle_weakness_hands_legs_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00359').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_slurred_speech_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00359').first.id
)
#Diff Swallow - HA00034
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_bad_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_dry_mouth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_hoarse_voice_or_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_thick_saliva_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'HA00034').first.id
)
#Diff Swallow - DS00500
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_swallowing_hurts_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_hoarse_voice_or_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_pain_in_chest_neck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_regurgitation_food_liquid_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00500').first.id
)
#Diff Swallow - DS00763
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_feeling_somthing_stuck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_heartburn_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_pain_in_chest_neck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_regurgitation_food_liquid_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00763').first.id
)
#Diff Swallow - DS00967
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_eating_certain_foods_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_feeling_somthing_stuck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_heartburn_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_hoarse_voice_or_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_pain_in_chest_neck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_regurgitation_food_liquid_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00967').first.id
)
#Diff Swallow - DS00580
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00580').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_heartburn_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00580').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_numbness_pain_color_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00580').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_tight_hardened_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00580').first.id
)
#Diff Swallow - DS01089
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_swallowing_hurts_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_feeling_somthing_stuck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_jaw_pain_or_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_loose_teeth_or_poorly_fitting_dentures_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_mouth_sores_lumps_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01089').first.id
)
#Diff Swallow - DS00147
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_dry_eyes_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_dry_mouth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_hoarse_voice_or_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
#Diff Swallow - DS00349
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_takes_effort_swallowing_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_bad_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_difficulty_breathing_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_earache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_feeling_somthing_stuck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_lump_in_front_of_neck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_sore_throat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>difficulty_swallowing_unintended_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00349').first.id
)
#Dizziness - DS00803
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_unsteady_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_worsening_or_progressing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_buzzing_or_ringing_in_ear_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_facial_numbness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_hearing_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00803').first.id
)
#Dizziness - DS00534
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_unsteady_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_change_in_head_or_body_position_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_blurred_or_double_vision_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00534').first.id
)
#Dizziness - DS00648
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_chest_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_severe_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00648').first.id
)
#Dizziness - DS00303
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00303').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00303').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_ear_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00303').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00303').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_hearing_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00303').first.id
)
#Dizziness - DS00290
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_chest_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_irregular_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
#Dizziness - DS00094
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_anxiety_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_chest_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_irregular_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_pain_in_chest_neck_shoulder_arm_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00094').first.id
)
#Dizziness - DS00535
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_unsteady_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_buzzing_or_ringing_in_ear_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_ear_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_hearing_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00535').first.id
)
#Dizziness - DS00120
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_severe_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
#Dizziness - DS00997
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00997').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_change_in_head_or_body_position_triggered_or_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00997').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_blurred_or_double_vision_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00997').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00997').first.id
)
#Dizziness - DS00338
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_recurrent_or_ongoing_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_anxiety_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_chest_pain_or_pressure_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_irregular_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_severe_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_shortness_of_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
#Dizziness - DS00150
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_unsteady_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_blurred_or_double_vision_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_numbness_or_weakness_one_side_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_severe_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_slurred_speech_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00150').first.id
)
#Dizziness - DS00220
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_spinning_sensation_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_lightneadedned_or_faint_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_unsteady_you_feel_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_new_or_began_suddenly_symptoms_are_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_blurred_or_double_vision_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_numbness_or_weakness_one_side_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>dizzyness_slurred_speech_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00220').first.id
)
#EyeRedness - DS00633
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stinging_or_burning_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_crusted_eyelashes_after_sleeping_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stringy_mucus_in_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00633').first.id
)
#EyeRedness - DS00487
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_severe_pain_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_runny_or_stuff_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
#EyeRedness - DS00056
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_runny_or_stuff_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00056').first.id
)
#EyeRedness - FA00037
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_severe_pain_described_as_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stinging_or_burning_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_injury_trauma_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_eye_movement_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'FA00037').first.id
)
#EyeRedness - DS00463
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_itchy_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stinging_or_burning_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stringy_mucus_in_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_warm_air_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00463').first.id
)
#EyeRedness - DS00283
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_severe_pain_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_halos_around_lights_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_eye_movement_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00283').first.id
)
#EyeRedness - DS00174
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_itchy_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_allergens_or_irritants_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_runny_or_stuff_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00174').first.id
)
#EyeRedness - DS01128
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_ache_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS01128').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS01128').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS01128').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dark_floating_spots_in_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS01128').first.id
)
#EyeRedness - DS01190
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_itchy_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stinging_or_burning_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS01190').first.id
)
#EyeRedness - DS00908
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00908').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_shimmering_or_flash_of_light_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00908').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_vision_loss_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00908').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00908').first.id
)
#EyeRedness - DS00882
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_ache_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00882').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_severe_pain_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00882').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_loss_of_color_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00882').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_vision_loss_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00882').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_eye_movement_worsened_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00882').first.id
)
#EyeRedness - DS00258
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_ache_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_itchy_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_crusted_eyelashes_after_sleeping_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stringy_mucus_in_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00258').first.id
)
#EyeRedness - DS00147
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_itchy_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_stinging_or_burning_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dry_mouth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00147').first.id
)
#EyeRedness - DS00257
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_gritty_sensation_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00257').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00257').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_excessive_tearing_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00257').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_red_painful_lump_on_eyelid_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00257').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00257').first.id
)
#EyeRedness - DS00867
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_redness_without_discomfort_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00867').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_bleeding_on_surface_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00867').first.id
)
#EyeRedness - DS00677
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_ache_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_sensitivity_to_light_described_as_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_swelling_around_eye_appearance_eye_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_blurred_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_dark_floating_spots_in_vision_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>eye_discomfort_vision_loss_problem_includes_SF.id,
:content_id=>Content.where(:document_id=>'DS00677').first.id
)
#FootAnkle - DS00737
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_back_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_back_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_injury_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_long_periods_rest_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_difficulty_pushing_off_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
#FootAnkle - DS00737
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_back_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_back_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_injury_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_difficulty_pushing_off_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_inability_bear_weight_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
#FootAnkle - DS00951
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_injury_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_feeling_of_instability_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_inability_bear_weight_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_numbness_tingling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
#FootAnkle - DS00309
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ill_fitting_shoes_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_thickened_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00309').first.id
)
#FootAnkle - DS00032
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00032').first.id
)
#FootAnkle - DS00033
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00033').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00033').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00033').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ill_fitting_shoes_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00033').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_thickened_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00033').first.id
)
#FootAnkle - DS00449
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_middle_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00449').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_flattened_arch_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00449').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00449').first.id
)
#FootAnkle - DS00090
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_long_periods_rest_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
#FootAnkle - DS00480
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00480').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ill_fitting_shoes_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00480').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00480').first.id
)
#FootAnkle - DS00111
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toenail_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00111').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ill_fitting_shoes_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00111').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00111').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00111').first.id
)
#FootAnkle - DS00496
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ill_fitting_shoes_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_burning_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_numbness_tingling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00496').first.id
)
#FootAnkle - DS00468
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00468').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_burning_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00468').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_numbness_tingling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00468').first.id
)
#FootAnkle - DS00019
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_long_periods_rest_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
#FootAnkle - DS00131
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_bottom_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_burning_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_numbness_tingling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00131').first.id
)
#FootAnkle - DS00508
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00508').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00508').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_long_periods_rest_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00508').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00508').first.id
)
#FootAnkle - DS00509
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_heel_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00509').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_toe_front_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00509').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00509').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_thickened_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00509').first.id
)
#FootAnkle - DS00020
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_long_periods_rest_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_stiffness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
#FootAnkle - DS00343
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_injury_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_feeling_of_instability_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_inability_bear_weight_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_redness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
#FootAnkle - DS00556
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_ankle_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00556').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_whole_foot_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00556').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_activity_triggered_SF.id,
:content_id=>Content.where(:document_id=>'DS00556').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_ankle_swelling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00556').first.id
)
#FootSwelling - DS00737
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_activity_overuse_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_injury_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inactivity_rest_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00737').first.id
)
#FootSwelling - DS00160
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_activity_overuse_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_injury_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inability_bear_weight_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inability_point_forefoot_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00160').first.id
)
#FootSwelling - DS00951
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_injury_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inability_bear_weight_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_numbess_tingling_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_redness_warmth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00951').first.id
)
#FootSwelling - DS00450
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00450').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00450').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00450').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00450').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_redness_warmth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00450').first.id
)
#FootSwelling - DS00373
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_easy_bleeding_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_lack_appetite_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_abdommen_other_parts_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00373').first.id
)
#FootSwelling - DS01005
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS01005').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS01005').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_sitting_or_standing_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01005').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_entire_leg_cool_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01005').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01005').first.id
)
#FootSwelling - DS00503
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_brownish_urine_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_abdommen_other_parts_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00503').first.id
)
#FootSwelling - DS00090
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00090').first.id
)
#FootSwelling - DS00061
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_lack_appetite_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_persistant_cough_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_rapid_irregular_heartbeat_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_abdommen_other_parts_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00061').first.id
)
#FootSwelling - DS00954
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_activity_overuse_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_redness_warmth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00954').first.id
)
#FootSwelling - DS00609
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_hardening_skin_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_heaviness_limb_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00609').first.id
)
#FootSwelling - DS01047
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_brownish_urine_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_lack_appetite_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_swelling_around_eyes_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS01047').first.id
)
#FootSwelling - DS00019
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_activity_overuse_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inactivity_rest_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00019').first.id
)
#FootSwelling - DS00717
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_redness_warmth_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00717').first.id
)
#FootSwelling - DS00020
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_inactivity_rest_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_joint_deformity_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00020').first.id
)
#FootSwelling - DS00343
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_ankle_foot_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_around_knee_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_injury_triggered_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_stiffness_limited_movement_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00343').first.id
)
#FootSwelling - DS00223
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_sitting_or_standing_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_enlarged_vein_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_entire_leg_cool_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00223').first.id
)
#FootSwelling - DS00256
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_whole_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_both_limbs_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_one_limb_swelling_occurs_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_sitting_or_standing_preceded_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_walking_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_enlarged_vein_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_heaviness_limb_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>foot_swelling_pain_tenderness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00256').first.id
)
#Headache - DS00281
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradually_becomes_frequent_recurrence_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_orgasm_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_change_personality_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_difficulty_speaking_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_persistant_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_vision_problems_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00281').first.id
)
#Headache - DS00487
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_extreme_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_stabbing_or_burning_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_one_eye_radiates_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_sudden_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_several_minutes_to_hours_duration_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_is_daily_recurrence_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_is_often_at_same_time_every_date_recurrence_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_restless_agitation_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_runny_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_sensitivty_light_noise_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00487').first.id
)
#Headache - DS00226
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_achy_joints_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_change_personality_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_persistant_weakness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_seizures_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_vision_problems_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00226').first.id
)
#Headache - DS00440
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_mild_to_moderate_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_throbbing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_around_temples_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_both_sides_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_one_side_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_chewing_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_achy_joints_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_jaw_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_tender_scalp_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_vision_problems_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00440').first.id
)
#Headache - DS00118
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_change_personality_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_confusion_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_seizures_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_sensitivty_light_noise_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_stiff_neck_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00118').first.id
)
#Headache - DS00120
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_extreme_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_throbbing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_both_sides_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_one_side_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_preceded_by_visual_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_sudden_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_several_hours_days_duration_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_change_sleep_patterns_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_everyday_activities_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_hormonal_changes_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_stress_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_lying_down_dark_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_nausea_vomit_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_sensitivty_light_noise_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00120').first.id
)
#Headache - DS00613
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00613').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_preceded_meds_onset_SF.id,
:content_id=>Content.where(:document_id=>'DS00613').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_is_daily_recurrence_SF.id,
:content_id=>Content.where(:document_id=>'DS00613').first.id
)
#Headache - DS00647
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_pressure_or_squeezing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_throbbing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_around_face_forehead_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_rest_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_fever_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_runny_stuffy_nose_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00647').first.id
)
#Headache - DS00355
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_both_sides_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_one_side_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_clenching_grinding_teeth_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_jaw_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00335').first.id
)
#Headache - DS00304
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_mild_to_moderate_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_moderate_to_severe_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_pressure_or_squeezing_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_both_sides_head_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_poor_posture_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_stress_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_over_counter_meds_relieved_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00304').first.id
)
#Headache - DS00446
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_extreme_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_stabbing_or_burning_pain_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_around_face_forehead_pain_located_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_less_few_min_duration_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_gradually_becomes_frequent_recurrence_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>headache_touching_face_triggered_or_worsened_SF.id,
:content_id=>Content.where(:document_id=>'DS00446').first.id
)
#Heart palpitations - DS00291
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_anxious_stressed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_exerting_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_irregular_not_steady_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_caffeine_alcohol_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_cigarettes_or_rec_drugs_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_medications_herbal_supplements_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_dizziness_lightheadedness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_fainting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00291').first.id
)
#Heart palpitations - DS00947
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_slower_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00947').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00947').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_dizziness_lightheadedness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00947').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_fainting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00947').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00947').first.id
)
#Heart palpitations - DS00290
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_anxious_stressed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_exerting_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_faster_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_irregular_not_steady_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_slower_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_caffeine_alcohol_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_cigarettes_or_rec_drugs_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_medications_herbal_supplements_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_dizziness_lightheadedness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_fainting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00290').first.id
)
#Heart palpitations - DS00344
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_faster_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_irregular_not_steady_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_nervousness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_sudden_weight_loss_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_tremors_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_trouble_sleeping_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_unexplained_fatigue_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00344').first.id
)
#Heart palpitations - DS00338
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_anxious_stressed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_faster_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_dizziness_lightheadedness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_headache_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_nausea_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_nervousness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_sweating_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_tremors_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00338').first.id
)
#Heart palpitations - DS00949
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_anxious_stressed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_resting_going_bed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_irregular_not_steady_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_caffeine_alcohol_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_cigarettes_or_rec_drugs_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_medications_herbal_supplements_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00949').first.id
)
#Heart palpitations - DS00929
###############################################################################
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_anxious_stressed_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_exerting_often_occur_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_faster_than_normal_heart_rate_is_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_caffeine_alcohol_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_cigarettes_or_rec_drugs_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_medications_herbal_supplements_preceded_by_use_of_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_chest_pain_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_dizziness_lightheadedness_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_fainting_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
ContentsSymptomsFactor.find_or_create_by_symptoms_factor_id_and_content_id(
:symptoms_factor_id=>heart_palpitations_shortness_breath_accompanied_by_SF.id,
:content_id=>Content.where(:document_id=>'DS00929').first.id
)
########################################################################
#
# DO NOT PUT ANY CONTENT AT BOTTOM OF THIS FILE. GO BEFORE SYMPTOMS CHECKER
#
#########################################################################

