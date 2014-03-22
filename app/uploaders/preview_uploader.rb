# encoding: utf-8

class PreviewUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Processing::RMagick

  storage :file
  process :strip # strip image of all profiles and comments

  def store_dir
    "data/Previews"
  end

  version :thumb do
    process :convert        => 'jpg'
    process :resize_to_fill => [400, 250]
    process :quality        => 85

    def filename
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def cache_dir
    Rails.root.join 'tmp/uploads'
  end
end
