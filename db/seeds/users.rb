PHA_ATTRIBUTES = [
  {
    email: 'clare@getbetter.com',
    first_name: 'Clare',
    last_name: 'W',
    gender: 'female',
    bio: "Clare leads the Personal Health Assistant Team here at Better, " +
         "has a background in preventive health and psychology, and is " +
         "an amateur half-marathoner. She loves living in California " +
         "but is a Midwesterner at heart.",
    first_person_bio: "I’m experienced in digital health and mental wellness. I’m also an amateur half-marathoner and love living in California, but I’m a Midwesterner at heart.",
    arrow_image: 'clare-arrow.png',
    avatar_image: 'clare-avatar.jpg',
    bio_image: 'clare-bio_image.png'
  },
  {
    email: 'lauren@getbetter.com',
    first_name: 'Lauren',
    last_name: 'M',
    gender: 'female',
    bio: "Lauren has worked as an EMT, a disease prevention counselor, and " +
         "a clinical researcher. She's passionate about preventive care " +
         "and patient empowerment. In her free time, Lauren is an avid " +
         "cyclist who loves to hike and spend time outdoors.",
    first_person_bio: "I’ve worked as an EMT, counselor, and clinical researcher. In my free time, I’m an avid cyclist who loves to spend time outdoors.",
    arrow_image: 'lauren-arrow.png',
    avatar_image: 'lauren-avatar.jpg',
    bio_image: 'lauren-bio_image.png'
  },
  {
    email: 'meg@getbetter.com',
    first_name: 'Meg',
    last_name: 'M',
    gender: 'female',
    bio: "Meg has a clinical background in hospice and palliative care " +
         "nursing and previously worked in research at UCSF's Integrative " +
         "Health Center. In her free time she loves to be outside, " +
         "especially running on trails.",
    first_person_bio: "I’m a nurse and clinical researcher who specializes in palliative care and caring for the aging. I’m from North Carolina and love to be outside, especially running on trails.",
    arrow_image: 'meg-arrow.png',
    avatar_image: 'meg-avatar.jpg',
    bio_image: 'meg-bio_image.png'
  },
  {
    email: 'ninette@getbetter.com',
    first_name: 'Ninette',
    last_name: 'T',
    gender: 'female',
    bio: "Ninette is a Registered Nurse who has worked as a floor nurse " +
         "and a discharge needs coordinator. Most recently, she worked " +
         "at Coram as a Clinical Service Liaison at UCSF and discovered " +
         "a love for House of Cards.",
    first_person_bio: "I’m a nurse and specialize in transitions in care. I recently discovered a love for House of Cards.",
    arrow_image: 'ninette-arrow.png',
    avatar_image: 'ninette-avatar.jpg',
    bio_image: 'ninette-bio_image.png'
  },
  {
    email: 'jenn@getbetter.com',
    first_name: 'Jenn',
    last_name: 'C',
    gender: 'female',
    bio: "Jenn previously worked for the Centers for Disease Control and " +
         "Prevention (CDC) and Harvard Medical School & Harvard Pilgrim " +
         "Health Care. She is an avid cyclist, East Coast native and has " +
         "lived in four cities in the past five years.",
    first_person_bio: "I’ve worked for the Centers for Disease Control and Prevention and Harvard Medical School. I’m an avid cyclist, East coast native, and make a mean green smoothie.",
    arrow_image: 'jenn-arrow.png',
    avatar_image: 'jenn-avatar.jpg',
    bio_image: 'jenn-bio_image.png'
  },
  {
    email: 'ann@getbetter.com',
    first_name: 'Ann',
    last_name: 'B',
    gender: 'female',
    bio: "Ann is a lifestyle health coach specialized in building healthy " +
         "habits and managing chronic conditions. Previously, she developed " +
         "a bilingual, culturally-competent diabetes prevention program. " +
         "She loves a good laugh, exploring hiking trails, and watching " +
         "quirky documentaries.",
    first_person_bio: "I’m a bilingual health coach specializing in diabetes and managing medical conditions. I’m a caregiver for my parents, and love a good laugh and exploring hiking trails.",
    arrow_image: 'ann-arrow.png',
    avatar_image: 'ann-avatar.jpg',
    bio_image: 'ann-bio_image.png'
  },
  {
    email: 'jacqueline@getbetter.com',
    first_name: 'Jacqui',
    last_name: 'B',
    gender: 'female',
    bio: "Jacqui has a Master's in Public Health with a focus in Health " +
         "Education. Previously, she worked as an academic mental health " +
         "researcher and disease prevention counselor. In her free time, " +
         "she can be found concocting new recipes in her kitchen.",
    first_person_bio: "I have a Master’s in Public Health with a focus in health education. In my free time, I enjoy cooking new recipes in my kitchen.",
    arrow_image: 'jacqui-arrow.png',
    avatar_image: 'jacqui-avatar.jpg',
    bio_image: 'jacqui-bio_image.png'
  },
  {
    email: 'crystal@getbetter.com',
    first_name: 'Crystal',
    last_name: 'S',
    gender: 'female',
    bio: 'Crystal is a registered dietitian and certified medical ' +
         'assistant. She is originally from the Midwest and enjoys ' +
         'cooking, yoga, and being outdoors.',
    first_person_bio: "I’m a registered dietitian and certified medical assistant. I’m originally from the Midwest and enjoy cooking, yoga, and being outdoors.",
    arrow_image: 'crystal-arrow.png',
    avatar_image: 'crystal-avatar.jpg',
    bio_image: 'crystal-bio_image.png'
  },
  {
    email: 'elbret@getbetter.com',
    first_name: 'Elbret',
    last_name: 'B',
    gender: 'female',
    bio: "Elbret is experienced in patient advocacy, health education and awareness, and insurance issues. In her free time, she enjoys cardio kickboxing classes and reading interior design magazines.",
    first_person_bio: "I’m experienced in patient advocacy, health education and awareness, and insurance issues. In my free time, I enjoy cardio kickboxing classes and reading interior design magazines.",
    arrow_image: 'elbret-arrow.png',
    avatar_image: 'elbret-avatar.jpg',
    bio_image: 'elbret-bio_image.png'
  },
  {
    email: 'caitlin@getbetter.com',
    first_name: 'Caitlin',
    last_name: 'P',
    gender: 'female',
    bio: "Caitlin has worked as a physical therapy aide and an EMT. She loves music and her favorite stress relievers are playing violin and hiking (though usually not at the same time).",
    first_person_bio: "I’ve worked as a physical therapy aide and an EMT. I love music and my favorite stress relievers are playing violin and hiking (though usually not at the same time).",
    arrow_image: 'caitlin-arrow.png',
    avatar_image: 'caitlin-avatar.jpg',
    bio_image: 'caitlin-bio_image.png'
  }
]

PHA_ATTRIBUTES.each do |attributes|
  create_attributes = {
    email: attributes[:email],
    password: 'password',
    first_name: attributes[:first_name],
    last_name: attributes[:last_name]
  }
  if Agreement.active
    create_attributes[:user_agreements_attributes] = [{
      agreement_id: Agreement.active.id,
      user_agent: 'seeds',
      ip_address: 'seeds'
    }]
  end
  m = Member.find_or_create_by_email(create_attributes)
  m.update_attributes(first_name: attributes[:first_name],
                      last_name: attributes[:last_name])
  m.add_role(:pha) unless m.roles.find_by_name(:pha)
  image = File.open(File.join(Rails.root, 'app', 'assets', 'images', attributes[:avatar_image]))
  m.update_attributes(avatar: image)
  m.create_pha_profile(capacity_weight: 100) unless m.pha_profile
  m.pha_profile.update_attributes(bio: attributes[:bio], first_person_bio: attributes[:first_person_bio])
  image = File.open(File.join(Rails.root, 'app', 'assets', 'images', attributes[:arrow_image]))
  m.pha_profile.update_attributes(bio_image: image)
  image = File.open(File.join(Rails.root, 'app', 'assets', 'images', attributes[:bio_image]))
  m.pha_profile.update_attributes(full_page_bio_image: image)
  m.update_attributes(gender: attributes[:gender])
end

Member.upsert_attributes({email: 'testphone+robot@getbetter.com'}, {first_name: 'Better', last_name: '', avatar_url_override: 'http://i.imgur.com/eU3p9Hj.jpg'})

Member.upsert_attributes({email: 'geoff@getbetter.com'}, {first_name: 'Geoff', last_name: 'Clapp'}).tap do |m|
  m.add_role :pha unless m.pha?
end

Member.find_by_email('caitlin@getbetter.com').pha_profile.update_attributes(:weekly_capacity => 0)
