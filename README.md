# Hello World
This is a collection of ruby and angular code to implement a full stack hello world application complete with OAuth2 identification.

## Prerequisites
### Linux
First you need to have the build tools installed so ruby bundler can build some of the gems

#### Fedora
`sudo yum groupinstall "Development Tools"`

#### Debian
`sudo apt-get install build-essential`

#### OpenSuSE
`sudo zypper install -t pattern devel_C_C++`

### Windows
Any Windows magic men (*cough* excuse me, magic <i>persons<i>, *cough*) want
to fill out this part? I would not look askance at friendly pull request.

# Install the gems needed with ruby bundler
`sudo bundle`

# Checking out the code
`mkdir ~/mysandbox; cd ~/mysandbox; git clone https://github.com/landrewolsen/hello-world`

# Ruby Rake
`cd hello-world; rake`

You should see something like this:

>/usr/bin/ruby2.0 -S rspec spec/config/yaml_spec.rb spec/hello/rest_spec.rb spec/m/base_spec.rb spec/m/builder_spec.rb spec/m/memory_spec.rb spec/r/oauth2/bearer_spec.rb spec/r/oauth2/builder_spec.rb spec/r/oauth2/rack_spec.rb -Isrc/ruby
>.............................................
>
>Finished in 0.10188 seconds
>45 examples, 0 failures
>Coverage report generated for RSpec to /home/aolsen/sb/hello/coverage. 456 / 463 LOC (98.49%) covered.

Coverage report will be in "coverage/index.html"

# Running:
If you run rackup from the command line:

`rackup`

You can see the app <a href="localhost:9292/#">here</a>

# More on:
* <a href="doc/grape.md">Grape</a>
* <a href="doc/sinatra.md">Sinatra</a>
* <a href="doc/angular.md">AngularJS</a>
* <a href="doc/rackup.md">Rackup</a>
* <a href="doc/oauth.md">OAuth</a>
* <a href="doc/rake.md">Rake</a>
