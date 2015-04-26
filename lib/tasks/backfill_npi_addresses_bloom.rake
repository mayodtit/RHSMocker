namespace :admin do
  task :backfill_npi_addresses_bloom, [:execute] => :environment do |t, args|
    execute_arg = args[:execute] || "false"
    commit_changes = (execute_arg == "true")

    puts "DRY RUN - No database updates" unless commit_changes

    providers_with_no_address = find_providers_with_no_address

    n = providers_with_no_address.count
    puts "FOUND #{n} providers"

    s = Search::Service.new
    providers_with_no_address.each_with_index do |provider, i|
      puts "#{(i+1).to_s.rjust(5)}/#{n} - #{provider.npi_number} - #{provider.first_name} #{provider.last_name}"
      lookup_and_create_address_for_provider!(provider, s, commit_changes)
    end
  end

  private

  def find_providers_with_no_address
    User.where("npi_number IS NOT NULL").select{|u| u.addresses.count == 0 }
  end

  def lookup_and_create_address_for_provider!(provider, search, commit = false)
    begin
      bloom_result = search.find({npi_number: provider.npi_number})
    rescue
      puts "Error looking up NPI #{provider.npi_number} on Bloom"
      return 1
    end

    address_attributes = filter_address_fields(bloom_result[:address])

    puts "       found address #{address_attributes}"
    if commit
      addr = provider.addresses.create!(address_attributes)
      puts "       NEW ADDRESS CREATED - #{addr.id}"
    end
  end

  def filter_address_fields(address_attributes)
    address_fields = [:address, :address2, :city, :state, :postal_code, :name]
    address_attributes.slice(*address_fields)
  end
end
