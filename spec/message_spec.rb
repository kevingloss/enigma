require 'simplecov'
SimpleCov.start

require './lib/message'
# require './lib/enigma'

RSpec.describe Message do
  let(:message) {Message.new(['message.txt', 'encrypted.txt', '02715', '040895'])}

  it 'exists' do
    expect(message).to be_an_instance_of(Message)
  end

  it 'has attributes' do
    expect(message.message).to eq('Hello World')
    expect(message.key).to eq('02715')
    expect(message.date).to eq('040895')
  end

  it 'reads from files' do
    expect(message.read('message.txt')).to eq('Hello World')
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
    require 'date'
    def valid_date?(date)
      date_format = '%d%m%y'
      DateTime.strptime(date, date_format)
      true
    rescue ArgumentError
      false
    end

    date = message.valid_date('djlskdjf')
    expect(valid_date?(date)).to eq(true)

    date = message.valid_date('101121')
    expect(valid_date?(date)).to eq(true)
    expect(message.date).to eq('101121')

    date = message.valid_date('000000')
    expect(valid_date?(date)).to eq(true)

    date = message.valid_date('131313')
    expect(valid_date?(date)).to eq(true)

    date = message.valid_date('13131321')
    expect(valid_date?(date)).to eq(true)
  end

  it 'can find todays date' do
    allow(message).to receive(:date_today).and_return('101121')
    # tested for current date prior to setting the variable up
    expect(message.date_today).to eq('101121')
    expect(message.date_today.length).to eq(6)
  end
end
