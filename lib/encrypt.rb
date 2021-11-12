require './enigma'


class Encrypt
  attr_reader :enigma

  def initialize
    @enigma = Enigma.new.encrypt(read, ARGV[2], ARGV[3])
  end

  def read
    read_file = File.open(ARGV[0], 'r')
    read_file.read
  end

  def write
    write_file = File.open(ARGV[1], 'w')
    write_file.write(@enigma[:encryption])
    write_file.close
  end
end


encrypt = Encrypt.new
