require 'date'

class Enigma
  # attr_reader

  def initialize
    @character_set = ('a'..'z').to_a.push(' ')
  end

  def random_key
    rand(99999).to_s.rjust(5, '0')
  end

  def shift_keys(key)
    key.chars.each_cons(2).map {|key| key.join.to_i}
  end

  def shift_offsets(date)
    offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
    offsets.map {|offset| offset.to_i}
  end

  def date_today
    Date.today.strftime("%d%m%y")
  end

  def shifts(key, date)
    index = (0..3).to_a
    key_offsets = shift_keys(key).zip(shift_offsets(date))
    shifts = key_offsets.map {|key_offset| key_offset.sum}
    index.zip(shifts).to_h
  end

  def encrypt(message, key = random_key, date = date_today)
    message = message.downcase.split(//)
    shifts = shifts(key, date)
    encrypted_message = encrypt_letters(message, shifts).join
    encrypted_transmission = {
      encryption: encrypted_message,
      key:  key,
      date: date
    }
  end

  def encrypt_letters(message, shifts)
    index = 0
    message.map do |letter|
      if @character_set.include?(letter) == true
        encrypted_char = @character_set.zip(@character_set.rotate(shifts[index%4])).to_h
        index += 1
        encrypted_char[letter]
      else
        letter
      end
    end
  end

  def decrypt(message, key, date = date_today)
    message = message.downcase.split(//)
    shifts = shifts(key, date)
    decrypted_message = decrypt_letters(message, shifts).join
    decrypted_transmission = {
      decryption: decrypted_message,
      key:  key,
      date: date
    }
  end

  def decrypt_letters(message, shifts)
    index = 0
    message.map do |letter|
      if @character_set.include?(letter) == true
        decrypted_char = @character_set.zip(@character_set.rotate(-1 * shifts[index%4])).to_h
        index += 1
        decrypted_char[letter]
      else
        letter
      end
    end
  end
end
