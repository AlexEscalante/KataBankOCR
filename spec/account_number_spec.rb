require_relative '../account_number.rb'

RSpec.describe AccountNumber do  
  it "detects valid account numbers" do
    valid_numbers   = ["000000051", "490867715", "457508000"]

    for number in valid_numbers do
      expect(AccountNumber.new(number)).to be_valid
      expect(AccountNumber.new(number)).not_to be_ill
    end
  end

  it "detects invalid account numbers" do
    invalid_numbers = ["111111111", "222222222", "333333333", "444444444",]

    for number in invalid_numbers do
      expect(AccountNumber.new(number)).not_to be_valid
      expect(AccountNumber.new(number)).not_to be_ill
    end
  end

  it "detects ill account numbers" do
    ill_numbers = ["49006771?", "1234?678?"]

    for number in ill_numbers do
      expect(AccountNumber.new(number)).not_to be_valid
      expect(AccountNumber.new(number)).to be_ill
    end
  end

  it "correctly parses reference file" do 
    numbers = [ 
      "000000000",
      "111111111",
      "222222222",
      "333333333",
      "444444444",
      "555555555",
      "666666666",
      "777777777",
      "888888888",
      "999999999",
      "123456789",
      "000000051",
      "49006771?",
      "1234?678?",
      "490067715"
    ]

    AccountNumber.readlines("test.txt").each_with_index { |n, i| expect(n).to eq(numbers[i]) }
  end

  it "signals an error when parsing a malformed file" do
    # turn on debug to see ouput messages for unreadable digits
    # AccountNumber.debug = true
    expect{AccountNumber.readlines("with_error.txt")}.to raise_error(ArgumentError, "wrong record 6, size: 27")
  end
end
