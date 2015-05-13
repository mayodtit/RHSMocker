[
  {
    name: "Adult health examination",
    type: "Treatment::Tests",
    snomed_name: "Adult health examination",
    snomed_code: "268565007"
  },
  {
    name: "Well child visit",
    type: "Treatment::Tests",
    snomed_name: "Well child visit",
    snomed_code: "410620009"
  },
  {
    name: "Gynecologic examination",
    type: "Treatment::Tests",
    snomed_name: "Gynecologic examination",
    snomed_code: "83607001"
  },
  {
    name: "Hysterectomy",
    type: "Treatment::Surgery",
    snomed_name: "Hysterectomy",
    snomed_code: "236886002"
  },
  {
    name: "Arthroscopy of knee",
    type: "Treatment::Surgery",
    snomed_name: "Arthroscopy of knee joint",
    snomed_code: "309431009"
  },
  {
    name: "Cholecystectomy",
    type: "Treatment::Surgery",
    snomed_name: "Cholecystectomy",
    snomed_code: "38102005"
  },
  {
    name: "Appendectomy",
    type: "Treatment::Surgery",
    snomed_name: "Appendectomy",
    snomed_code: "80146002"
  },
  {
    name: "Captopril",
    type: "Treatment::Medicine",
    snomed_name: "Captopril (product)",
    snomed_code: '1187642012'
  },
  {
    name: "Capoten",
    type: "Treatment::Medicine",
    snomed_name: "Captopril (product)",
    snomed_code: '1187642012'
  },
  {
    name: "Hydrocodone",
    type: "Treatment::Medicine",
    snomed_name: "Hydrocodone (product)",
    snomed_code: '1186828010'
  },
  {
    name: "Lortab",
    type: "Treatment::Medicine",
    snomed_name: "Hydrocodone (product)",
    snomed_code: '1186828010'
  },
  {
    name: "Norco",
    type: "Treatment::Medicine",
    snomed_name: "Hydrocodone (product)",
    snomed_code: '1186828010'
  },
  {
    name: "Vicodin",
    type: "Treatment::Medicine",
    snomed_name: "Hydrocodone (product)",
    snomed_code: '1186828010'
  },
  {
    name: "Simvastatin",
    type: "Treatment::Medicine",
    snomed_name: "Simvastatin (product)",
    snomed_code: '1205450014'
  },
  {
    name: "Zocor",
    type: "Treatment::Medicine",
    snomed_name: "Simvastatin (product)",
    snomed_code: '1205450014'
  },
  {
    name: "Lisinopril",
    type: "Treatment::Medicine",
    snomed_name: "Lisinopril (product)",
    snomed_code: '1185389017'
  },
  {
    name: "Prinivil",
    type: "Treatment::Medicine",
    snomed_name: "Lisinopril (product)",
    snomed_code: '1185389017'
  },
  {
    name: "Zestril",
    type: "Treatment::Medicine",
    snomed_name: "Lisinopril (product)",
    snomed_code: '1185389017'
  },
  {
    name: "Influenza vaccination",
    type: "Treatment::Medicine",
    snomed_name: "Influenza vaccination",
    snomed_code: "86198006"
  },
  {
    name: "Anticoagulant Therapy",
    type: "Treatment::Medicine",
    snomed_name: "Anticoagulant Therapy",
    snomed_code: "182764009"
  }
].each do |treatment|
  Treatment.find_or_create_by_name(treatment.merge!(skip_reindex: true))
end
