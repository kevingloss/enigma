require 'simplecov'
SimpleCov.start

require './lib/enigma'

RSpec.describe Enigma do


  describe 'can read and write to messages' do
    before(:all) do
      @enigma = Enigma.new
    end

    it 'exists' do
      expect(@enigma).to be_an_instance_of(Enigma)
    end

    xit 'has attributes' do
      expect(@enigma.message).to eq('hello world')
      expect(@enigma.key).to eq('')
      expect(@enigma.date).to eq('')
    end
  end
end
