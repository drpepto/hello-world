require 'spec_helper'
require 'oauth2'
require 'r/oauth2/bearer'
require 'r/oauth2/builder'


class Helper
  def get_bearer
    # Mock an oauth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','',{})
    oauth_client.stub_chain("auth_code.authorize_url").and_return('http://foo.com/oauth')
    oauth_client.stub_chain("auth_code.get_token.token").and_return('xyz_pdq')

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
    base = R::OAuth2::Bearer.new(:google, oauth_client, options)

    return base
  end
end

describe R::OAuth2::Bearer do

  context 'should swap code for access token' do
    base = Helper.new.get_bearer()
    session = {}
    access_token = base.swap_code_for_token({:code => 'waka'}, session)

    # Define expected behavior
    it('should return access token')             { access_token == 'xyz_pdq' }
    it('should have an access_token in session') { session[:access_token] == 'xyz_pdq' }
    it('should now be authenticated')            { base.is_authenticated(session) == true }
    it('should have callback url')               { base.callback_url == 'oauth/twitter_callback'}
  end

  context 'should redirect to oauth url' do
    base = Helper.new.get_bearer()
    session = {}
    url = base.generate_oauth_redirect('http://waka.com')

    # Define expected behavior
    it('should point somewhere') { url == 'http://foo.com/oauth' }
  end

  context 'should not authenticate empty users' do
    base = Helper.new.get_bearer()
    session = {}
    flag = base.is_authenticated(session)

    # Define expected behavior
    it('should be false') { flag == false }
  end

  context 'should authenticate real users' do
    base = Helper.new.get_bearer()
    session = {
      :access_token => 'okyDokey',
      :at_expires   => Time.now.to_i + 3600
    }
    flag = base.is_authenticated(session)

    # Define expected behavior
    it('should be false') { flag == true }
  end

  context 'update token info' do
    base = Helper.new.get_bearer()
    session = {
      :access_token => 'okyDokey',
      :at_expires   => Time.now.to_i + 3600
    }
    flag = base.update_session_access_token(session, '1235Token')

    # Define expected behavior
    it('should be false') { session[:access_token] == '1235Token' }
  end

  context 'nill session is not authenticated' do
    base = Helper.new.get_bearer()
    session = nil

    flag = base.is_authenticated(session)
    it('should be false') { flag == false }

    flag = base.is_authenticated({})
    it('should be false') { flag == false }

    session = {
      :access_token => 'okyDokey',
      :at_expires   => Time.now.to_i - 3600
    }
    flag = base.is_authenticated(session)

  end

  context 'have callback url' do
    base = Helper.new.get_bearer()
    url = base.callback_url

    # Define expected behavior
    it('should be false') { url == 'oauth/twitter_callback' }
  end

end
