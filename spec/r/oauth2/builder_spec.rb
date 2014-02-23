require 'spec_helper'
require 'r/oauth2/builder'


describe R::OAuth2::Builder do

  context 'should build oauth bearer clients with the oauth provider we provide' do

    # Mock an oauth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','',{})

    # Define all the tedious options still necessary
    options = {
      :client_id => '',
      :client_secret => ''
    }
    options[:site]          = 'http://waka.com'
    options[:authorize_url] = '/auth'
    options[:token_url]     = '/token'
    options[:scopes]        = 'waka'
    options[:callback_url]  = 'oauth/twitter_callback'
    
    # Create a base object to test
    bearer = R::OAuth2::Builder.new().build_oauth_client(:google, options, oauth_client)

    it('should have callback url') { bearer.callback_url == 'oauth/twitter_callback'}
  end

  context 'should build oauth bearer clients with default oauth client if we dont provide one' do

    # Define all the tedious options still necessary
    options = {
      :client_id => '',
      :client_secret => ''
    }
    options[:site]          = 'http://waka.com'
    options[:authorize_url] = '/auth'
    options[:token_url]     = '/token'
    options[:scopes]        = 'waka'
    options[:callback_url]  = 'oauth/twitter_callback'

    # Create a base object to test
    bearer = R::OAuth2::Builder.new().build_oauth_client(:google, options)
    it('should have callback url') { bearer.callback_url == 'oauth/twitter_callback'}
  end

  context 'should provide a get_provider method to select oauth provider by name' do

    # Mock an oauth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','',{})

    # Define all the tedious options still necessary
    options = {
      :client_id => '',
      :client_secret => ''
    }
    
    # Create a base object to test
    bearer = R::OAuth2::Builder.new().get_provider(:google, options, oauth_client)

    it('should have callback url') { bearer.callback_url == 'oauth/callback_google'}
  end

  context 'should provide a facebook provider' do

    # Mock an oauth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','',{})

    # Define all the tedious options still necessary
    options = {
      :client_id => '',
      :client_secret => ''
    }

    # Facebook
    bearer = R::OAuth2::Builder.new().get_provider(:facebook, options, oauth_client)
    it('should have callback url') { bearer.callback_url == 'oauth/callback_facebook'}

    # Twitter
    bearer = R::OAuth2::Builder.new().get_provider(:twitter, options, oauth_client)
    it('should have callback url') { bearer.callback_url == 'oauth/callback_twitter'}

    # Github
    bearer = R::OAuth2::Builder.new().get_provider(:github, options, oauth_client)
    it('should have callback url') { bearer.callback_url == 'oauth/callback_github'}

    begin
      bearer = R::OAuth2::Builder.new().get_provider(:bogus, options, oauth_client)
      fail("Should have thrown an error")
    rescue => e
      # Should happen
    end
  end

end
