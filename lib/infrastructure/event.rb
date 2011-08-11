class Event < Ohm::Model
  attribute :name
  attribute :aggregate_uid
  attribute :serialized_data
  
  def data
    @data ||= begin
      value = read_local(:serialized_data)
      value && YAML.load(value).with_indifferent_access
    end
  end
  
  def data=(value)
    @data = value
    write_local(:serialized_data, value.to_yaml)
  end
  
  index :aggregate_uid
end