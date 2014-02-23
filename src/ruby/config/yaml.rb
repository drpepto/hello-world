
# Author:  Andy Olsen
# Date:    23 Feb 2014
# Purpose: Config singleton
# Based on work from (http://speakmy.name/2011/05/29/simple-configuration-for-ruby-apps)
# Thanks guys!

module Yaml
  extend self
  @_settings = {}
  attr_reader :_settings

  # This is the main point of entry - we call Settings.load! and provide
  # a name of the file to read as it's argument. We can also pass in some
  # options, but at the moment it's being used to allow per-environment
  # overrides in Rails
  def load_config_file(filename, options = {})
    newsets = YAML::load_file(filename)
    newsets = symbolize(newsets)
    newsets = newsets[options[:env].to_sym] if options[:env] && newsets[options[:env].to_sym]
    deep_merge!(@_settings, newsets)
  end
  
  # Ruby magic to recursively genuflect strings to symbols
  def symbolize(obj)
    return obj.inject({}){|memo,(k,v)| memo[k.to_sym] =  symbolize(v); memo} if obj.is_a? Hash
    return obj.inject([]){|memo,v    | memo           << symbolize(v); memo} if obj.is_a? Array
    return obj
  end
  
  # Deep merging of hashes
  # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end
  
  def method_missing(name, *args, &block)
    @_settings[name.to_sym] ||
      fail(NoMethodError, "unknown configuration root #{name}", caller)
  end
end

