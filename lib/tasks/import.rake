namespace :import do
  task :provider_images_from_csv, [:filename, :commit] => :environment do |t, args|
    filename = args[:filename]
    commit = (args[:commit] == 'true')

    file = File.read(filename, encoding: 'ISO-8859-1')
    csv = CSV.parse(file, headers: true)

    process_csv(csv) do |row|
      if user = User.find_by_npi_number(row['npi_number'])
        next :skip if user.avatar_url
        user.update_attributes!(remote_avatar_url: row['avatar_url']) if commit
      else
        begin
          if commit
            attributes = search_service.find(npi_number: row['npi_number'])
            attributes[:remote_avatar_url] = row['avatar_url']
            user = User.create!(user_attributes(attributes))
            user.addresses.create!(address_attributes(attributes))
          end
        rescue
          next :failure
        end
      end
      :success
    end
  end

  private

  def process_csv(csv)
    puts "***** PROCESSING CSV OF LENGTH #{csv.length} *****"
    csv.to_enum.with_index(0) do |row, i|
      if (i > 0) && ((i % 100) == 0)
        puts i
      end

      case yield(row)
      when :success
        print '.'
      when :skip
        print '*'
      when :failure
        print '!'
      end
    end
    puts "\nAll done!"
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def user_attributes(attributes)
    attributes.except(:address, :state, :healthcare_taxonomy_code, :taxonomy_classification)
  end

  def address_attributes(attributes)
    attributes[:address].except(:country_code, :phone, :fax)
  end
end
