class BankCard
  include Entity

  attr_accessor :number

  def self.create(client_uid)
    card = self.new
    card.apply_event :card_created, :number => generate_new_card_number, 
                                    :client_uid => client_uid 
    card
  end

  def cancel
    self.should_exist
    self.should_be_active

    apply_event :card_cancelled, :card_number => @number,
                                 :client_uid  => @client_uid
  end

private

  def self.generate_new_card_number
    4.times.map{ 4.times.map { rand(9) }.join }.join("-") 
  end

  def is_active?
    @active
  end

  def on_card_created(event)
    @active = true
    @number = event.data[:number]
    @uid    = event.data[:number]
    @client_uid = event.data[:client_uid]
  end

  def on_card_cancelled(event)
    @active = false
  end
end
