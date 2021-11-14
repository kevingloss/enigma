require './lib/enigma'
require './lib/message'

# create a message with argv arguments
message = Message.new(ARGV)

#pass arguments into enigma.decrypt
enigma = Enigma.new
decryption = enigma.decrypt(message.message, message.key, message.date)
# have message write to translated file
message.write(ARGV[1], decryption[:decryption])
# print runner summary statement
puts "Created '#{ARGV[1]}' with the key #{decryption[:key]} and date #{decryption[:date]}"
