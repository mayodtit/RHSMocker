desc "Create UserImages from Images stored in Messages"
task :create_user_images_from_images => :environment do
  puts "Creating UserImages from Images stored in Messages..."
  Message.find_each do |message|
    if message[:image] && !(message[:user_image_id])
      ui  = UserImage.create!(user_id: message.user_id, image: message.image, client_guid: message.user_image_client_guid)
      message.update_attribute(:user_image_id, ui.id)
    end
  end
end
