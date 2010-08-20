module RedisRepository
  extend self
  
  def clear_data
    keys = redis.keys("fohjin:*")
    keys.each {|key| redis.del(key)}
  end

  def redis
    @redis ||= Ohm.redis
  end

  def encode(hash)
    hash.to_yaml
  end

  def decode(data)
    return unless data
    return data.map{|d|decode(d)} if data.is_a?(Array)
    YAML.load(data)
  end
  
  def method_missing(meth, *args, &blk)
    redis.send(meth, *args, &blk) if redis.respond_to?(meth)
  end
  
end