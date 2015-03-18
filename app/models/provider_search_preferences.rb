class ProviderSearchPreferences < ActiveRecord::Base
  attr_accessible :distance, :gender, :id, :insurance_uid, :lat, :lon, :specialty_uid

  validate :location_parameters_must_all_be_provided_together

  validates :distance, numericality: true, allow_nil: true
  validates :gender, inclusion: { in: %w(male female), message: "must be either male or female" }, allow_nil: true

  lat_lon_regex = /\A-?\d{1,3}.\d{3}\z/
  validates :lon, format: { with: lat_lon_regex, message: "must be in the format ###.###" }, allow_nil: true
  validates :lat, format: { with: lat_lon_regex, message: "must be in the format ###.###" }, allow_nil: true

  ## These are hard-coded because calling BetterDoctor messes up load ordering with web_mock in tests
  INSURANCE_VALUES = ["aetna", "aetnadental", "altius", "ameritas", "anthem", "anthembluecrossblueshield", "avmedhealth", "bcbs", "bcbsalabama", "bcbsflorida", "bcbsillinois", "bcbskansascity", "bcbsmassachusetts", "bcbsmichigan", "bcbsminnesota", "bcbsnorthcarolina", "bcbsoklahoma", "bcbstennessee", "bcbstexas", "bcbswyoming", "bluecrossblueshieldnewmexico", "bluecrossblueshieldofgeorgia", "bluecrossidaho", "blueshieldofcalifornia", "bridgespan", "capitalblue", "carefirstbcbs", "cigna", "cofinity", "connecticare", "coordinatedcareofwa", "coventry", "delta", "dentalnetwork", "dentemax", "emblemhealth", "empirebluecross", "empirebluecrossblueshield", "firstchoice", "guardiandental", "healthfirst", "healthlink", "healthnet", "highmarkbluecrossblueshield", "horizonbcbs", "humana", "ibcamerihealth", "kaiser", "lacarehealth", "lifewise", "lovelacehealthplan", "magnacare", "medicaid", "medicalmutualofohio", "medicare", "metlife", "modahealth", "molinahealthcare", "multiplan", "mvphealth", "oxfordhealth", "pacificare", "premerabcbs", "priorityhealth", "providence", "qualcare", "qualchoice", "regence", "segamorehealth", "sharphealthplan", "tuftshealthplan", "uhc", "unicare", "unitedconcordia", "unitedhealthcaredental", "vsp", "wellmark"]
  SPECIALTY_VALUES = ["acupuncturist", "addiction-medicine-anesthesiologist", "addiction-specialist", "addiction-psychiatrist", "addiction-psychologist", "allergist", "otolaryngic-allergist", "pediatric-allergist", "internist-chiropractor", "medical-examiner-chiropractor", "neurology-chiropractor", "nutrition-chiropractor", "occupational-chiropractor", "orthopedic-chiropractor", "pediatric-chiropractor", "radiology-chiropractor", "rehabilitation-chiropractor", "sports-chiropractor", "thermography-chiropractor", "chiropractor", "dietitian", "massage-therapist", "naturopathic-doctor", "nutritionist", "anesthesiologist", "critical-care-anesthesiologist", "hospice-palliative-medicine-anesthesiologist", "pain-medicine-anesthesiologist", "pediatric-anesthesiologist", "cardiologist", "interventional-cardiologist", "pediatric-cardiologist", "cardiothoracic-surgeon", "adolescent-medicine-pediatrician", "child-psychiatrist", "child-abuse-pediatrician", "developmental-behavioral-pediatrician", "neonatal-perinatal-pediatrician", "neurodevelopmental-disability-pediatrician", "critical-care-pediatrician", "pediatric-dentist", "pediatric-dermatologist", "emergency-medicine-pediatrician", "pediatric-endocrinologist", "pediatric-gastroenterologist", "pediatric-oncologist", "infectious-diseases-pediatrician", "pediatric-medical-toxicologist", "pediatric-nephrologist", "pediatric-neurologist", "pediatric-optometrist", "pediatric-orhopedic-surgeon", "pediatric-ear-nose-throat-doctor", "pediatric-pathologist", "pediatric-physical-therapist", "pediatric-pulmonologist", "pediatric-radiologist", "pediatric-rehabilitation-physiatrist", "pediatric-rheumatologist", "sleep-medicine-pediatrician", "sport-medicine-pediatrician", "pediatric-surgeon", "pediatric-transplant-hepatologist", "pediatric-urologist", "pediatrician", "colorectal-surgeon", "addiction-counselor", "counselor-specialist", "mental-health-counselor", "pastoral-counselor", "professional-counselor", "school-counselor", "critical-care-doctor", "critical-care-obgyn", "dentist", "endotontist", "general-dentist", "oral-maxillofacial-surgeon", "oral-pathologist", "oral-radiologist", "orthodontist", "periodontist", "prosthodontist", "immunodermatologist", "dermatologist", "dermatopathologist", "micrographic-surgeon", "procedural-dermatologist", "sleep-medicine-otolaryngologist", "ear-nose-throat-doctor", "otolaryngology-facial-plastic-surgeon", "otology-neurotologist", "head-neck-plastic-surgeon", "emergency-medicine-doctor", "endocrinologist", "corneal-contact-management-optometrist", "low-vision-rehabilitation-optometrist", "occupational-vision-optometrist", "ophthalmologist", "optometrist", "sports-vision-optometrist", "vision-therapy-optometrist", "gastroenterologist", "general-surgeon", "clinical-biochemical-geneticist", "clinical-cytogeneticist", "clinical-geneticist", "clinical-molecular-geneticist", "geneticist", "medical-geneticist", "geriatric-medicine-doctor", "hepatologist", "transplant-hepatologist", "hospice-care-palliative-doctor", "hospitalist", "infectious-disease-doctor", "adult-psychologist", "clinical-child-psychologist", "clinical-neurophysiologist", "clinical-psychologist", "cognitive-behavioral-psychologist", "counceling-pshychologist", "family-psychologist", "forensic-psychologist", "geriatric-psychiatrist", "group-psychotherapy-psychologist", "health-psychologist", "health-service-psychologist", "mental-retardation-psychologists", "medical-psychologist", "psychiatrist", "psychoanalyst", "psychologist", "rehabilitation-psychologist", "school-psychologist", "nephrologist", "neurologist", "neuromusculoskeletal-medicine-doctor", "neurosurgeon", "vivo-vitro-nuclear-medicine-doctor", "nuclear-cardiologist", "nuclear-imaging-doctor", "nuclear-medicine-doctor", "acute-nurse-practitioner", "adult-nurse-practitioner", "family-nurse-practitioner", "gerontology-nurse-practitioner", "neonatal-critical-care-nurse-practitioner", "neonatal-nurse-practitioner", "nurse-practitioner", "obgyn-nurse-practitioner", "pediatric-nurse-practitioner", "primary-care-nurse-practitioner", "mental-health-nurse-practitioner", "women-health-nurse-practitioner", "gynecologic-oncologist", "gynecologist", "hospice-palliative-obgyn", "maternal-fetal-medicine-obgyn", "obstetrician", "obstetrics-gynecologist", "reproductive-erndocrinologist", "oncologist", "medical-oncologist", "radiation-oncologist", "surgical-oncologist", "oral-surgeon", "reconstructive-orthopedist", "foot-ankle-orthopedist", "hand-orthopedist", "sports-medicine-orthopedist", "orthopedic-surgeon", "spine-orthopedist", "trauma-orthopedist", "interventional-pain-management-doctor", "pain-management-doctor", "anatomic-pathologist", "blood-banking-transfusion-doctor", "chemical-pathologist", "clinical-pathologist", "laboratory-medicine-doctor", "cytopathologist", "dermatopathology-doctor", "forensic-pathologist", "hematopathologist", "immunopathologist", "medical-microbiologist", "molecular-genetic-pathologist", "neuropathologist", "pathologist", "hospice-palliative-physiatrist", "neuromuscular-physiatrist", "pain-medicine-physiatrist", "sports-medicine-physiatrist", "physiatrist", "spinal-cord-injury-physiatrist", "cardiopulmonary-physical-therapist", "electrophysiology-physical-therapist", "ergonomic-physical-therapist", "geriatric-physical-therapist", "hand-physical-therapist", "human-factor-physical-therapist", "neurology-physical-therapist", "orthopedic-physical-therapist", "physical-therapist", "sport-physical-therapist", "facial-plastic-surgeon", "plastic-surgery-specialist", "plastic-surgeon", "podiatry-surgeon", "podiatry-foot-surgeon", "podiatrist", "primary-podiatry-doctor", "radiology-podiatrist", "sports-podiatrist", "aerospace-medicine-doctor", "environmental-preventive-medicine-doctor", "occupational-medicine-doctor", "preventive-medical-toxicologist", "preventive-medicine-doctor", "preventive-sports-medicine-doctor", "undersea-hyperbaric-medicine-doctor", "family-practitioner", "general-practitioner", "internist", "pulmonologist", "body-imaging-radiologist", "diagnostic-neuroimaging-radiologist", "diagnostic-radiologist", "diagnostic-ultrasound-radiologist", "hospice-palliative-medicine-radiologist", "neuroradiologist", "nuclear-radiologist", "radiological-physicist", "therapeutic-radiologist", "vascular-interventional-radiologist", "rheumatologist", "sleep-medicine-doctor", "audiologist", "hearing-aid-audiologist", "bariatric-medicine-obgyn", "speech-therapist", "sports-medicine-doctor", "urologist", "vascular-surgeon"]

  validates :insurance_uid, inclusion: { in: INSURANCE_VALUES, message: "is not a valid insurance id" }, allow_nil: true
  validates :specialty_uid, inclusion: { in: SPECIALTY_VALUES, message: "is not a valid specialty id" }, allow_nil: true

  def location_parameters_must_all_be_provided_together
    return if lat && lon && distance
    return if lat.blank? && lon.blank? && distance.blank?
    [:lat, :lon, :distance].each do |k|
      if self.send(k).blank?
        errors.add(k, "must be provided")
      end
    end
  end

  def has_location?
    !!(lat && lon && distance)
  end

  def to_h
    h = {}
    if has_location?
      h[:user_location] = { lat: lat, lon: lon }
      h[:distance] = distance
    end
    [:gender, :insurance_uid, :specialty_uid].each do |k|
      if v = self.send(k)
        h[k] = v
      end
    end
    h
  end
end
