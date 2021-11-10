require 'simplecov'
SimpleCov.start

require './lib/decrypt'

RSpec.describe Decrypt do
  before(:all) do
    @decrypt = Decrypt.new
  end

  it 'exists' do
    expect(@decrypt).to be_an_instance_of(Decrypt)
  end

  xit 'reads in an encrypted message' do

  end

  xit 'writes a decrypted file' do

  end

  xit 'outputs a summary message' do

  end
end
