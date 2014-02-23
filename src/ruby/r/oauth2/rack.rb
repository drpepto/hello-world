# Author:  Andy Olsen (andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: Rack middleware to intercept requests and redirect them to
# an OAuth provider if they are not alread validated

require 'rack'
require 'oauth2'

module R
  module OAuth2
    class Rack

      # Initial config params
      def initialize(app, options)
        @app = app

        raise "Must provide option[:oauth_providers]" unless options[:oauth_providers]

        # Set the default to the zero index unless otherwise specified
        options[:oauth_default_provider] = options[:oauth_providers].keys[0] unless options[:oauth_default_provider]

        # A map of the various oauth providers
        @oauth_providers = options[:oauth_providers]

        # The default provider to use if no others specified
        @oauth_default_provider = @oauth_providers[options[:oauth_default_provider]]

        # A list of the callback urls
        @oauth_callback_urls = {}

        # Walk the list of providers and index the callback urls
        @oauth_providers.map { |k,v| @oauth_callback_urls[v.callback_url] = v }
      end
      
      # Due to the use R::OAuth2::Rack statement in the
      # config.ru, this method will get called for each and every
      # request Rack serves. Here, we will:
      #
      # 1 - (Most Likely) Check to see if the request is being served
      # from the static path and if so, return immediately since we
      # don't care about static content being authorized.
      #
      # 2 - (Less Likely) Check to see if an OAuth Provider such as
      # Google or Twitter is dialing back to us with authentication
      # data. If so we will set the session data appropriately and
      # redirect the user back to their expected page.
      #
      # 3 - (Next Most Likely) Check to see if we are already
      # authenticated and if so return immediately.
      #
      # 4 - If all other checks, fail, we assume the user is not
      # authenticated so we will cache the page they were trying to
      # view and redirect them to the default oauth provider
      def call(env)

        # return immediately if static (that is, if the path starts
        # with /s/)
        return @app.call(env) if(env['PATH_INFO'] =~ /^\/s\//)

        # Get access to the session and request
        (request, params, session) = initialize_session(env)

        # Is this a callback from an OAuth provider?
        url_key = request.url
        index = url_key.index('?')
        url_key = url_key.slice(0..index-1) unless index.nil?
        return handle_callback(request, params, session, url_key) if(@oauth_callback_urls.has_key?(url_key))

        # Call the app if the user is authenticated
        return @app.call(env) if is_authenticated(request, params, session)

        # User is not authenticated. Cache the page they were
        # expecting and send them to the oauth provider for
        # authentication
        session[:expected_page] = request.path
        provider_name = session[:oauth_provider] || @oauth_default_provider.name
        provider = @oauth_providers[provider_name.to_sym]
        url = provider.generate_oauth_redirect(provider.callback_url())
        return [301, {'location' => url}, ["redirected to #{url}"]]
      end


      # Initialize the session and generate a request object from the
      # envionment passed in by Rack
      def initialize_session(env)
        # We need access to the session to check authentication
        raise "session should not be null" if env['rack.session'].nil?
        session = env['rack.session']
        
        # Don't know why we need this, but the session will not
        # initialize without it. (YMMV)
        session[:last_access_time] ||= Time.new().to_i()
        
        # Grab api access to env info
        request = ::Rack::Request.new(env)
        params = request.params

        return [request, params, session]
      end


      # Handle callback calls from oauth providers
      def handle_callback(request, params, session, provider_key)
        # Yes, lookup the oauth provider by callback url
        provider = @oauth_callback_urls[provider_key]
        
        # Set the oauth provider in the session
        session[:oauth_provider] = provider.name
        
        # Ask the provider to swap the code received for an access token
        provider.swap_code_for_token(params, session)
        
        # Now the access token has been granted, redirect back to
        # the expected page or failing that to the main page
        redirect_url = session[:expected_page] || '/'
        return [301, {'location' => redirect_url}, []]
      end


      # Determine if a user session is authenticated
      def is_authenticated(request, params, session)
        # Is the user already authenticated?
        if(session.has_key?(:oauth_provider))
          # User has a provider set, check to see if user is still
          # authorized
          provider_name = session[:oauth_provider]

          # Is that provider still active?
          if @oauth_providers.has_key?(provider_name)

            # Yes, grab the object
            provider = @oauth_providers[provider_name]

            # Dial it to see if the session is still valid
            if(provider.is_authenticated(session))
              return true
            end
          end
        end
        return false
      end

    end
  end
end
