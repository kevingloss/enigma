require 'simplecov'
SimpleCov.start

require './lib/message'

RSpec.describe Message do
  let(:message) {Message.new(['message.txt', 'encrypted.txt', '02715', '040895'])}

  it 'exists' do
    expect(message).to be_an_instance_of(Message)
  end

  it 'has attributes' do
    read_message = File.read('message.txt').chomp

    expect(message.message).to eq(read_message)
    expect(message.key).to eq('02715')
    expect(message.date).to eq('040895')
  end

  it 'reads from files' do
    read_message = File.read('message.txt').chomp

    expect(message.read('message.txt')).to eq(read_message)
  end

  it 'writes to files' do
    message.write('test_write.txt', 'keder ohulw')

    expect(message.read('test_write.txt').chomp).to eq('keder ohulw')
  end

  it 'can test for a valid key' do
    key = message.valid_key(nil)
    expect = ('00000'..'99999').to_a.include?(key)

    expect(expect).to eq(true)

    key = message.valid_key('890432')
    expect = ('00000'..'99999').to_a.include?(key)

    expect(expect).to eq(true)

    key = message.valid_key('hello')
    expect = ('00000'..'99999').to_a.include?(key)

    expect(expect).to eq(true)
    expect(message.valid_key('02715')).to eq('02715')
  end

  it 'can randomly choose a key' do
    expect(message.random_key).to be_an_instance_of(String)
    expect(message.random_key.length).to eq(5)
  end

  it 'can test for a valid date' do
    today = Date.today.strftime('%d%m%y')

    expect(message.valid_date('101121')).to eq('101121')
    expect(message.valid_date('dlkfjd')).to eq(today)
    expect(message.valid_date(nil)).to eq(today)
    expect(message.valid_date('11112021')).to eq(today)
  end

  it 'can find todays date' do
    today = Date.today.strftime('%d%m%y')
    # tested for current date prior to setting the variable up
    expect(message.date_today).to eq(today)
    expect(message.date_today.length).to eq(6)
  end
end
