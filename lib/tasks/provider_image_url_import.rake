require 'csv'

namespace :admin do
  task :provider_image_url_import, [:filename] => :environment do |t, args|
    filename = args[:filename] || "provider_image_urls.csv"

    npi_image_map = load_npi_image_map(filename)

    assign_urls(npi_image_map)
  end

  private

  def assign_urls(npi_image_map)
    num_updated = 0

    puts "ASSIGNING URLs TO PROVIDERS"

    eligible_providers.find_each(batch_size: 100) do |provider|
      img_url = npi_image_map[provider.npi_number]
      next unless img_url

      puts "#{provider.npi_number} - assigning images url #{img_url}"
      provider.update_attribute(:avatar_url_override, img_url)
      num_updated += 1
    end

    puts "UPDATED #{num_updated} RECORDS"
  end

  def eligible_providers
    User.where("npi_number IS NOT NULL AND avatar_url_override IS NULL")
  end

  def load_npi_image_map(filename)
    file_to_open = Rails.root.join('lib', 'assets', filename)
    npi_map = {}

    puts "LOADING NPI-IMAGE_URL PAIRS FROM FILE - #{file_to_open}"

    CSV.foreach(file_to_open, encoding: 'ISO-8859-1'){|row| npi_map[row["npi"]] = row["image_url"] }

    npi_map
  end
end
