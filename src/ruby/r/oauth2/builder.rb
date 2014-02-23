# Author:  Andy Olsen (andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: Build OAuth clients based on parameters

require 'oauth2'
require 'r/oauth2/bearer'

module R
  module OAuth2
    class Builder

      def build_oauth_client(name, options, oauth_client=nil?)
        # Need client id and secret. No use proceeding without them
        raise 'options[:site] may not be null'          unless options[:site]
        raise 'options[:authorize_url] may not be null' unless options[:authorize_url]
        raise 'options[:token_url] may not be null'     unless options[:token_url]
        raise 'options[:client_id] may not be null'     unless options[:client_id]
        raise 'options[:client_secret] may not be null' unless options[:client_secret]
        raise 'options[:scopes] may not be null'        unless options[:scopes]

        if(oauth_client.nil?)
          oauth_client = ::OAuth2::Client.new(options[:client_id], options[:client_secret], options)
        end
        return Bearer.new(name, oauth_client, options)
      end

      def get_provider(name, options, oauth_client=nil)
        case name
        when :google
          return build_google_client(options,oauth_client)
        when :facebook
          return build_facebook_client(options,oauth_client)
        when :twitter
          return build_twitter_client(options,oauth_client)
        when :github
          return build_github_client(options,oauth_client)
        end
        raise "Cannot find oauth provider: '#{name}'"
      end

      def build_google_client(params,oauth_client=nil)
        options = {
          :client_id     => params[:client_id],
          :client_secret => params[:client_secret],
          :site          =>  'https://accounts.google.com',
          :authorize_url =>  '/o/oauth2/auth',
          :token_url     =>  '/o/oauth2/token',
          :scopes        =>  'https://www.googleapis.com/auth/userinfo.email',
          :callback_url  =>  'http://localhost:9292/oauth/callback_google'
        }
        return build_oauth_client(:google, options,oauth_client)
      end

      def build_facebook_client(params,oauth_client=nil)
        options = {
          :client_id     => params[:client_id],
          :client_secret => params[:client_secret],
          :site          =>  '',
          :authorize_url =>  '',
          :token_url     =>  '',
          :scopes        =>  '',
          :callback_url  =>  ''
        }
        return build_oauth_client(:facebook, options,oauth_client)
      end

      def build_github_client(params,oauth_client=nil)
        options = {
          :client_id     => params[:client_id],
          :client_secret => params[:client_secret],
          :site          =>  '',
          :authorize_url =>  '',
          :token_url     =>  '',
          :scopes        =>  '',
          :callback_url  =>  ''
        }
        return build_oauth_client(:github, options,oauth_client)
      end

      def build_twitter_client(params,oauth_client=nil)
        options = {
          :client_id     => params[:client_id],
          :client_secret => params[:client_secret],
          :site          =>  '',
          :authorize_url =>  '',
          :token_url     =>  '',
          :scopes        =>  '',
          :callback_url  =>  ''
        }
        return build_oauth_client(:twitter, options,oauth_client)
      end

    end
  end
end
