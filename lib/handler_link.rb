module HandlerLink
  FORMAT_IMG = ["jpg", "jpeg", "png", "gif"]

  # gets the url, returns domain
  def self.get_host_link(link)
    uri = URI.parse(link)
    "#{uri.scheme}://#{uri.host}"
  end

  def self.handler_links(array_links, link)
    array_links.each do |url|
      if url.include?("(/")
        uri = get_host_link(link)

        position = url.index("(")
        url[position] += uri.to_s
      end
    end
  end

  # adds scheme if this href
  def self.handler_prefix_link(host_link, link)
    abort 'expect strings params' unless host_link.is_a?(String) || link.is_a?(String)

    if link[0] == '/' && link[1] != '/'
      host_link + link
    elsif link[0..1] == '//'
      uri = URI.parse(host_link)
      "#{uri.scheme}:#{link}"
    else
      link
    end
  end

  def self.remove_unless_symbols(array_images_links)
    array_images_links.each do |image_url|
      if (image_url[0..3] != "http" || image_url[0..3] != "www.") && image_url.include?("(")
        position = image_url.index("(")
        image_url.reverse!
        position.times { image_url.chop! }
        image_url.reverse!
        image_url.delete!("(,;'')")
      end
    end
  end

  def self.remove_global_unless_symbols(array_images_links)
    array_images_links.each { |link| link.delete!("(,;'')") }
  end

  # remove link if link not valid
  def self.remove_unless_link(array_links)

    array_links.each_with_index do |link, index|
      array_links[index] = "" if link[0..3] != "http"

      index_ending = nil

      FORMAT_IMG.each do |i|
        index_ending = i if link.include?(i)
      end

      unless index_ending == nil
        position = link.index(index_ending)
        array_links[index] = "" if (link[position + index_ending.size] =~ /[a-z]/)
      end

    end
    array_links.delete("")
  end
end