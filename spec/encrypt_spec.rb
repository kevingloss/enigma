require 'simplecov'
SimpleCov.start

require './lib/encrypt'

RSpec.describe Encrypt do
  before(:all) do
    @encrypt = Encrypt.new
  end

  it 'exists' do
    expect(@encrypt).to be_an_instance_of(Encrypt)
  end

  xit 'reads in a message' do

  end

  xit 'writes an encrypted file' do

  end

  xit 'outputs a summary message' do

  end
end
