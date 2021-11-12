require 'simplecov'
SimpleCov.start

require './lib/enigma'
require './lib/message'

RSpec.describe Enigma do
  describe 'can encrypt messages with key and date' do
    let(:enigma) {Enigma.new}

    it 'exists' do
      expect(enigma).to be_an_instance_of(Enigma)
    end

    it 'can split the key up into 4 key parts' do
      expected = [2, 27, 71, 15]

      expect(enigma.shift_keys('02715')).to eq(expected)
    end

    it 'can split the key up into 4 offset parts' do
      expected = [1, 0, 2, 5]

      expect(enigma.shift_offsets('040895')).to eq(expected)
    end

    it 'can create the shifts by index position using the keys and offsets' do
      expected = {
        0 => 3,
        1 => 27,
        2 => 73,
        3 => 20
      }

      expect(enigma.shifts('02715', '040895')).to eq(expected)
    end

    it 'can encrypt letters' do
      message = ['h', 'e', 'l', '!', 'l', 'o']
      shifts = {
        0 => 3,
        1 => 27,
        2 => 73,
        3 => 20
      }
      expected = ['k', 'e', 'd', '!', 'e', 'r']

      expect(enigma.encrypt_letters(message, shifts)).to eq(expected)
    end

    describe 'encrypt' do
      it '#encrypt' do
        encrypted = enigma.encrypt("Hello World", "02715", "040895")
        expected = {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
          }

        expect(encrypted).to eq(expected)
      end

      it 'with todays date' do
        message = Message.new(['message.txt', 'encrypted.txt','02715'])
        allow(message).to receive(:date) {'080989'}

        encrypted = enigma.encrypt(message.message, message.key, message.date)
        expected = {
          encryption: "rfdayaodamw",
          key: "02715",
          date: "080989"
          }

        expect(encrypted).to eq(expected)
      end

      it 'only needs a message' do
        message = Message.new(['message.txt', 'encrypted.txt'])
        allow(message).to receive(:date) {'080989'}
        allow(message).to receive(:key) {'02715'}
        encrypted = enigma.encrypt(message.message, message.key, message.date)

        expect(encrypted).to be_an_instance_of(Hash)
        expect(encrypted[:encryption].length).to eq(11)
        expect(encrypted[:key].length).to eq(5)
        expect(encrypted[:date].length).to eq(6)

        # allow(enigma).to receive(:date) {'080989'}
        # allow(enigma).to receive(:key) {'02715'}

        expected = {
          encryption: "rfdayaodamw",
          key: "02715",
          date: "080989"
          }

        expect(encrypted).to eq(expected)
      end
    end

    describe 'it can decrypt' do
      it 'can decrypt with all arguments' do
        decrypted = enigma.decrypt("keder! ohulw!", "02715", "040895")
        expected = {
          decryption: "hello! world!",
          key: "02715",
          date: "040895"
        }

        expect(decrypted).to eq(expected)
      end

      it 'can decrypt with all arguments' do
        allow(enigma).to receive(:date_today) {'080989'}

        decrypted = enigma.decrypt("rfdayaodamw", "02715")
        expected = {
          decryption: "hello world",
          key: "02715",
          date: "080989"
        }

        expect(decrypted).to eq(expected)
      end
    end
  end
end
