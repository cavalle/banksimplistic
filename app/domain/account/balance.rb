class Account::Balance
  attr_reader :amount

  def initialize(amount = 0)
    @amount = amount
  end

  def deposite(amount)
    self.class.new(@amount + amount)
  end

  def withdraw(amount)
    self.class.new(@amount - amount)
  end
end
