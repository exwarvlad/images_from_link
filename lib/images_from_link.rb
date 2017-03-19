require "images_from_link/version"

module ImagesFromLink
  require_relative 'handler_link'
  require_relative 'images_link'

  # extract images from got url
  def self.get_images(link)
    images_link = ImagesLink.new(link)
    images_link.get_images_from_url
  end
end
