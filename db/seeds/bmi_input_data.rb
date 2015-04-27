filename = 'bmiagerev.csv'
encoding = 'ISO-8859-1'
puts "Seeding BMI input data..."
CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
  BmiDataLevel.upsert_attributes!({gender: row['Sex'],
                                  age: row['Agemos']},
                                  {l: row['L'],
                                  m: row['M'],
                                  s: row['S']})
end
puts "Seeding BMI input data completed!"
