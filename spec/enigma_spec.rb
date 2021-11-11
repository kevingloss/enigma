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

    it 'can split the key up into 4 key parts' do
      expected = [2, 27, 71, 15]

      expect(enigma.letter_keys('02715')).to eq(expected)
    end

    it 'can find todays date' do
      require 'date'
      date = Date.today.strftime("%d%m%y")
      # tested for current date prior to setting the variable up
      expect(enigma.date_today).to eq(date)
      expect(enigma.date_today.length).to eq(6)
    end

    it 'can split the key up into 4 offset parts' do
      expected = [1, 0, 2, 5]

      expect(enigma.letter_offsets('040895')).to eq(expected)
    end

    it 'can create the shifts using the keys and offsets' do
      expected = {
        A: 3,
        B: 27,
        C: 73,
        D: 20
      }

      expect(enigma.shifts('02715', '040895')).to eq(expected)
    end

    describe 'can remove and replace special characters' do
      it 'can remove special characters from a message' do
        expected = ["h", "l", " ", "m", "y", " ", "n", "m", "e", " ", "s", " ", "k", "v", "n"]
        expect(enigma.remove_special_chars('h31l0 my n4me 1s k3v1n')).to eq(expected)
      end
    end

    xit '#encrypt' do
      input = enigma.encrypt("Hello World", "02715", "040895")
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
