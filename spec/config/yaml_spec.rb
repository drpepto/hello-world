require 'spec_helper'
require 'config/yaml'

describe Yaml do

  it 'should read and interpret yaml config files' do
    Yaml.load_config_file('cfg/app.yml')
    expect(Yaml.app[:name]).to eq('Test App')
    expect(Yaml.app[:environments][:list].size).to eq(4)
    expect(Yaml.app[:environments][:default_environment]).to eq('dev')
  end

end
