class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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

  version :card do
    process resize_to_fill: [500, 500]
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
