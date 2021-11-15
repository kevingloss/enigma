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
    cracked_transmission = {
      decryption: cracked_message,
      date: date,
      key:  key
    }
  end

  def crack_shifts(ciphertext)
    known = ciphertext.reverse[0..3]
    shift_1 = (@character_set.index(known[0]) - @character_set.index('d')) % 27
    shift_2 = (@character_set.index(known[1]) - @character_set.index('n')) % 27
    shift_3 = (@character_set.index(known[2]) - @character_set.index('e')) % 27
    shift_4 = (@character_set.index(known[3]) - @character_set.index(' ')) % 27
    adjusted_shifts = [shift_1, shift_2, shift_3, shift_4]
    cipher_length = ciphertext.count {|letter| @character_set.include?(letter)}
    shifts = adjusted_shifts.rotate(cipher_length % 4).reverse
  end

  def crack_key(shifts, date)
    offset = shift_offsets(date)
    a_keys = key_parts(shifts[0], offset[0])
    b_keys = key_parts(shifts[1], offset[1])
    c_keys = key_parts(shifts[2], offset[2])
    d_keys = key_parts(shifts[3], offset[3])
    cracked_key(a_keys, b_keys, c_keys, d_keys)
  end

  def key_parts(shift, offset)
    key_parts = []
    key = shift - offset
    until key > 99
      key_parts.push(key)
      key += 27
    end
    key_parts.map {|key| key.to_s.rjust(2, '0')}
  end

  def cracked_key(a_keys, b_keys, c_keys, d_keys)
    ab_keys = a_keys.map do |a_key|
      [a_key, b_keys.find {|b_key| b_key[0] == a_key[1]}].join
    end
    abc_keys = ab_keys.map do |ab_key|
      [ab_key, c_keys.find {|c_key| c_key[0] == ab_key[-1]}].join
    end
    abcd_keys = abc_keys.map do |abc_key|
      [abc_key, d_keys.find {|d_key| d_key[0] == abc_key[-1]}].join
    end
    key = abcd_keys.find {|key| key.length == 8}
    key[0..1] + key[4..5] + key[7]
  end
end
