# app/services/imagekit_service.rb
require "imagekitio"

class ImagekitService
  def initialize(model)
    @client = ImageKitIo::Client.new(
      ENV.fetch("IMAGEKIT_PRIVATE_KEY"),
      ENV.fetch("IMAGEKIT_PUBLIC_KEY"),
      ENV.fetch("IMAGEKIT_ENDPOINT")
    )
    @model = model or raise ArgumentError, "Must pass a model to ImagekitService"
  end

  # Kick off the migration of any image_url whose URL isn't already on imagekit.io
  def migrate_images
    @model.image_urls
      .where.not("url LIKE ?", "%imagekit.io%")
      .find_each do |image_url|
        base_name = @model.try(:name) || @model.try(:title) || @model.class.name.downcase
        process_existing_image_url(image_url, base_name)
      end
  end

  private

  def sanitize_filename(name)
    name.to_s.parameterize.underscore
  end

  def upload_remote_image(image_url, file_name)
    response = @client.upload_file(
      file: image_url,
      file_name: file_name,
      use_unique_file_name: false
    )

    if response[:status_code].to_s == "200"
      {
        url:     response[:response]["url"],
        file_id: response[:response]["fileId"]
      }
    else
      Rails.logger.error("ImageKit upload failed for #{file_name}: #{response.inspect}")
      nil
    end
  rescue => e
    Rails.logger.error("Exception while uploading #{file_name}: #{e.message}")
    nil
  end

  def process_existing_image_url(image_url, base_name)
    # e.g. "listing-1234_56.jpg"
    ext       = File.extname(URI.parse(image_url.url).path).presence || ".jpg"
    file_name = "#{sanitize_filename(base_name)}_#{image_url.id}#{ext}"

    if (result = upload_remote_image(image_url.url, file_name))
      image_url.update!(url: result[:url], file_id: result[:file_id])
    else
      Rails.logger.warn("⚠️ ImageKit upload failed for ImageUrl id=#{image_url.id}; keeping original URL")
    end
  end
end
