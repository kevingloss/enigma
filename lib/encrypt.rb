require './lib/enigma'
require './lib/message'

message = Message.new(ARGV)
enigma = Enigma.new

puts "Created '#{ARGV[1]}' with the key #{encrypt.enigma[:key]} and date #{encrypt.enigma[:date]}"
