require 'config/url_map'
require 'config/yaml'
require 'r/oauth2/builder'

module Config
  class App
    def initialize(env_name, filename='cfg/app.yml')
      Yaml.load_config_file(filename)
      @env_name = env_name
      @env = environment(@env_name)
      @url_map = UrlMap.new
      @oauth_builder = R::OAuth2::Builder.new
    end

    def app_name
      return Yaml.app[:name]
    end

    def environments
      return Yaml.app[:environments][:list]
    end

    def default_environment
      Yaml.app[:default_environment]
    end

    def environment(env)
      return Yaml.environments[env.to_sym]
    end

    def map_urls
      return @url_map.map_urls()
    end

    def oauth_providers
      return @env[:oauth_providers][:list]
    end

    def default_oauth_provider
      return @env[:default_oauth_providers]
    end

    def session_parameters
      return {
        :key => 'rack.session',
        :domain => 'foo.com',
        :path => '/',
        :expire_after => 2592000,
        :secret => 'secret1_change_me',
        :old_secret => 'secret2_change_me_too'
      }
    end

    def oauth_parameters
      google_options = {
        :client_id     => 'change_me',
        :client_secret => 'change_me_too'
      }

    google = @oauth_builder.build_google_client(google_options)
    return {
      :oauth_providers => { :google => google }
    }
    end

  end
end
