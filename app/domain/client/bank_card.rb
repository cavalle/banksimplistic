class BankCard
  include Validable

  attr_accessor :number

  def initialize(number, client)
    @active = true
    @number = number
    @client = client
  end

  def cancel
    self.should_be_active

    @client.apply_event :card_cancelled, :card_number => @number,
                                         :client_uid  => @client.uid
  end

  def on_card_cancelled(event)
    @active = false
  end

private

  def self.generate_number
    4.times.map{ 4.times.map { rand(9) }.join }.join(" ") 
  end
  
  def is_active?
    @active
  end

end
