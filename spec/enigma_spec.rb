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

      expect(enigma.shift_keys('02715')).to eq(expected)
    end

    it 'can split the key up into 4 offset parts' do
      expected = [1, 0, 2, 5]

      expect(enigma.shift_offsets('040895')).to eq(expected)
    end

    it 'can find todays date' do
      require 'date'
      allow(enigma).to receive(:date_today).and_return('101121')
      # tested for current date prior to setting the variable up
      expect(enigma.date_today).to eq('101121')
      expect(enigma.date_today.length).to eq(6)
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

    describe 'it can encrypt' do
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
        allow(enigma).to receive(:date_today).and_return('080989')

        encrypted = enigma.encrypt("hello world", "02715")
        expected = {
          encryption: "rfdayaodamw",
          key: "02715",
          date: "080989"
          }

        expect(encrypted).to eq(expected)
      end

      it 'only needs a message' do
        encrypted = enigma.encrypt("hello world")

        expect(encrypted).to be_an_instance_of(Hash)
        expect(encrypted[:encryption].length).to eq(11)
        expect(encrypted[:key].length).to eq(5)
        expect(encrypted[:date].length).to eq(6)

        allow(enigma).to receive(:date_today) {'080989'}
        allow(enigma).to receive(:random_key) {'02715'}

        encrypted = enigma.encrypt("hello world")
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
        decrypted = enigma.decrypt("keder ohulw", "02715", "040895")
        expected = {
          decryption: "hello world",
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
