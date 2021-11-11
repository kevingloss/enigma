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

  def letter_keys(key = random_key)
    # letters = (:A..:D).to_a
    key_shift = key.chars.each_cons(2).map {|key| key.join.to_i}
    # Hash[letters.zip(key_shift)]
  end

  def date_today
    Date.today.strftime("%d%m%y")
  end

  def letter_offsets(date = date_today)
    offsets = (date.to_i ** 2).to_s[-4..-1].split(//)
    offsets.map {|offset| offset.to_i}
  end

end
