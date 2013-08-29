class BaseUploader < CarrierWave::Uploader::Base
  def hash_filename
    "#{secure_token}.#{file.extension}" if original_filename
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end