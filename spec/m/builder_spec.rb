require 'spec_helper'
require 'm/builder'

describe M::Builder do

  it 'save items' do
    m = M::Builder.instance.get_model(M::Builder::HELLO)
    ids = m.create({:hello => 'world'})
    ids[0].should == 2
    all = m.read_all()
    all.size.should == 1

    m = M::Builder.instance.get_model(M::Builder::HELLO)
    say = m.read(2)
    say.should == {:hello => 'world', :id => 2}

    ids = m.create({:hello => 'Jim'})
    ids[0].should == 3
    all = m.read_all()
    all.size.should == 2

    ids = m.delete(3)
    ids[0].should == 3

    all = m.read_all()
    all.size.should == 1

  end

end
