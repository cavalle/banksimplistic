class Event
  attr_accessor :name, :aggregate_uid, :attributes
  
  def initialize(*args)
    @name, @aggregate_uid, @attributes = args
  end
end