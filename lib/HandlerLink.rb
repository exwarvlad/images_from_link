class HandlerLink
  FORMAT_IMG = ["jpg", "jpeg", "png", "gif"]

  # получает урл - отдает домен
  def get_host_link(link)
    uri = URI.parse(link)
    "#{uri.scheme}://" + uri.host
  end

  def handler_links(arra_links, link)
    arra_links.each do |url|
      if url.include?("(/")
        uri = get_host_link(link)

        position = url.index("(")
        url[position] += uri.to_s
      end
    end
  end

  # добавляет scheme, если это href
  def handler_prefix_link(host_link, link)
    abort 'в качестве аргументов передайте строки' unless host_link.is_a?(String) || link.is_a?(String)

    if link[0] == '/' && link[1] != '/'
      host_link + link
    elsif link[0..1] == '//'
      uri = URI.parse(host_link)
      "#{uri.scheme}:#{link}"
    else
      link
    end
  end

  def remove_unless_symbols(arra_images_links)
    arra_images_links.each do |image_url|
      if (image_url[0..3] != "http" || image_url[0..3] != "www.") && image_url.include?("(")
        position = image_url.index("(")
        image_url.reverse!
        position.times { image_url.chop! }
        image_url.reverse!
        image_url.delete!("(,;'')")
      end
    end
  end

  def remove_global_unless_symbols(arra_images_links)
    arra_images_links.each { |link| link.delete!("(,;'')") }
  end

  def remove_unless_link(arra_link)

    arra_link.each_with_index do |link, index|
      arra_link[index] = "" if link[0..3] != "http"

      index_ending = nil

      FORMAT_IMG.each do |i|
        index_ending = i if link.include?(i)
      end

        unless index_ending == nil
          position = link.index(index_ending)
          arra_link[index] = "" if (link[position + index_ending.size] =~ /[a-z]/)
        end

    end
    arra_link.delete("")
  end
end