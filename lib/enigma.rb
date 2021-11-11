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
    letters = (:a..:d).to_a
    key_shift = key.chars.each_cons(2).map {|key| key.join.to_i}
    Hash[letters.zip(key_shift)]
  end

  def date_today
    Date.today.strftime("%d%m%y")
  end
end
