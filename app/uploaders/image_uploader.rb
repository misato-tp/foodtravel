class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fit: [300, 300]

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "https://#{ENV['AWS_BUCKET_NAME']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/app-images/noimage.png"
  end

  version :default_profile_image do
    def default_url(*args)
      "s3://food-travel/app-images/defaultIcon.png"
    end
  end

  version :photo do
    process resize_to_fit: [300, 300]
  end
  version :show do
    process resize_to_fit: [600, 700]
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
