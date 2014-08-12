PHA_ATTRIBUTES = [
  {
    email: 'clare@getbetter.com',
    first_name: 'Clare',
    last_name: 'W',
    bio: "Clare leads the Personal Health Assistant Team here at Better, " +
         "has a background in preventive health and psychology, and is " +
         "an amateur half-marathoner. She loves living in California " +
         "but is a Midwesterner at heart.",
    arrow_image: 'clare-arrow.png',
    avatar_image: 'clare-avatar.jpg',
    bio_image: 'clare-bio_image.png'
  },
  {
    email: 'lauren@getbetter.com',
    first_name: 'Lauren',
    last_name: 'M',
    bio: "Lauren has worked as an EMT, a disease prevention counselor, and " +
         "a clinical researcher. She's passionate about preventive care " +
         "and patient empowerment. In her free time, Lauren is an avid " +
         "cyclist who loves to hike and spend time outdoors.",
    arrow_image: 'lauren-arrow.png',
    avatar_image: 'lauren-avatar.jpg',
    bio_image: 'lauren-bio_image.png'
  },
  {
    email: 'meg@getbetter.com',
    first_name: 'Meg',
    last_name: 'M',
    bio: "Meg has a clinical background in hospice and palliative care " +
         "nursing and previously worked in research at UCSF's Integrative " +
         "Health Center. In her free time she loves to be outside, " +
         "especially running on trails.",
    arrow_image: 'meg-arrow.png',
    avatar_image: 'meg-avatar.jpg',
    bio_image: 'meg-bio_image.png'
  },
  {
    email: 'ninette@getbetter.com',
    first_name: 'Ninette',
    last_name: 'T',
    bio: "Ninette is a Registered Nurse who has worked as a floor nurse " +
         "and a discharge needs coordinator. Most recently, she worked " +
         "at Coram as a Clinical Service Liaison at UCSF and discovered " +
         "a love for House of Cards.",
    arrow_image: 'ninette-arrow.png',
    avatar_image: 'ninette-avatar.jpg',
    bio_image: 'ninette-bio_image.png'
  },
  {
    email: 'jenn@getbetter.com',
    first_name: 'Jenn',
    last_name: 'C',
    bio: "Jenn previously worked for the Centers for Disease Control and " +
         "Prevention (CDC) and Harvard Medical School & Harvard Pilgrim " +
         "Health Care. She is avid cyclist, East Coast native and has " +
         "lived in four cities in the past five years.",
    arrow_image: 'jenn-arrow.png',
    avatar_image: 'jenn-avatar.jpg',
    bio_image: 'jenn-bio_image.png'
  },
  {
    email: 'ann@getbetter.com',
    first_name: 'Ann',
    last_name: 'B',
    bio: "Ann is a lifestyle health coach specialized in building healthy " +
         "habits and managing chronic conditions. Previously, she developed " +
         "a bilingual, culturally-competent diabetes prevention program. " +
         "She loves a good laugh, exploring hiking trails, and watching " +
         "quirky documentaries.",
    arrow_image: 'ann-arrow.png',
    avatar_image: 'ann-avatar.jpg',
    bio_image: 'ann-bio_image.png'
  },
  {
    email: 'jacqueline@getbetter.com',
    first_name: 'Jacqui',
    last_name: 'B',
    bio: "Jacqui has a Master's in Public Health with a focus in Health " +
         "Education. Previously, she worked as an academic mental health " +
         "researcher and disease prevention counselor. In her free time, " +
         "she can be found concocting new recipes in her kitchen.",
    arrow_image: 'jacqui-arrow.png',
    avatar_image: 'jacqui-avatar.jpg',
    bio_image: 'jacqui-bio_image.png'
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
  m.add_role(:pha) unless m.roles.find_by_name(:pha)
  unless m.avatar_url
    image = File.open(File.join(Rails.root, 'app', 'assets', 'images', attributes[:avatar_image]))
    m.update_attributes(avatar: image)
  end
  m.create_pha_profile unless m.pha_profile
  m.pha_profile.update_attributes(bio: attributes[:bio]) unless m.pha_profile.bio
  unless m.pha_profile.bio_image_url
    image = File.open(File.join(Rails.root, 'app', 'assets', 'images', attributes[:arrow_image]))
    m.pha_profile.update_attributes(bio_image: image)
  end
end
