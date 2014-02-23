#!/usr/bin/env ruby

# Author:  Andy Olsen(andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: Config file to pass to Rack to launch our app

# A hack to allow us to store our ruby code in src/ruby and still
# allow us to require by package name (e.g. 'example/app/hello'). Feel
# free to rejigger as you see fit.
$: << 'src/ruby'

# Extract the environment we will run in or default 
environment = ENV['EXAMPLE_ENV'] || 'dev'

# Use a builder pattern so we can mix and match components via a config file
require 'rack/rewrite'
require 'config/app'
require 'r/oauth2/rack'
config = Config::App.new(environment)

# Session
use Rack::Session::Cookie, config.session_parameters

# Rewrite
use Rack::Rewrite do
  rewrite   '/',  '/www/index.html'
  rewrite   '/views/main.html', '/s/views/main.html'
end

# Define our own wrapper around oauth to check for authenticated
# sessions
#use R::OAuth2::Rack, config.oauth_parameters

# Finally map all our Sinatra/Grape calls to urls and pass them to
# rack to run
run Rack::URLMap.new(config.map_urls)
