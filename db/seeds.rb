#encoding: utf-8

CustomContent.upsert_attributes({document_id: 'RHS-FREETRIAL'}, {title: 'Welcome to Your Free Trial',
                                                                 show_call_option: true,
                                                                 show_checker_option: false,
                                                                 show_mayo_copyright: false,
                                                                 show_mayo_logo: false,
                                                                 has_custom_card: true,
                                                                 raw_body: "<p>\nIn addition to Better’s free health tools, you now have a dedicated Personal Health Assistant (PHA) and 24/7 access to Mayo Clinic nurses. To get started, tap the Your PHA button in the navigation menu and start messaging your PHA.\n</p>\n<div class=\"section-head closed\" data-section-id=\"0\">\nYour Premium benefits\n</div>\n<div class=\"section disabled\" id=\"section-0\">\n<p>\n<strong>\nYour very own Personal Health Assistant\n</strong>\n</p>\n<p>\nOur team of Personal Health Assistants (PHAs) can handle anything, from basic tasks, like coordinating immunizations for travel, to the most complicated logistics, like demystifying insurance claims. \n</p>\n<p>\nBook a short Welcome Call to discuss your needs so they can start:\n</p>\n<ul>\n<li>\nEvaluating insurance policies and medical bills\n</li>\n<li>\nCreating fitness and nutrition plans\n</li>\n<li>\nFinding new doctors and book appointments\n</li>\n<li>\nSetting up at-home prescription deliveries\n</li>\n<li>\nAnd much more\n</li>\n</ul>\n<p>\n<strong>\nExpert medical advice anytime you need it\n</strong>\n</p>\n<p>\nIf you’re in need of medical advice, or just want to talk to a nurse, your Personal Health Assistant can connect you to our Mayo Clinic Nurse line. Mayo Clinic nurses expertly handle questions about your health concerns. Even when our PHAs are off duty, Mayo Clinic nurses are available anytime you need them — even at 3 a.m. on New Year’s Day.\n</p>\n</div>\n<div class=\"section-head closed last\" data-section-id=\"1\">\nYour health tools\n</div>\n<div class=\"section disabled\" id=\"section-1\">\n<p>\n<strong>\nTailored health articles\n</strong>\n</p>\n<p>\nAll of our articles are expert-verified and cover a wide variety of topics. Every Better member receives general wellness information on the following:\n</p>\n<ul class=\"image-list\">\n<li>\n<img src=\"/assets/pill.png\">\n<span>\nConventional medicine - information on medications, procedures and advances in medicine\n</span>\n</li>\n<li>\n<img src=\"/assets/barbell.png\">\n<span>\nLifestyle & alternative - fitness, sleep, supplements and alternative treatments like acupuncture\n</span>\n</li>\n<li>\n<img src=\"/assets/mental.png\">\n<span>\nMental & emotional - stress management, work-life balance help and memory exercises\n</span>\n</li>\n<li>\n<img src=\"/assets/icecream.png\">\n<span>\nDiet & nutrition - healthy foods and recipes, portioning, and diet tips\n</span>\n</li>\n<li class=\"last\">\n<img src=\"/assets/snow.png\">\n<span>\nSeasonal - immediately relevant information based on the time of year, such as flu shots and back-to-school vaccinations\n</span>\n</li>\n</ul>\n<p>\nIf you need to find something specific, try the Search bar at the top of your home screen. \n</p>\n<p>\n<strong>\nDetailed Health Profile\n</strong>\n</p>\n<p>\nSometimes we’ll ask you questions in your home screen. This information helps us to customize information for your specific needs, and can be found in your Health Profile.\n</p>\n<p>\nAccess your Health Profile using the navigation menu at the top left of your screen. You can go into it anytime to make changes, update contact information and add family members’ health information. \n</p>\n<p>\n<strong>\nComprehensive Symptom Checker\n</strong>\n</p>\n<p>\nFind out what’s ailing you, and learn about self-care options with the Symptom Checker.\n</p>",
                                                                 raw_preview: "<div class=\"card better-background\">\n  <div class=\"body\">\n    <div class=\"title white\">\n      Welcome to Your Free Trial\n    </div>\n    <div class=\"abstract white\">\n      Tap here to learn about the benefits of Better Premium.\n    </div>\n  </div>\n  <div class=\"footer\">\n    <img src=\"/assets/small_b.png\" class=\"better-b\" alt=\"\">\n  </div>\n  <img src=\"/assets/ArrowLight.png\" class=\"open-arrow\" alt=\"\">\n</div>"})
CustomCard.upsert_attributes({unique_id: 'RHS-GENDER'}, {title: 'What is your gender?',
                                                         has_custom_card: true,
                                                         priority: 20,
                                                         raw_preview: "<div class=\"card question\">\n  <div class=\"header\">\n    What is your gender?\n  </div>\n  <div class=\"body\">\n    <img class=\"gender left\" data-gender=\"male\" src=\"/assets/IconMale.png\" alt=\"IconMale\">\n    <img class=\"gender right\" data-gender=\"female\" src=\"/assets/IconFemale.png\" alt=\"IconFemale\">\n    <img class=\"logo better-logo\" src=\"/assets/b_Small.png\" alt=\"b_Small\">\n  </div>\n  <div class=\"footer\">\n  </div>\n</div>\n"})

CustomCard.upsert_attributes({unique_id: 'RHS-SWIPE_EXPLAINER'}, {title: 'Swipe Explainer',
                                                                  raw_preview: "<div class=\"image-container\">\n<img alt=\"Swipecard\" class=\"card-image\" src=\"/assets/swipecard.png\">\n</div>",
                                                                  has_custom_card: true,
                                                                  priority: 0})

%w(nurse admin pha pha_lead).each do |role|
  Role.find_or_create_by_name!(name: role)
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

AssociationType.find_or_create_by_name(:name=>"Cousin", :gender=>nil, :relationship_type=>"family")
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

AssociationType.find_or_create_by_name(:name=> 'Spouse', :gender=>nil, :relationship_type=> 'family')
AssociationType.find_or_create_by_name(:name=> 'Family Member', :gender=>nil, :relationship_type=> 'family')

AssociationType.find_or_create_by_name(:name=>"Primary Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nurse", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Executive Health Physician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pediatrician", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Pharmacist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Lifestyle Coach", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Nutritionist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Specialist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Care Provider", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Physical Therapist", :relationship_type=>"hcp")
AssociationType.find_or_create_by_name(:name=>"Dentist", :relationship_type=>"hcp")

#Allergy.create!(:name=>"",:snomed_name=>"",:snomed_code=>"",:food_allergen=>"",:environment_allergen=>"",:medication_allergen=>"")
Allergy.find_or_create_by_name(:name=>"Alcohol",:snomed_name=>"Alcohol products allergy",:snomed_code=>"294420000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Almond Oil",:snomed_name=>"Allergy to almond oil",:snomed_code=>"418606003",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Aluminum",:snomed_name=>"Allergy to aluminum",:snomed_code=>"402306009",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Ant Sting",:snomed_name=>"Ant Sting",:snomed_code=>"403141006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Animal Dander",:snomed_name=>"Dander (animal) allergy",:snomed_code=>"620400013",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Aspartame",:snomed_name=>"Allergy to aspartame",:snomed_code=>"419180003",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Bee Sting",:snomed_name=>"Allergy to bee venom",:snomed_code=>"424213003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Boric Acid",:snomed_name=>"Boric acid allergy",:snomed_code=>"294434000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Caffeine",:snomed_name=>"Caffeine allergy",:snomed_code=>"418344001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Carrot",:snomed_name=>"Carrot allergy",:snomed_code=>"420080006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Castor Oil",:snomed_name=>"Castor Oil allergy",:snomed_code=>"294318004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cat Dander",:snomed_name=>"Cat Dander allergy",:snomed_code=>"232346004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cheese",:snomed_name=>"Cheese allergy",:snomed_code=>"300914000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Chemical",:snomed_name=>"Chemical allergy",:snomed_code=>"419199007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Chemicals",:snomed_name=>"Chemical allergy",:snomed_code=>"419199007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Chocolate",:snomed_name=>"Chocolate allergy",:snomed_code=>"300912001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Cinnamon",:snomed_name=>"Cinnamon allergy",:snomed_code=>"418397007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Coal Tar",:snomed_name=>"Coal Tar allergy",:snomed_code=>"294169006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Coconut Oil",:snomed_name=>"Coconut oil allergy",:snomed_code=>"419814004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
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
Allergy.find_or_create_by_name(:name=>"Gluten",:snomed_name=>"Gluten allergy",:snomed_code=>"2817841018",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Hornet Sting",:snomed_name=>"Hornet sting",:snomed_code=>"307427009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Horse Dander",:snomed_name=>"Horse dander allergy",:snomed_code=>"419063004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"House Dust",:snomed_name=>"House dust allergy",:snomed_code=>"232349006",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Latex",:snomed_name=>"Latex allergy",:snomed_code=>"300916003",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Legumes",:snomed_name=>"Legumes allergy",:snomed_code=>"409136006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Lithium",:snomed_name=>"Lithium allergy",:snomed_code=>"293817009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Lubricant",:snomed_name=>"Lubricant allergy",:snomed_code=>"294321002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Metal",:snomed_name=>"Metal allergy",:snomed_code=>"300915004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Mold",:snomed_name=>"Allergy to mold (disorder)",:snomed_code=>"2575109010",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Multiple Environmental",:snomed_name=>"Multiple environmental allergies",:snomed_code=>"444026000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Mushroom",:snomed_name=>"Mushroom allergy",:snomed_code=>"447961002",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Nickel",:snomed_name=>"Nickel allergy",:snomed_code=>"419788000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"No Known Allergies",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"No Allergies",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"None",:snomed_name=>"No Known Allergies",:snomed_code=>"160244002",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Nut",:snomed_name=>"Allergy to Nuts (Disorder)",:snomed_code=>"835352016",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Nuts",:snomed_name=>"Allergy to Nuts (Disorder)",:snomed_code=>"835352016",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Oat",:snomed_name=>"Oats allergy",:snomed_code=>"419342009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Olive Oil",:snomed_name=>"Olive oil allergy",:snomed_code=>"294316000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Other Allergy (Not Listed)",:snomed_name=>"Other Allergy (Not Listed)",:snomed_code=>"106190000",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Paraffin",:snomed_name=>"Paraffin allergy",:snomed_code=>"294324005",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Peanut",:snomed_name=>"Allergy to Peanuts (Disorder)",:snomed_code=>"835353014",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Peanuts",:snomed_name=>"Allergy to Peanuts (Disorder)",:snomed_code=>"835353014",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pet Dander",:snomed_name=>"Dander (animal) allergy",:snomed_code=>"620400013",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Perfume",:snomed_name=>"Perfume allergy",:snomed_code=>"300908007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pesticide",:snomed_name=>"Pesticide allergy",:snomed_code=>"294619002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Photosensitization",:snomed_name=>"Photosensitization due to sun",:snomed_code=>"258155009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Plant",:snomed_name=>"Plant allergy",:snomed_code=>"402594000",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pollen",:snomed_name=>"Pollen allergy",:snomed_code=>"300910009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pollen-Food",:snomed_name=>"Pollen-food allergy",:snomed_code=>"432807008",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Pork",:snomed_name=>"Pork allergy",:snomed_code=>"417918006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Potato",:snomed_name=>"Potato allergy",:snomed_code=>"419619007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Red Meat",:snomed_name=>"Red meat allergy",:snomed_code=>"418815008",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Rubber",:snomed_name=>"Rubber allergy",:snomed_code=>"419412007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Rye",:snomed_name=>"Rye allergy",:snomed_code=>"418184004",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Scorpion Sting",:snomed_name=>"Scorpion sting",:snomed_code=>"42292100",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seafood",:snomed_name=>"Seafood allergy",:snomed_code=>"91937001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seasonal",:snomed_name=>"Seasonal allergy",:snomed_code=>"444316004",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Seed",:snomed_name=>"Seed allergy",:snomed_code=>"419101002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Shellfish",:snomed_name=>"Shellfish allergy",:snomed_code=>"300913006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Shrimp",:snomed_name=>"Shrimp allergy",:snomed_code=>"419972009",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Silicone",:snomed_name=>"Silicone allergy",:snomed_code=>"294328008",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Spider Bite",:snomed_name=>"Spider bite allergy",:snomed_code=>"427487000",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Strawberry",:snomed_name=>"Allergy to Strawberries (Disorder)",:snomed_code=>"91938006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Strawberries",:snomed_name=>"Allergy to Strawberries (Disorder)",:snomed_code=>"91938006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Soy",:snomed_name=>"Soy protein sensitivity (disorder)",:snomed_code=>"756234018",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Sulfur",:snomed_name=>"Sulfur allergy",:snomed_code=>"294179008",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Sunlight",:snomed_name=>"Photosensitization due to sun",:snomed_code=>"258155009",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tape",:snomed_name=>"Tape allergy",:snomed_code=>"405649006",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tomato",:snomed_name=>"Tomato allergy",:snomed_code=>"418779002",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Tryptophan",:snomed_name=>"Tryptophan allergy",:snomed_code=>"293842000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Vitamin A",:snomed_name=>"Vitamin A allergy",:snomed_code=>"294923007",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Vitamin D",:snomed_name=>"Vitamin D allergy",:snomed_code=>"294924001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Vitamin K",:snomed_name=>"Vitamin K allergy",:snomed_code=>"294925000",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Walnut",:snomed_name=>"Walnut allergy",:snomed_code=>"91940001",:food_allergen=>"true",:environment_allergen=>"false",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wasp Sting",:snomed_name=>"Wasp sting allergy",:snomed_code=>"423058007",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wheat",:snomed_name=>"Wheat allergy",:snomed_code=>"402595004",:food_allergen=>"true",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Wool",:snomed_name=>"Wool allergy",:snomed_code=>"425605001",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")
Allergy.find_or_create_by_name(:name=>"Zinc",:snomed_name=>"Zinc allergy",:snomed_code=>"294950002",:food_allergen=>"false",:environment_allergen=>"true",:medication_allergen=>"false")

#Med Allergys
Allergy.find_or_create_by_name(:name=>"Penicillin",:snomed_name=>"Allergy to penicillin (disorder)",:snomed_code=>"835354015",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Insulin",:snomed_name=>"Insulin allergy (disorder)",:snomed_code=>"689744011",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Sulfonamides",:snomed_name=>"Allergy to sulfonamides (disorder)",:snomed_code=>"689744011",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Sulfa drugs",:snomed_name=>"Allergy to sulfa drugs",:snomed_code=>"152311016",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"true")
Allergy.find_or_create_by_name(:name=>"Sulpha drugs",:snomed_name=>"Allergy to sulpha drugs",:snomed_code=>"509774017",:food_allergen=>"false",:environment_allergen=>"false",:medication_allergen=>"true")

#Condition.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Condition.find_or_create_by_name(:name=>"Attention deficit hyperactivity disorder",:snomed_name=>"Attention deficit hyperactivity disorder (disorder)",:snomed_code=>"2150336014")
Condition.find_or_create_by_name(:name=>"ADHD",:snomed_name=>"Attention deficit hyperactivity disorder (disorder)",:snomed_code=>"2150336014")
Condition.find_or_create_by_name(:name=>"Anemia",:snomed_name=>"Anemia",:snomed_code=>"271737000")
Condition.find_or_create_by_name(:name=>"Anxiety disorder",:snomed_name=>"Anxiety disorder (disorder)",:snomed_code=>"581863017")
Condition.find_or_create_by_name(:name=>"Anxiety",:snomed_name=>"Anxiety disorder (disorder)",:snomed_code=>"581863017")
Condition.find_or_create_by_name(:name=>"Akureyri disease",:snomed_name=>"Chronic fatigue syndrome (disorder)",:snomed_code=>"790741013")
Condition.find_or_create_by_name(:name=>"Arthritis",:snomed_name=>"Arthritis (disorder)",:snomed_code=>"769074019")
Condition.find_or_create_by_name(:name=>"Autistic disorder",:snomed_name=>"Autistic disorder (disorder)",:snomed_code=>"2464307018")
Condition.find_or_create_by_name(:name=>"Autism",:snomed_name=>"Autistic disorder (disorder)",:snomed_code=>"2464307018")
Condition.find_or_create_by_name(:name=>"Autistic",:snomed_name=>"Autistic disorder (disorder)",:snomed_code=>"2464307018")
Condition.find_or_create_by_name(:name=>"Alzheimer's disease",:snomed_name=>"Alzheimer's disease",:snomed_code=>"26929004")
Condition.find_or_create_by_name(:name=>"Asthma",:snomed_name=>"Asthma",:snomed_code=>"195967001")
Condition.find_or_create_by_name(:name=>"Allergic rhinitis",:snomed_name=>"Allergic rhinitis",:snomed_code=>"61582004")
Condition.find_or_create_by_name(:name=>"Bipolar disorder",:snomed_name=>"Bipolar disorder (disorder)",:snomed_code=>"739182010")
Condition.find_or_create_by_name(:name=>"Celiac disease",:snomed_name=>"Celiac disease (disorder)",:snomed_code=>"1764248012")
Condition.find_or_create_by_name(:name=>"Chlamydia",:snomed_name=>"Chlamydia trachomatis infection (disorder)",:snomed_code=>"629754016")
Condition.find_or_create_by_name(:name=>"Chronic fatigue syndrome",:snomed_name=>"Chronic fatigue syndrome (disorder)",:snomed_code=>"790741013")
Condition.find_or_create_by_name(:name=>"Chronic sinusitis",:snomed_name=>"Chronic sinusitis (disorder)",:snomed_code=>"776625019")
Condition.find_or_create_by_name(:name=>"Crohn's disease",:snomed_name=>"Crohn's disease",:snomed_code=>"34000006")
Condition.find_or_create_by_name(:name=>"Crohns disease",:snomed_name=>"Crohn's disease",:snomed_code=>"34000006")
Condition.find_or_create_by_name(:name=>"Clap",:snomed_name=>"Gonorrhea (disorder)",:snomed_code=>"742488016")
Condition.find_or_create_by_name(:name=>"Colitis (Ulcerative)",:snomed_name=>"Ulcerative colitis",:snomed_code=>"64766004")
Condition.find_or_create_by_name(:name=>"Coronary arteriosclerosis",:snomed_name=>"Coronary arteriosclerosis",:snomed_code=>"53741008")
Condition.find_or_create_by_name(:name=>"Cystic fibrosis",:snomed_name=>"Cystic fibrosis (disorder)",:snomed_code=>"574544017")
Condition.find_or_create_by_name(:name=>"Cystic fibrosis of pancreas",:snomed_name=>"Cystic fibrosis of pancreas (disorder)",:snomed_code=>"624511014")
Condition.find_or_create_by_name(:name=>"Cystic fibrosis of the lung",:snomed_name=>"Cystic fibrosis of the lung (disorder)",:snomed_code=>"828843013")
Condition.find_or_create_by_name(:name=>"Depressive Disorder",:snomed_name=>"Depressive disorder",:snomed_code=>"35489007")
Condition.find_or_create_by_name(:name=>"Depression",:snomed_name=>"Depressive disorder",:snomed_code=>"35489007")
Condition.find_or_create_by_name(:name=>"Diabetes",:snomed_name=>"Diabetes mellitus",:snomed_code=>"73211009")
Condition.find_or_create_by_name(:name=>"Dysthymia",:snomed_name=>"Dysthymia (disorder)",:snomed_code=>"819632011")
Condition.find_or_create_by_name(:name=>"Fatigue",:snomed_name=>"Chronic fatigue syndrome (disorder)",:snomed_code=>"790741013")
Condition.find_or_create_by_name(:name=>"Flu",:snomed_name=>"Influenza (disorder)",:snomed_code=>"800481016")
Condition.find_or_create_by_name(:name=>"Gonorrhea",:snomed_name=>"Gonorrhea (disorder)",:snomed_code=>"742488016")
Condition.find_or_create_by_name(:name=>"Gonorrhea of the rectum",:snomed_name=>"Gonorrhea of rectum (disorder)",:snomed_code=>"779679012")
Condition.find_or_create_by_name(:name=>"Hypothyroidism",:snomed_name=>"Hypothyroidism",:snomed_code=>"40930008")
Condition.find_or_create_by_name(:name=>"Hypercholesterolemia",:snomed_name=>"Hypercholesterolemia",:snomed_code=>"13644009")
Condition.find_or_create_by_name(:name=>"Headache",:snomed_name=>"Sick headache (disorder)",:snomed_code=>"576870011")
Condition.find_or_create_by_name(:name=>"High Cholesterol",:snomed_name=>"Hypercholesterolemia",:snomed_code=>"13644009")
Condition.find_or_create_by_name(:name=>"Hypertensive disorder",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"1202949014")
Condition.find_or_create_by_name(:name=>"Hypertension",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"1202949014")
Condition.find_or_create_by_name(:name=>"High Blood Pressure",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"1202949014")
Condition.find_or_create_by_name(:name=>"Ischemic stroke",:snomed_name=>"Ischemic stroke (disorder)",:snomed_code=>"2640187017")
Condition.find_or_create_by_name(:name=>"Insomnia",:snomed_name=>"Insomnia (disorder)",:snomed_code=>"577354013")
Condition.find_or_create_by_name(:name=>"Influenza",:snomed_name=>"Influenza (disorder)",:snomed_code=>"800481016")
Condition.find_or_create_by_name(:name=>"Evelated Blood Pressure",:snomed_name=>"Hypertensive disorder, systemic arterial",:snomed_code=>"1202949014")
Condition.find_or_create_by_name(:name=>"Epilepsy",:snomed_name=>"Epilepsy (disorder)",:snomed_code=>"826667014")
Condition.find_or_create_by_name(:name=>"Hyperlipidemia",:snomed_name=>"Hyperlipidemia",:snomed_code=>"55822004")
Condition.find_or_create_by_name(:name=>"Gastroesophageal reflux",:snomed_name=>"Gastroesophageal reflux",:snomed_code=>"235595009")
Condition.find_or_create_by_name(:name=>"Gastritis",:snomed_name=>"Gastritis (disorder)",:snomed_code=>"782813014")
Condition.find_or_create_by_name(:name=>"Gout",:snomed_name=>"Gout (disorder)",:snomed_code=>"833690019")
Condition.find_or_create_by_name(:name=>"Type 2 Diabetes",:snomed_name=>"Diabetes mellitus type 2",:snomed_code=>"44054006")
#Condition.find_or_create_by_name(:name=>"Essential Hypertension",:snomed_name=>"Essential hypertension",:snomed_code=>"59621000")
Condition.find_or_create_by_name(:name=>"Obesity",:snomed_name=>"Obesity",:snomed_code=>"414916001")
Condition.find_or_create_by_name(:name=>"Overwieght",:snomed_name=>"Obesity",:snomed_code=>"414916001")
Condition.find_or_create_by_name(:name=>"Lewy body dementia",:snomed_name=>"Senile dementia of the Lewy body type",:snomed_code=>"312991009")
Condition.find_or_create_by_name(:name=>"Frontotemporal dementia",:snomed_name=>"Frontotemporal dementia",:snomed_code=>"230270009")
Condition.find_or_create_by_name(:name=>"Ulcerative colitis",:snomed_name=>"Ulcerative colitis",:snomed_code=>"64766004")
Condition.find_or_create_by_name(:name=>"Kidney Stone",:snomed_name=>"Kidney Stone (disorder)",:snomed_code=>"839752010")
Condition.find_or_create_by_name(:name=>"Glaucoma",:snomed_name=>"Glaucoma (disorder)",:snomed_code=>"753570014")
Condition.find_or_create_by_name(:name=>"Graves' disease",:snomed_name=>"Graves' disease (disorder)",:snomed_code=>"726751012")
Condition.find_or_create_by_name(:name=>"Graves disease",:snomed_name=>"Graves' disease (disorder)",:snomed_code=>"726751012")
Condition.find_or_create_by_name(:name=>"Juvenile Graves' disease",:snomed_name=>"Juvenile Graves' disease (disorder)",:snomed_code=>"626606018")
Condition.find_or_create_by_name(:name=>"Juvenile Graves disease",:snomed_name=>"Juvenile Graves' disease (disorder)",:snomed_code=>"626606018")
Condition.find_or_create_by_name(:name=>"Nervous breakdown",:snomed_name=>"Dysthymia (disorder)",:snomed_code=>"819632011")
Condition.find_or_create_by_name(:name=>"Manic-depressive illness",:snomed_name=>"Bipolar disorder (disorder)",:snomed_code=>"739182010")
Condition.find_or_create_by_name(:name=>"Panic Attacks",:snomed_name=>"Panic disorder (disorder)",:snomed_code=>"1196930010")
Condition.find_or_create_by_name(:name=>"Pregnant",:snomed_name=>"Patient currently pregnant (finding)",:snomed_code=>"818210015")
Condition.find_or_create_by_name(:name=>"Postpartum depression",:snomed_name=>"Postpartum depression (disorder)",:snomed_code=>"797465010")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis",:snomed_name=>"Rheumatoid arthritis (disorder)",:snomed_code=>"809891012")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of shoulder",:snomed_name=>"Rheumatoid arthritis of shoulder (disorder)",:snomed_code=>"586674011")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of elbow",:snomed_name=>"Rheumatoid arthritis of elbow (disorder)",:snomed_code=>"586677016")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of wrist",:snomed_name=>"Rheumatoid arthritis of wrist (disorder)",:snomed_code=>"586680015")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of hip",:snomed_name=>"Rheumatoid arthritis of hip (disorder)",:snomed_code=>"586684012")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of knee",:snomed_name=>"Rheumatoid arthritis of knee (disorder)",:snomed_code=>"586686014")
Condition.find_or_create_by_name(:name=>"Rheumatoid arthritis of ankle",:snomed_name=>"Rheumatoid arthritis of ankle (disorder)",:snomed_code=>"586688010")
Condition.find_or_create_by_name(:name=>"Scabies",:snomed_name=>"Infestation by Sarcoptes scabiei var hominis (disorder)",:snomed_code=>"732919013")
Condition.find_or_create_by_name(:name=>"Sinusitis",:snomed_name=>"Sinusitis (disorder)",:snomed_code=>"768784019")
Condition.find_or_create_by_name(:name=>"Sjögren's syndrome",:snomed_name=>"Sjögren's syndrome (disorder)",:snomed_code=>"825633012")
Condition.find_or_create_by_name(:name=>"Sjogren's syndrome",:snomed_name=>"Sjögren's syndrome (disorder)",:snomed_code=>"825633012")
Condition.find_or_create_by_name(:name=>"Stroke",:snomed_name=>"Cerebrovascular accident (disorder)",:snomed_code=>"618532011")
Condition.find_or_create_by_name(:name=>"Thyroid disease",:snomed_name=>"Disorder of thyroid gland (disorder)",:snomed_code=>"2461417011")
Condition.find_or_create_by_name(:name=>"Thyroid infection",:snomed_name=>"Thyroid infection (disorder)",:snomed_code=>"709102012")
Condition.find_or_create_by_name(:name=>"Thyroid gland hematoma",:snomed_name=>"Thyroid gland hematoma (disorder)",:snomed_code=>"654809011")
Condition.find_or_create_by_name(:name=>"Thyroid gland blood clot",:snomed_name=>"Thyroid gland hematoma (disorder)",:snomed_code=>"654809011")
Condition.find_or_create_by_name(:name=>"Underactive Thyroid",:snomed_name=>"Hypothyroidism",:snomed_code=>"40930008")
Condition.find_or_create_by_name(:name=>"Upper respiratory infection",:snomed_name=>"Upper respiratory infection",:snomed_code=>"54150009")
Condition.find_or_create_by_name(:name=>"Urinary tract infectious disease",:snomed_name=>"Urinary tract infectious disease",:snomed_code=>"68566005")
Condition.find_or_create_by_name(:name=>"Vascular dementia",:snomed_name=>"Vascular dementia",:snomed_code=>"429998004")

#Cancer Conditions
Condition.find_or_create_by_name(:name=>"Colon Cancer",:snomed_name=>"Malignant tumor of colon (disorder)",:snomed_code=>"755227010")
Condition.find_or_create_by_name(:name=>"Rectal Cancer",:snomed_name=>"Malignant tumor of rectum (disorder)",:snomed_code=>"755166011")
Condition.find_or_create_by_name(:name=>"Breast Cancer",:snomed_name=>"Malignant tumor of breast (disorder)",:snomed_code=>"645787019")
Condition.find_or_create_by_name(:name=>"Thyroid Cancer",:snomed_name=>"Malignant tumor of thyroid gland (disorder)",:snomed_code=>"755307011")
Condition.find_or_create_by_name(:name=>"Prostate Cancer",:snomed_name=>"Malignant tumor of prostate (disorder)",:snomed_code=>"1766988013")
Condition.find_or_create_by_name(:name=>"Pancreatic cancer",:snomed_name=>"Malignant tumor of pancreas (disorder)",:snomed_code=>"755240017")
Condition.find_or_create_by_name(:name=>"Lung cancer",:snomed_name=>"Malignant tumor of lung (disorder)",:snomed_code=>"755174012")
Condition.find_or_create_by_name(:name=>"Melanoma",:snomed_name=>"Malignant melanoma (disorder)",:snomed_code=>"1197537014")
Condition.find_or_create_by_name(:name=>"Skin cancer",:snomed_name=>"Malignant melanoma (disorder)",:snomed_code=>"1197537014")
Condition.find_or_create_by_name(:name=>"Kidney Cancer",:snomed_name=>"Malignant tumor of kidney (disorder)",:snomed_code=>"755351019")
Condition.find_or_create_by_name(:name=>"Bladder Cancer",:snomed_name=>"Malignant tumor of urinary bladder (disorder)",:snomed_code=>"1767246018")
Condition.find_or_create_by_name(:name=>"Leukemia",:snomed_name=>"Leukemia, disease (disorder)",:snomed_code=>"836815016")

#Treatment.create!(:name=>"",:snomed_name=>"",:snomed_code=>"")
Treatment::Tests.find_or_create_by_name(:name=>"Adult health examination", :snomed_name=>"Adult health examination",:snomed_code=>"268565007")
Treatment::Tests.find_or_create_by_name(:name=>"Well child visit", :snomed_name=>"Well child visit",:snomed_code=>"410620009")
Treatment::Tests.find_or_create_by_name(:name=>"Gynecologic examination", :snomed_name=>"Gynecologic examination",:snomed_code=>"83607001")

Treatment::Surgery.find_or_create_by_name(:name=>"Hysterectomy", :snomed_name=>"Hysterectomy",:snomed_code=>"236886002")
Treatment::Surgery.find_or_create_by_name(:name=>"Arthroscopy of knee", :snomed_name=>"Arthroscopy of knee joint",:snomed_code=>"309431009")
Treatment::Surgery.find_or_create_by_name(:name=>"Cholecystectomy", :snomed_name=>"Cholecystectomy",:snomed_code=>"38102005")
Treatment::Surgery.find_or_create_by_name(:name=>"Appendectomy",:snomed_name=>"Appendectomy",:snomed_code=>"80146002")

Treatment::Medicine.find_or_create_by_name(:name => "Captopril", :snomed_name => "Captopril (product)", :snomed_code => '1187642012')
Treatment::Medicine.find_or_create_by_name(:name => "Capoten", :snomed_name => "Captopril (product)", :snomed_code => '1187642012')
Treatment::Medicine.find_or_create_by_name(:name => "Hydrocodone", :snomed_name => "Hydrocodone (product)", :snomed_code => '1186828010')
Treatment::Medicine.find_or_create_by_name(:name => "Lortab", :snomed_name => "Hydrocodone (product)", :snomed_code => '1186828010')
Treatment::Medicine.find_or_create_by_name(:name => "Norco", :snomed_name => "Hydrocodone (product)", :snomed_code => '1186828010')
Treatment::Medicine.find_or_create_by_name(:name => "Vicodin", :snomed_name => "Hydrocodone (product)", :snomed_code => '1186828010')
Treatment::Medicine.find_or_create_by_name(:name => "Simvastatin", :snomed_name => "Simvastatin (product)", :snomed_code => '1205450014')
Treatment::Medicine.find_or_create_by_name(:name => "Zocor", :snomed_name => "Simvastatin (product)", :snomed_code => '1205450014')
Treatment::Medicine.find_or_create_by_name(:name => "Lisinopril", :snomed_name => "Lisinopril (product)", :snomed_code => '1185389017')
Treatment::Medicine.find_or_create_by_name(:name => "Prinivil", :snomed_name => "Lisinopril (product)", :snomed_code => '1185389017')
Treatment::Medicine.find_or_create_by_name(:name => "Zestril", :snomed_name => "Lisinopril (product)", :snomed_code => '1185389017')
Treatment::Medicine.find_or_create_by_name(:name => "Influenza vaccination", :snomed_name=>"Influenza vaccination",:snomed_code=>"86198006")
Treatment::Medicine.find_or_create_by_name(:name => "Anticoagulant Therapy", :snomed_name=>"Anticoagulant Therapy",:snomed_code=>"182764009")


Agreement.find_or_create_by_active!(active: true, text: 'Seeded test agreement')

# Service Types -
ServiceType.find_or_create_by_name(name: 'other', bucket: 'other')

# Insurance --
ServiceType.find_or_create_by_name(name: 'benefit evaluation', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'claims', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'cost estimation', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'deductible/FSA/HSA status assessment', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'eligibility check', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'grievances', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'insurance plan - search', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'insurance plan - buying/applying', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'PHA designation for authorization', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'pre/prior authorization for service', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'temporary insurance', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'other insurance', bucket: 'insurance')

# Care Coordination --
ServiceType.find_or_create_by_name(name: 'appointment booking', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'appointment preparation', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'facility search (hospital, assisted living, etc)', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'specialist/2nd opinion', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'medical/clinical research', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'natural disaster preparedness', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'provider search', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'record recovery', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'prescription management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'symptom management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'other care coordination', bucket: 'care coordination')

# Engagement --
ServiceType.find_or_create_by_name(name: 'member onboarding', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'preventive care reminders', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 're-engagement', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'relevant content', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'themed months questions and content', bucket: 'engagement')
s = ServiceType.find_by_name('other care engagement')
s.destroy if s
ServiceType.find_or_create_by_name(name: 'other engagement', bucket: 'engagement')

# Wellness --
ServiceType.find_or_create_by_name(name: 'exercise assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'nutrition assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'sleep assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'stress assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'wellness research', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'other wellness', bucket: 'wellness')

UserRequestType.find_or_create_by_name(name: :appointment)

mw = MessageWorkflow.find_or_create_by_name(name: 'Automated Onboarding')
mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1'}, {text: "Hi *|member_first_name|*, I'm *|sender_first_name|*, your Personal Health Assistant, and I’m here to help simplify your health care experience. First, I'd like to get to know you with a 10-minute Welcome Call so I can design a comprehensive plan to work on together. You can schedule it through the app, or just send me a time that works for you"})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 1)
end

mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2'}, {text: "Hi *|member_first_name|*,\n" +
                                                                                        "I know you’re busy, but that's why I'm here. Take 10 minutes for your health and let's get started with a welcome call. Here are a few ways I've helped our members:\n" +
                                                                                        " -Find a doctor or specialist and book an appointment\n" +
                                                                                        " -Answer insurance questions\n" +
                                                                                        " -Set up home prescription delivery\n" +
                                                                                        " -Work on a healthy eating routine\n" +
                                                                                        "Is there anything we can get started with right away? Just reply below."})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 4)
end

mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3'}, {text: "In addition to your yearly physical, dentist appointment, and flu shot, you should also have the following tests done:\n" +
                                                                                        " -Blood pressure and blood sugar check every 2 years\n" +
                                                                                        " -Full blood panel every 5 years\n" +
                                                                                        " -Eye exam every 5-10 years if you have no vision problems\n" +
                                                                                        "Are you up to date? Let me find you a primary care doctor or optometrist and book you an appointment."})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 6)
end

mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4'}, {text: "Do you have any family members you would like to add to your membership? I can provide services for anyone you consider family."})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 8)
end

mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 5'}, {text: "Hi *|member_first_name|*,\n" +
                                                                                        "Are you ready for the summer sun? Consider these helpful tips for sunscreen.\n" +
                                                                                        "Find:\n" +
                                                                                        " - SPF 30 or higher\n" +
                                                                                        " - \"Broad Spectrum\" to protect against UVA/UVB rays\n" +
                                                                                        " - Water Resistant for 40-80 min\n" +
                                                                                        "Apply:\n" +
                                                                                        " - 30 min before going outdoors\n" +
                                                                                        " - Repeat every 2 hours\n" +
                                                                                        "Reduce exposure:\n" +
                                                                                        " - Avoid peak hours (10am-2pm) even on overcast days\n" +
                                                                                        " - Wear protective clothing (e.g., swim shirts, long sleeves and hats)\n" +
                                                                                        " - Check sunscreen expiration date"})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 11)
end

mt = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 6'}, {text: "Hi *|member_first_name|*,\n\n" +
                                                                                        "Your free trial ends today, but you can extend your Better Premium membership by going to your \"Health Profile,\" tapping on \"Settings\" and then on \"Subscription Plan\". There you will enter your credit card number to subscribe for $49.99 a month.\n\n" +
                                                                                        "If you decide it's not for you right now, please enjoy free access to our library of Mayo Clinic content. You can always subscribe later if you change your mind and need assistance with your healthcare needs.\n\n" +
                                                                                        "Take care,\n" +
                                                                                        "*|sender_first_name|*"})
unless mw.message_templates.find_by_name(mt.name)
  mw.message_workflow_templates.create(message_template: mt,
                                       days_delayed: 14)
end
