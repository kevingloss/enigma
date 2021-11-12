require 'date'

class Message
  attr_reader :message, :translated_message, :key, :date

  # make code all of the components of a message: input, output, key, date

  def initialize(attributes)
    @message = read(attributes[0])
    @key = valid_key(attributes[2])
    @date = valid_date(attributes[3])
  end

  def read(file_path = attributes[0])
    read_file = File.read(file_path)
    @message = read_file.chomp
  end

  #pass in the encrypted message
  def write(file_path = attributes[1], message)
    write_file = File.write(file_path, message)
  end

  def valid_key(key)
    if key == nil
      @key = random_key
    elsif key.length == 5 && key.split(//).all? {|char| ('0'..'9').to_a.include?(char)}
      @key = key
    else
      @key = random_key
    end
  end

  def random_key
    ('00000'..'99999').to_a.sample
  end

  def valid_date(date)
    date_format = '%d%m%y'
    DateTime.strptime(date, date_format)
      @date = date
    rescue ArgumentError
      @date = date_today
  end

  def date_today
    Date.today.strftime('%d%m%y')
  end
end
