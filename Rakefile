#!/usr/bin/env ruby
require 'rakeup'
require 'rake/testtask'
require 'rspec/core/rake_task'

# Run unit tests by default
task :default => [:spec]

# These are unit type tests (that is, they are mocked and can run
# anywhere without dependencies)
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = '**/*_spec.rb'
  t.rspec_opts = '-Isrc/ruby'
end

# Using rack, these are more like integration or smoke tests and
# depend on the database being in place and configured
Rake::TestTask.new(:test) do |t|
  t.libs << 'src/ruby'
  t.libs << 'test/ruby'
  t.pattern = '**/test_*.rb'
  t.verbose = false
end

# Use this to launch a quicker server
RakeUp::ServerTask.new do |t|
  t.port = 3333
  t.pid_file = '/tmp/server.pid'
  t.rackup_file = 'config.ru'
  t.server = :thin
end
