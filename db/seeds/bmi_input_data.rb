filename = 'bmiagerev.csv'
encoding = 'ISO-8859-1'
puts "Seeding BMI input data..."
CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
  BmiDataLevel.upsert_attributes!({gender: row['Sex'],
                                  age_in_months: row['Agemos']},
                                  {power_in_transformation: row['L'],
                                   median: row['M'],
                                   coefficient_of_variation: row['S']})
end
puts "Seeding BMI input data completed!"
