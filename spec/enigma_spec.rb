require 'simplecov'
SimpleCov.start

require './lib/enigma'

RSpec.describe Enigma do


  describe 'can encrypt messages with key and date' do
    let(:enigma) {Enigma.new}

    it 'exists' do
      expect(enigma).to be_an_instance_of(Enigma)
    end

    it 'can find todays date' do
      expect(enigma.date_today).to eq('101121')
    end

    xit '#encrypt' do
      input = enigma.encrypt("hello world", "02715", "040895")
      output = {
        encryption: "keder ohulw",
        key: "02715",
        date: "040895"
        }

      expect(input).to eq(output)
    end
  end
end

# # decrypt a message with a key and date
# enigma.decrypt("keder ohulw", "02715", "040895")
# #=>
# #   {
# #     decryption: "hello world",
# #     key: "02715",
# #     date: "040895"
# #   }
#
# # encrypt a message with a key (uses today's date)
# encrypted = enigma.encrypt("hello world", "02715")
# #=> # encryption hash here
#
# #decrypt a message with a key (uses today's date)
# enigma.decrypt(encrypted[:encryption], "02715")
# #=> # decryption hash here
#
# # encrypt a message (generates random key and uses today's date)
# enigma.encrypt("hello world")
# #=> # encryption hash here
