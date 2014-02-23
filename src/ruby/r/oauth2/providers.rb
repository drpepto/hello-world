# Author:  Andy Olsen (andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: A class to aggregate multiple providers
require 'r/oauth2/builder'

module R
  module OAuth2
    class Providers
      GOOGLE   = :google
      NOOP     = :noop
      FACEBOOK = :facebook
      TWITTER  = :twitter
      GITHUB   = :github

      attr_read :providers

      def initialize(options)
        @builder = Builder.new
        @providers = {}
        @providers[:google]   = @builder.build_google_client(options)
        @providers[:noop]     = @builder.build_noop_client(options)
        @providers[:facebook] = @builder.build_facebook_client(options)
        @providers[:twitter]  = @builder.build_twitter_client(options)
        @providers[:github]   = @builder.build_github_client(options)
      end

      def provider(name)
        return @providers[name]
      end
    end
  end
end
