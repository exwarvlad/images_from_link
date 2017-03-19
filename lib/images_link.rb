require 'httparty'
require 'nokogiri'
require 'uri'
require_relative 'handler_link'

class ImagesLink

  # expect valid url
  def initialize(link)
    @link = link

    begin
      @response = HTTParty.get(@link)
    rescue Errno::ECONNREFUSED => e
      puts "not valid url"
      abort e.message
    end

    @doc = Nokogiri::HTML(@response.body)
    @doc.search('//noscript').each { |node| node.remove } # убираю мешающие ноды
    @links = [] # сдесь будут храниться все урлы картинок
    @handler_link = HandlerLink # обработчик урлов
    @link_host_name = @handler_link.get_host_link(@link) # беру имя домена
  end

  # returns all found images url
  def get_images_from_url
    @links = (images_from_img_tag + images_from_link_tag + images_from_extension).uniq
    @handler_link.remove_global_unless_symbols(@links)
    @links
  end

  # returns all images url with tags img['src']
  def images_from_img_tag
    img_array = []
    # пробегаю по тегам img (meta og:images...), хватаю урл и закидываю в img_array
    @doc.xpath('//img').each do |img|
      if img['src'] != nil
        array = [img['src'].to_s]
        src = @handler_link.remove_unless_symbols(array)
        got_link = @handler_link.handler_prefix_link(@link_host_name, src.to_s.delete!("[\"]"))

        img_array << got_link
      end
    end

    img_array.uniq!
    @handler_link.remove_unless_link(img_array)
    img_array
  end

  # returns all images url with tags link['href']
  def images_from_link_tag
    img_array = []
    @doc.xpath('//link').each do |link|
      if link['href'] != nil && link['type'] != nil
        if link['type'].include?("image")
          got_link = @handler_link.handler_prefix_link(@link_host_name, link['href'])
          img_array << got_link
        end
      end
    end

    img_array.uniq!
    @handler_link.remove_unless_link(img_array)
    img_array
  end

  # returns all images url with jpg, png, gif...
  def images_from_extension
    # нахожу все урлы с jpg, png, gif...
    @images_links = URI.extract(@doc.to_s.encode("UTF-16be", :invalid => :replace, :replace => "?").encode('UTF-8')).select { |l| l[/\.(?:gif|png|jpe?g)\b/] }
    @handler_link.handler_links(@images_links, @link) # обрабатываю урлы
    @handler_link.remove_unless_symbols(@images_links)
    @handler_link.remove_unless_link(@images_links)
    @images_links.uniq
  end
end