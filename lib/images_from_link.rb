require "images_from_link/version"
require 'handler_link'
require 'images_link'

module ImagesFromLink
  # выводит каритнки по переданному урлу
  def self.get_images(link)
    images_link = ImagesLink.new(link)
    images_link.get_images_from_url
  end
end
