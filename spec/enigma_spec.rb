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
      expected = [3, 27, 73, 20]

      expect(enigma.shifts('02715', '040895')).to eq(expected)
    end

    it 'can create the shift wheels' do
      character_set = ('a'..'z').to_a.push(' ')
      shifts = enigma.shifts('02715', '040895')
      shift_a = character_set.zip(character_set.rotate(3)).to_h
      shift_b = character_set.zip(character_set.rotate(27)).to_h
      shift_c = character_set.zip(character_set.rotate(73)).to_h
      shift_d = character_set.zip(character_set.rotate(20)).to_h
      expected = [shift_a, shift_b, shift_c, shift_d]

      expect(enigma.shift_wheel(shifts)).to eq(expected)
    end

    it 'can shift letters to encrypt or decrypt letters' do
      shifts = enigma.shifts('02715', '040895')
      message = ['h', 'e', 'l', '!', 'l', 'o']
      expected = ['k', 'e', 'd', '!', 'e', 'r']

      expect(enigma.shift_letters(message, enigma.shift_wheel(shifts))).to eq(expected)

      shifts = enigma.shifts("02715", "040895").map {|shift| shift * -1}
      message = ['k', 'e', 'd', '!', 'e', 'r']
      expected = ['h', 'e', 'l', '!', 'l', 'o']

      expect(enigma.shift_letters(message, enigma.shift_wheel(shifts))).to eq(expected)
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

        expected = {
          encryption: "rfdayaodamw",
          key: "02715",
          date: "080989"
          }

        expect(encrypted).to eq(expected)
      end
    end

    describe 'it can decrypt' do
      it 'can decrypt letters' do
        shifts = enigma.shifts("02715", "040895").map {|shift| shift * -1}
        message = ['k', 'e', 'd', '!', 'e', 'r']
        expected = ['h', 'e', 'l', '!', 'l', 'o']

        expect(enigma.shift_letters(message, enigma.shift_wheel(shifts))).to eq(expected)
      end

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
        message = Message.new(['encrypted.txt', 'decrypted.txt', '02715'])
        allow(message).to receive(:message) {'rfdayaodamw'}
        allow(message).to receive(:date) {'080989'}

        decrypted = enigma.decrypt(message.message, message.key, message.date)
        expected = {
          decryption: "hello world",
          key: "02715",
          date: "080989"
        }

        expect(decrypted).to eq(expected)
      end
    end

    describe 'cracking' do
      it 'can find the shifts' do
        ciphertext = ("vjqtbeaweqihssi").downcase.split(//).reverse
        expected = [5, 5, 14, 8]

        expect(enigma.crack_shifts(ciphertext)).to eq(expected)
      end

      it 'can crack a message with message and date' do
        expected = {
          decryption: "hello world end",
          date: "291018",
          key: "08304"
        }

        cracked = enigma.crack("vjqtbeaweqihssi", "291018")

        expect(cracked).to eq(expected)
      end

      it 'can crack a message with message and date today' do
        message = Message.new(['encrypted.txt', 'cracked.txt'])
        allow(message).to receive(:message) {"vjqtbeaweqihssi"}
        allow(message).to receive(:date) {'291018'}

        expected = {
          decryption: "hello world end",
          date: "291018",
          key: "08304"
        }

        cracked = enigma.crack(message.message, message.date)

        expect(cracked).to eq(expected)
      end
    end
  end
end
