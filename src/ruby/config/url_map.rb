require 'hello/rest'
require 'rack'

module Config
  class UrlMap

    def map_urls
      return {
        '/hello/' => Hello::Rest,
        '/www'    => Rack::Directory.new('src/angular/app'),
        '/s'      => Rack::Directory.new('src/angular/app')
      }
    end
  end
end
