require 'date'

class Enigma
  # attr_reader

  def initialize()
    # @message = message
    # @key = key
    # @date = date
  end

  def random_key
    rand(99999).to_s.rjust(5, '0')
  end

  def letter_keys(key)
    key_shift = key.chars.each_cons(2).map {|key| key.join.to_i}
  end

  def date_today
    Date.today.strftime("%d%m%y")
  end

  def letter_offsets(date)
    offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
    offsets.map {|offset| offset.to_i}
  end

  def shifts(key, date)
    letters = (:A..:D).to_a
    key_offsets = letter_keys(key).zip(letter_offsets(date))
    shifts = key_offsets.map {|key_offset| key_offset.sum}
    Hash[letters.zip(shifts)]
  end

  def encrypt(message, key = random_key, date = date_today)

  end
end
