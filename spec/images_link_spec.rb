require 'rspec'

require_relative '../lib/images_link.rb'
require_relative '../lib/handler_link.rb'

describe 'ImagesLink' do

  # проверяю работу метода get_url_with_other_attr
  it 'get_url_with_other_attr return arra with only img url' do
    images_link = ImagesLink.new('https://twitter.com/')
    arra_images_links = images_link.get_url_with_other_attr # хватаю картинки

    # проверяю, что в arra_images_links, каждый объект - действительно ссылка на картинку
    arra_images_links.each do |link|
      expect(link[0..3]).to eq 'http'
      expect(link).to be =~ /\.(?:gif|png|jpe?g)/ # ожидаю, что в link будет один из форматов картинки
                                                                               # gif, png jpg или jpeg
    end
  end
end