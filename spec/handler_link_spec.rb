require 'rspec'

require_relative '../lib/handler_link.rb'
require_relative '../lib/images_link.rb'

describe 'handler_links' do
  # check the get_host_link method for returning the hostname of the URL
  it 'get_host_link return host name' do
    handler_link = HandlerLink
    link = 'https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    link2 = 'http://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    expect(handler_link.get_host_link(link)).to eq 'https://www.google.com.ua'
    expect(handler_link.get_host_link(link2)).to eq 'http://www.google.com.ua'
  end

  # check that the method handler_prefix_link add the necessary prefix
  it 'handler_prefix_link' do
    handler_link = HandlerLink
    link = handler_link.get_host_link('http://goodprogrammer.ru/users/sign_in')
    link2 = 'https://moikrug.ru/vacancies/1000032025'
    href = '/favicon.png'
    href2 = '//favicon.png'
    href3 = 'https://habrastorage.org/getpro/moikrug/uploads/company/100/005/255/1/logo/medium_f19113ec4c4fdac7af49f748ba45fedc.png'
    expect(handler_link.handler_prefix_link(link, href)).to eq 'http://goodprogrammer.ru/favicon.png'
    expect(handler_link.handler_prefix_link(link, href2)).to eq 'http://favicon.png'
    expect(handler_link.handler_prefix_link(link2, href3)).to eq 'https://habrastorage.org/getpro/moikrug/uploads/company/100/005/255/1/logo/medium_f19113ec4c4fdac7af49f748ba45fedc.png'
  end

  # check the work of the methods handler_link and remove_unless_symbols
  it 'handler_link and remove_unless_symbols' do
    handler_link = HandlerLink
    link = 'https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    array = ['background:url(/images/nav_logo229.png)']
    handler_link.handler_links(array, link)
    expect(array).to eq ['background:url(https://www.google.com.ua/images/nav_logo229.png)']

    handler_link.remove_unless_symbols(array)
    expect(array).to eq ['https://www.google.com.ua/images/nav_logo229.png']
  end

  # check the work of the remove_unless_link for destroy not valid links
  it 'remove_unless_link' do
    handler_link = HandlerLink
    array = ['http://trololo.jpg', 'http://trololo.jpgqw', 'http://trololo.jpg?qwe', 'trololo']
    handler_link.remove_unless_link(array)
    expect(array).to eq ['http://trololo.jpg', 'http://trololo.jpg?qwe']
  end
end