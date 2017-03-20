# ImagesFromLink

[![Gem Version](https://badge.fury.io/rb/images_from_link.svg)](https://badge.fury.io/rb/images_from_link)

Extracts images by link.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'images_from_link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install images_from_link

## Usage

```
require 'images_from_link'
  
ImagesFromLink.get_images('https://www.google.com')
 
=>
[
"https://www.google.com/textinputassistant/tia.png",
"https://www.google.com/images/nav_logo229.png",
"https://www.google.com/images/branding/googlelogo/1x/googlelogo_white_background_color_272x92dp.png"
]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

