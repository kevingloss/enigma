require './lib/enigma'
require './lib/message'

# create a message with argv arguments
message = Message.new(ARGV)

#pass arguments into enigma.encrypt
enigma = Enigma.new

# have message write to translated file

# print runner summary statement
puts "Created '#{ARGV[1]}' with the key #{enigma[:key]} and date #{enigma[:date]}"
