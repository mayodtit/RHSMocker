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
