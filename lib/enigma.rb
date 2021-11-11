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

  end

  def date_today
    Date.today.strftime("%d%m%y")
  end
end
