require "images_from_link/version"
require 'HandlerLink'
require 'ImagesLink'

module ImagesFromLink
  # выводит каритнки по переданному урлу
  def self.get_images(link)
    images_link = ImagesLink.new(link)
    images_link.get_images_from_url
  end
end
