require 'simplecov'
SimpleCov.start

require './lib/enigma'

RSpec.describe Enigma do


  describe 'can encrypt messages with key and date' do
    let(:enigma) {Enigma.new}

    it 'exists' do
      expect(enigma).to be_an_instance_of(Enigma)
    end

    it 'can randomly choose a key' do
      expect(enigma.random_key).to be_an_instance_of(String)
      expect(enigma.random_key.length).to eq(5)
    end

    it 'can split the key up into 4 parts' do
      expected = {
        a: 2,
        b: 27,
        c: 71,
        d: 15
      }

      expect(enigma.letter_keys('02715')).to eq(expected)
    end

    it 'can find todays date' do
      require 'date'
      date = Date.today.strftime("%d%m%y")
      # tested for current date prior to setting the variable up
      expect(enigma.date_today).to eq(date)
      expect(enigma.date_today.length).to eq(6)
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
