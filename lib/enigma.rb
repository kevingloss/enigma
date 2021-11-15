class Enigma

  def initialize
    @character_set = ('a'..'z').to_a.push(' ')
  end

  def shift_keys(key)
    key.chars.each_cons(2).map {|key| key.join.to_i}
  end

  def shift_offsets(date)
    offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
    offsets.map {|offset| offset.to_i}
  end

  def shifts(key, date)
    index = (0..3).to_a
    key_offsets = shift_keys(key).zip(shift_offsets(date))
    shifts = key_offsets.map {|key_offset| key_offset.sum}
  end

  def shift_wheel(shifts)
    shifts.map do |shift|
      @character_set.zip(@character_set.rotate(shift)).to_h
    end
  end

  def shift_letters(message, shift_wheel)
    index = 0
    message.map do |letter|
      if @character_set.include?(letter)
        shifted = shift_wheel[index%4]
        index += 1
        shifted[letter]
      else
        letter
      end
    end
  end

  def encrypt(message, key, date)
    message = message.downcase.split(//)
    shifts = shifts(key, date)
    shift_wheel = shift_wheel(shifts)
    encrypted_message = shift_letters(message, shift_wheel).join
    encrypted_transmission = {
      encryption: encrypted_message,
      key:  key,
      date: date
    }
  end

  def decrypt(message, key, date)
    message = message.downcase.split(//)
    shifts = shifts(key, date).map {|shift| shift * -1}
    shift_wheel = shift_wheel(shifts)
    decrypted_message = shift_letters(message, shift_wheel).join
    decrypted_transmission = {
      decryption: decrypted_message,
      key:  key,
      date: date
    }
  end

  def crack(ciphertext, date)
    ciphertext = ciphertext.downcase.split(//)
    shifts = crack_shifts(ciphertext)
    shift_wheel = shift_wheel(shifts.map {|shift| shift * -1})
    cracked_message = shift_letters(ciphertext, shift_wheel).join
    key = crack_key(shifts, date)
    # cracked_transmission = {
    #   decryption: cracked_message,
    #   date: date,
    #   key:  key
    # }
  end

  def crack_shifts(ciphertext)
    known = ciphertext.reverse[0..3]
    shift_1 = (@character_set.index(known[0]) - @character_set.index('d')) % 27
    shift_2 = (@character_set.index(known[1]) - @character_set.index('n')) % 27
    shift_3 = (@character_set.index(known[2]) - @character_set.index('e')) % 27
    shift_4 = (@character_set.index(known[3]) - @character_set.index(' ')) % 27
    adjusted_shifts = [shift_1, shift_2, shift_3, shift_4]
    shifts = adjusted_shifts.rotate(ciphertext.length % 4).reverse
    # require 'pry'; binding.pry
  end

  def crack_key(shifts, date)
    offset = shift_offsets(date)
    # require 'pry'; binding.pry
    shift_keys = shifts.zip(offset).map {|shift_offset| shift_offset[0] - shift_offset[1]}
  end
# use these to work backwards and find the key
  # def shift_keys(key)
  #   key.chars.each_cons(2).map {|key| key.join.to_i}
  # end
  #
  # def shift_offsets(date)
  #   offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
  #   offsets.map {|offset| offset.to_i}
  # end
  #
  # def shifts(key, date)
  #   index = (0..3).to_a
  #   key_offsets = shift_keys(key).zip(shift_offsets(date))
  #   shifts = key_offsets.map {|key_offset| key_offset.sum}
  # end
end
