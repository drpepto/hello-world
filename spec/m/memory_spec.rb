require 'spec_helper'
require 'm/base'

describe M::Memory do

  it 'puts item in the store' do
    m = M::Memory.new
    m.put(:hello, 1, {:say => 'world'})
    foo = m.get(:hello, 1)
    foo.should == {:say => 'world'}
  end
end
