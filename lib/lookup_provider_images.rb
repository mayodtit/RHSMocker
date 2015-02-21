require 'csv'

class LookupProviderImages

  def self.do(npi_avatar_url_filename)
    npi_map = {}

    npi_list = if File.exist?(npi_avatar_url_filename)
                 extract_npi_list_from_file(npi_avatar_url_filename)
               else
                 provider_npis
               end

    npi_list.each_with_index do |npi, i|
      img = filter_image_url(DataSources::BetterDoctor.lookup_by_npi(npi)[:image_url])

      img && npi_map[npi] = img

      num = "#{i}".rjust(5)

      puts "#{num} - NPI: #{npi} - #{npi_map[npi]}"
      sleep 1
    end

    write_npi_map_to_csv(npi_map)

    npi_map
  end

  def self.write_npi_map_to_csv(npi_map)
    filename = Rails.root.join('lib', 'assets', "provider_image_urls_#{Time.now.strftime("%Y%m%d_%H%M%S")}.csv")
    puts "WRITING #{npi_map.keys.count} IMAGES TO #{filename}"
    CSV.open(filename, "w") do |csv|
      csv << ["npi","image_url"]
      npi_map.each{|npi, image_url| csv << [npi, image_url] }
    end
  end

  def self.filter_image_url(url)
    return nil if url.nil?
    return nil if /general_doctor_/ =~ url
    url
  end

  def self.no_avatar(avatar_url_col_val)
    return true if avatar_url_col_val.nil?
    return true if avatar_url_col_val == ""
    return true if avatar_url_col_val == "NULL"
    nil
  end

  def self.extract_npi_list_from_file(filename_path)
    npis = []
    npi_col = 0
    url_col = 0

    file_to_read = filename_path || Rails.root.join('lib', 'assets', 'provider_image_urls.csv')
    puts "***** READING NPI + IMAGE CSV - #{file_to_read} *****"
    CSV.foreach(file_to_read, encoding: 'ISO-8859-1') do |row|
      if row.include?("avatar_url_override")
        npi_col = row.index("npi_number")
        url_col = row.index("avatar_url_override")
      else
        if no_avatar(row[url_col])
          puts "#{row[npi_col]} - adding to list"
          next unless row[npi_col] =~ /\A\d{10}\z/
          npis << row[npi_col]
        else
          puts "#{row[npi_col]} - avatar_url_override present, not adding to list"
        end
      end
    end

    puts "IMPORTED #{npis.count} NPIS NEEDING URL"

    npis.sort
  end

  def self.provider_npis
    puts "NPIs from hard-coded list"
    []
  end
end
