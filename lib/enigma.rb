require 'date'

class Enigma
  # attr_reader

  def initialize
    @character_set = ('a'..'z').to_a.push(' ')
  end

  def random_key
    rand(99999).to_s.rjust(5, '0')
  end

  def letter_keys(key)
    key.chars.each_cons(2).map {|key| key.join.to_i}
  end

  def letter_offsets(date)
    offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
    offsets.map {|offset| offset.to_i}
  end

  def date_today
    Date.today.strftime("%d%m%y")
  end

  def shifts(key, date)
    letters = (:A..:D).to_a
    key_offsets = letter_keys(key).zip(letter_offsets(date))
    shifts = key_offsets.map {|key_offset| key_offset.sum}
    letters.zip(shifts).to_h
  end

  def remove_special_chars(message)
    special_chars_index(message)
    message.split(//).select {|char| char if @character_set.include?(char)}
  end

  def encrypt(message, key = random_key, date = date_today)
    message = remove_special_chars(message.downcase)
    shifts = shifts(key, date)
  end

  def special_chars_index(message)

  end

  def encrypt_letters(message, shifts)
    index = 0
    message.map do |letter|
      if index % 4 == 0

        require 'pry'; binding.pry
        index += 1
        encrypted_char = @character_set.zip(@character_set.rotate(shifts[:A])).to_h
        encrypted_char[letter]
      elsif index % 4 == 1
        index += 1
        @character_set.zip(@character_set.rotate(shifts[:B]))
      elsif index % 4 == 2
        index += 1
        @character_set.zip(@character_set.rotate(shifts[:C]))
      elsif index % 4 == 3
        index += 1
        @character_set.zip(@character_set.rotate(shifts[:D]))
      end
    end
  end

  # def shift_letters(shift)
  #
  # end
end
