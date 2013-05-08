FactoryGirl.define do

  factory :content do
    sequence(:id)   {|n| "#{n}"}
    sequence(:title){|n| "Content Title #{n}"}
    body            {'This is the HTML formatted body of the content.'}
    contentsType    {'Answer'}
    abstract        {'This is the abstract of the content.'}
    question        {'What is the JSON format of content?'}
    updateDate     { Time.now }
    mayo_vocabularies {[FactoryGirl.create(:mayo_vocabulary)]}
    mayo_doc_id "AA004345"

    factory :disease_content do
      sequence(:title){|n| "Craniosynostosis #{n}" }
      body            "Definition<p>Craniosynostosis is a birth defect in which one or more of the joints between the bones of your infant's skull close prematurely, before your infant's brain is fully formed. When your baby has craniosynostosis, his or her brain can't grow in its natural shape and the head is misshapen. </p>"
      contentsType    'Disease'
      abstract        "Craniosynostosis &mdash; Comprehensive overview covers causes, treatment of this birth defect involving a baby's skull."
      question        nil

    end
  end

end
