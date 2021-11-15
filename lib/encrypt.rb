require './lib/enigma'
require './lib/message'

# create a message with argv arguments
# message = Message.new(ARGV)

#pass arguments into enigma.encrypt
enigma = Enigma.new
encryption = enigma.encrypt(enigma.message, enigma.key, enigma.date)
# have message write to translated file
enigma.write(ARGV[1], encryption[:encryption])
# print runner summary statement
puts "Created '#{ARGV[1]}' with the key #{encryption[:key]} and date #{encryption[:date]}"
