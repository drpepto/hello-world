require 'spec_helper'
require 'hello/rest'

describe Hello::Rest do
  include Rack::Test::Methods

  def app
    Hello::Rest
  end


  it 'should create new sayings' do
    post '/say/', {:say => { :say => 'Waka'}}
    last_response.status.should == 201
    last_response.body.should == [1].to_json
  end

  it 'should read existing records' do
    get '/say/1'
    last_response.status.should == 200
    last_response.body.should == {:say => 'Waka',:id => 1}.to_json
  end

  it 'should update existing records' do
    put '/say/1', {:say => { :say => 'Waja', :id => 1}}
    last_response.status.should == 200
    last_response.body.should == [1].to_json
  end

  it 'should delete existing records' do
    delete '/say/1'
    last_response.status.should == 200
    last_response.body.should == [1].to_json
  end

end
