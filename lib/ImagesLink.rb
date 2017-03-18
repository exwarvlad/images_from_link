require 'httparty'
require 'nokogiri'
require 'uri'
require_relative 'HandlerLink'

class ImagesLink

  def initialize(link)
    @link = link

    begin
      @response = HTTParty.get(@link)
    rescue Errno::ECONNREFUSED => e
      puts "Неправильный урл"
      abort e.message
    end

    @doc = Nokogiri::HTML(@response.body)
    @doc.search('//noscript').each { |node| node.remove } # убираю мешающие ноды
    @arra_links = [] # сдесь будут храниться все урлы картинок
    @handler_link = HandlerLink.new # обработчик урлов
    @link_host_name = @handler_link.get_host_link(@link) # беру имя домена
  end

  # возвращает, все найденные, урлы картинок
  def get_images_from_url
    @arra_links = (get_url_with_attr_img_link + get_url_with_other_attr).uniq
    @handler_link.remove_global_unless_symbols(@arra_links)
    @arra_links
  end

  def get_url_with_attr_img_link
    img_arra = []
    # пробегаю по тегам img (meta og:images...), хватаю урл и закидываю в @arra_links
    @doc.xpath('//img').each do |img|
      if img['src'] != nil
        arra = [img['src'].to_s]
        src = @handler_link.remove_unless_symbols(arra)
        got_link = @handler_link.handler_prefix_link(@link_host_name, src.to_s.delete!("[\"]"))

        img_arra << got_link
      end
    end

    @doc.xpath('//link').each do |link|
      if link['href'] != nil && link['type'] != nil
        if link['type'].include?("image")
          got_link = @handler_link.handler_prefix_link(@link_host_name, link['href'])
          img_arra << got_link
        end
      end
    end

    @arra_links.uniq!
    @handler_link.remove_unless_link(@arra_links)
    img_arra
  end

  def get_url_with_other_attr
    # нахожу все урлы с jpg, png, gif... и закидываю в @arra_links
    @images_links = URI.extract(@doc.to_s.encode("UTF-16be", :invalid => :replace, :replace => "?").encode('UTF-8')).select { |l| l[/\.(?:gif|png|jpe?g)\b/] }
    @handler_link.handler_links(@images_links, @link) # обрабатываю урлы
    @handler_link.remove_unless_symbols(@images_links)
    @handler_link.remove_unless_link(@images_links)
    @images_links
  end
end