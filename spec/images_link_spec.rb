require 'rspec'

require_relative '../lib/images_link.rb'
require_relative '../lib/handler_link.rb'

describe 'ImagesLink' do

  # check the work of the method images_from_extension
  it 'images_from_img_tag and images_from_link_tag return array with only img url' do
    images_link = ImagesLink.new('https://twitter.com/')
    arra_images_links = images_link.images_from_extension # хватаю картинки

    # проверяю, что в arra_images_links, каждый объект - действительно ссылка на картинку
    arra_images_links.each do |link|
      expect(link[0..3]).to eq 'http'
      expect(link).to be =~ /\.(?:gif|png|jpe?g)/ # ожидаю, что в link будет один из форматов картинки
      # gif, png jpg или jpeg
    end
  end
end