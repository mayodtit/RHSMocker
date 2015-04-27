class LookupProviderImages

  def self.do(commit_changes)
    puts "DRY RUN - No database updates" unless commit_changes

    npi_list = npi_list_for_providers_without_image

    n = npi_list.count
    num_found = 0
    puts "FOUND #{n} providers"

    npi_list.each_with_index do |npi, i|
      img_url = filter_image_url(DataSources::BetterDoctor.lookup_by_npi(npi)[:image_url])
      next unless img_url

      puts "#{(i+1).to_s.rjust(5)}/#{n} - NPI: #{npi} - #{img_url}"

      if commit_changes
        provider = User.find_by_npi_number!(npi)
        provider.update_attribute(:avatar_url_override, img_url)
        num_found += 1
      end

      sleep 1
      sleep 5 if ((i+1) % 50) == 0
    end

    puts "FINSIHED, UPDATED #{num_found} of #{n} providers"
  end

  def self.filter_image_url(url)
    return nil if url.nil?
    return nil if /general_doctor_/ =~ url
    url
  end

  def self.npi_list_for_providers_without_image
    User.where("npi_number IS NOT NULL AND avatar_url_override IS NULL").pluck(:npi_number)
  end
end
