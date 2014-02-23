# Author:  Andy Olsen (andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: Basic bearer token functionality

module R
  module OAuth2
    class Bearer
      attr_accessor :name

      # Assemble the data we need to connect to google and then feed
      # it to the super class
      def initialize(name, oauth_client, options)
        @name = name

        # Create the client
        @oauth_client = oauth_client

        # Grab scopes
        @scopes      = options[:scopes]
        @access_type = options[:access_type] || 'offline'

        # Cache options
        @options = options
      end

      # Given a hash of parameters, pick out the code and dial the
      # OAuth provider to swap it for a real access token and then
      # update the session with the access token
      def swap_code_for_token(params, session)
        url = callback_url()
        access_token = get_access_token(callback_url, params)
        update_session_access_token(session, access_token)
      end

      # Dial the OAuth provider to swap a code for an access token
      def get_access_token(callback_url, params)
        code = params[:code]
        return @oauth_client.auth_code.get_token(code, :redirect_uri => callback_url).token
      end

      # Generate a redirct url with all the OAuth HooHaw needed to
      # authenticate
      def generate_oauth_redirect(callback_url)
        return @oauth_client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => @scopes, :access_type => @access_type)
      end

      # Is current session authenticated?
      def is_authenticated(session)
        return soft_authentication(session)
      end

      # Determine if current session is authenticated by session access token
      def soft_authentication(session)
        # Do we have an access token and expires?
        if(session.nil? || session[:access_token].nil? || session[:at_expires].nil?)
          return false
        end
        if(session[:at_expires] < Time.new().to_i)
          return false
        end
        return true
      end

      # Determine if current session is authenticated by refreshing the access token
      def hard_authentication(session)
        # TODO 
      end

      # Update the session information with the new access token
      def update_session_access_token(session, access_token)
        session[:access_token] = access_token
        session[:at_expires]   = Time.new().to_i + 3600
      end

      def callback_url
        return @options[:callback_url]
      end
    end
  end
end
