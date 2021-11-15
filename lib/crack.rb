require './lib/enigma'
require './lib/message'

# create a message with argv arguments
message = Message.new(ARGV)

#pass arguments into enigma.encrypt
enigma = Enigma.new
cracked_message = enigma.crack(message.message, message.date)
# have message write to translated file
message.write(ARGV[1], cracked_message[:decryption])
# print runner summary statement
puts "Created '#{ARGV[1]}' with the cracked key #{cracked_message[:key]} and date #{cracked_message[:date]}"
