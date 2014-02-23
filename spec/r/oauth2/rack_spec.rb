require 'spec_helper'
require 'r/oauth2/rack'
require 'r/oauth2/builder'

describe R::OAuth2::Rack do

  context 'will serve static files immediately' do
    # Simple rack app, middleware and mock request
    rack_app     = lambda { |env| [200, {}, ['contents of fish.txt']] }
    middleware   = R::OAuth2::Rack.new(rack_app, {:oauth_providers => {}})
    mock_request = Rack::MockRequest.new(middleware)

    # Dial the mocking layer
    mock_response = mock_request.get("http://localhost:9292/s/fish.txt")

    # Define expected behavior
    it('should return a 200') { mock_response.status.should == 200 }
    it('should short circuit the oauth checker and serve up the static contents of fish.txt') { mock_response.body.should == 'contents of fish.txt' }
  end

  context 'will initialize session, request and params from Rack environment' do
    # Simple rack app, middleware and mock request
    rack_app     = lambda { |env| [200, {}, ['Empty']] }
    middleware   = R::OAuth2::Rack.new(rack_app, {:oauth_providers => {}})
    mock_request = Rack::MockRequest.new(middleware)

    rack_env = {
      'PATH_INFO'    => '/waka/waka',
      'rack.session' => {:fish => 'fish'},
      'QUERY_STRING' => '?one=two&three=four',
      'rack.input'   => {}
    }
    (request, params, session) = middleware.initialize_session(rack_env)

    # Define expected behavior
    it('should return a rack request object with a path') { request.path == '/waka/waka' }
    it('return the rack.session object') { session[:fish] == 'fish' }
    it('properly parse any params') { params[:one] == 'two' }
    it('properly parse any params') { params[:three] == 'four' }
  end

  context 'will check to see if oauth provider is set' do

    # Simple rack app, middleware and mock request
    rack_app = lambda { |env| [200, {}, ['Serving it up']] }

    # Mock an oauth client
    RSpec::Mocks::setup(R::OAuth2::Bearer.new(:google, nil,{}))
    oauth_provider = R::OAuth2::Bearer.new(:google, nil,{})

    # Stub out the call we expect to see made
    oauth_provider.stub_chain("is_authenticated").and_return(true)
    options = {
      :oauth_providers => {:google => oauth_provider}
    }
    middleware   = R::OAuth2::Rack.new(rack_app, options)

    # Now create a mock request and dial a test url
    mock_request = Rack::MockRequest.new(middleware)
    mock_response = mock_request.get("http://localhost:9292/hello/api/world", {'rack.session' => {:oauth_provider => :google}})

    # Define expected behavior
    it('should return a 200') { mock_response.status.should == 200 }
    it('should default to authenticated and serve up the app content') { mock_response.body.should == 'Serving it up' }
  end

  context 'should handle callbacks from oauth providers' do

    # Simple rack app, middleware and mock request
    rack_app = lambda { |env| [301, {'location' => '/hello/world'}, []] }

    # Mock an oauth client
    # OAuth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','', {})
    oauth_client.stub_chain('auth_code.authorize_url').and_return('/hello/world')

    # And provider
    RSpec::Mocks::setup(R::OAuth2::Bearer.new(:google, oauth_client,{}))
    oauth_provider = R::OAuth2::Bearer.new(:google, oauth_client,{})

    # Stub out the call we expect to see made
    oauth_provider.stub_chain('swap_code_for_token').and_return('xyz_pdq')
    oauth_provider.stub_chain('callback_url').and_return('/oauth/callback_noop')
    options = {
      :oauth_providers => {:google => oauth_provider}
    }

    middleware   = R::OAuth2::Rack.new(rack_app, options)
    mock_request = Rack::MockRequest.new(middleware)

    # Dial the mocking layer
    session = {
      :oauth_provider => :google,
      :expected_page => '/hello/world'
    }
    mock_response = mock_request.get('http://localhost:9292/oauth/callback_noop', {'rack.session' => session})

    # Define expected behavior
    it('should return a 301')           { mock_response.status.should == 301 }
    it('should have a redirect header') { mock_response.headers['location'].should == '/hello/world' }
    it('should have redirect content')     { mock_response.body.should == 'redirected to /hello/world' }
    it('should have an access token')   { session[:access_token] == 'xyz_pdq' }
  end

  context 'should redirect unauthorized session to oauth page' do

    # Simple rack app, middleware and mock request
    rack_app = lambda { |env| [200, {}, ['<h1>Login</h1>']] }

    # OAuth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','', {})
    oauth_client.stub_chain('auth_code.authorize_url').and_return('http://google.com/auth')

    # Mock an oauth provider
    RSpec::Mocks::setup(R::OAuth2::Bearer.new(:google,oauth_client,{}))
    oauth_provider = R::OAuth2::Bearer.new(:google, oauth_client,{})
    options = {
      :oauth_providers => {:google => oauth_provider}
    }
    middleware   = R::OAuth2::Rack.new(rack_app, options)
    mock_request = Rack::MockRequest.new(middleware)

    # Dial the mocking layer
    session = {:expected_page => '/hello/api/world'}
    mock_response = mock_request.get("http://localhost:9292/login/", {'rack.session' => session})

    # Define expected behavior
    it('should return 301')           { mock_response.status.should == 301 }
    it('should have login content')     { mock_response.headers['location'].should == 'http://google.com/auth' }
    it('should have an expected page')  { session[:expected_page] == '/hello/api/world' }

  end

  context 'should handle oauth callback' do

    # Simple rack app, middleware and mock request
    rack_app = lambda { |env| [200, {}, ['<h1>Login</h1>']] }

    # OAuth client
    RSpec::Mocks::setup(OAuth2::Client.new('','',{}))
    oauth_client = OAuth2::Client.new('','', {})
    oauth_client.stub_chain('auth_code.authorize_url').and_return('http://google.com/auth')
    oauth_client.stub_chain('auth_code.get_token.token').and_return('xyz_pdq')



    builder = R::OAuth2::Builder.new
    oauth_provider = builder.build_google_client({:client_id => 'Waka', :client_secret => 'Waja'}, oauth_client)

    options = {
      :oauth_providers => {:google => oauth_provider}
    }
    middleware   = R::OAuth2::Rack.new(rack_app, options)
    mock_request = Rack::MockRequest.new(middleware)

    # Dial the mocking layer
    session = {:expected_page => '/hello/api/world'}
    mock_response = mock_request.get("http://localhost:9292/oauth/callback_google?code=4/LO5LHga0ntfUsRz2-MRmp-8QRxbt.8qpmSOFp-y0TmmS0T3UFEsPcktL8hwI", {'rack.session' => session})

    # Define expected behavior
    it('should return 301')             { mock_response.status.should == 301 }
    it('should have login content')     { mock_response.headers['location'].should == '/hello/api/world' }
    it('should have an expected page')  { session[:expected_page] == '/hello/api/world' }
    it('should have a valid token')     { session[:access_token] == 'xyz_pdq' }
    it('should have a valid token')     { session[:at_expires] > Time.new.to_i }
  end



end
