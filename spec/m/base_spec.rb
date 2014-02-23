require 'spec_helper'
require 'm/base'

describe M::Base do

  it 'save items' do
    m = M::Base.new(:my_space)
    ids = m.create({:hello => 'world'})
    ids[0].should == 1

    ids = m.create({:hello => 'Jim'})
    ids[0].should == 2
  end
end
