# encoding: utf-8

class OnboardingGroupBackgroundAssetUploader < BaseUploader
  storage :fog

  def store_dir
    'onboarding_group_background_asset'
  end

  def fog_public
    true
  end

  def filename
     hash_filename
  end
end
