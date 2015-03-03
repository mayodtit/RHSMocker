desc "Create UserImages from Images stored in Messages"
task :create_user_images_from_images => :environment do
  puts "Creating UserImages from Images stored in Messages..."
  Message.find_each do |message|
    if message.image.present? && message.user_image_id.nil?
      ui  = UserImage.create!(user_id: message.user_id, image: CarrierwaveStringIO.new(Base64.encode64(message.image_url)), client_guid: message.user_image_client_guid, created_at: message.created_at)
      message.update_attribute(:user_image_id, ui.id)
    end
  end
end
