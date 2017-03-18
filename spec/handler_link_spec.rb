require 'rspec'

require_relative '../lib/handler_link.rb'
require_relative '../lib/images_link.rb'

describe 'handler_links' do
  # проверяю метод get_host_link на то, что вернет имя хоста урла
  it 'get_host_link return host name' do
    handler_link = HandlerLink.new
    link = 'https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    link2 = 'http://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    expect(handler_link.get_host_link(link)).to eq 'https://www.google.com.ua'
    expect(handler_link.get_host_link(link2)).to eq 'http://www.google.com.ua'
  end

  # проверяю что метод handler_prefix_link подставляет нужные префикс
  it 'handler_prefix_link' do
    handler_link = HandlerLink.new
    link = handler_link.get_host_link('http://goodprogrammer.ru/users/sign_in')
    link2 = 'https://moikrug.ru/vacancies/1000032025'
    href = '/favicon.png'
    href2 = '//favicon.png'
    href3 = 'https://habrastorage.org/getpro/moikrug/uploads/company/100/005/255/1/logo/medium_f19113ec4c4fdac7af49f748ba45fedc.png'
    expect(handler_link.handler_prefix_link(link, href)).to eq 'http://goodprogrammer.ru/favicon.png'
    expect(handler_link.handler_prefix_link(link, href2)).to eq 'http://favicon.png'
    expect(handler_link.handler_prefix_link(link2, href3)).to eq 'https://habrastorage.org/getpro/moikrug/uploads/company/100/005/255/1/logo/medium_f19113ec4c4fdac7af49f748ba45fedc.png'
  end

  # проверяю работу методов handler_link и remove_unless_symbols
  it 'handler_link and remove_unless_symbols' do
    handler_link = HandlerLink.new
    link = 'https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rspec&*'
    arra = ['background:url(/images/nav_logo229.png)']
    handler_link.handler_links(arra, link)
    expect(arra).to eq ['background:url(https://www.google.com.ua/images/nav_logo229.png)']

    handler_link.remove_unless_symbols(arra)
    expect(arra).to eq ['https://www.google.com.ua/images/nav_logo229.png']
  end

  # проверяю remove_unless_link на удаление невалидных ссылок картинок
  it 'remove_unless_link' do
    handler_link = HandlerLink.new
    arra = ['http://trololo.jpg', 'http://trololo.jpgqw', 'http://trololo.jpg?qwe', 'trololo']
    handler_link.remove_unless_link(arra)
    expect(arra).to eq ['http://trololo.jpg', 'http://trololo.jpg?qwe']
  end
end