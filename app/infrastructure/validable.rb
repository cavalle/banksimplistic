module Validable

  def method_missing(meth, *args, &blk)
    if meth.to_s =~ /^should_([^_]+)(_.+)?/
      verb = $1
      predicate = $2
      method = "#{third_personize(verb)}#{predicate}?"
      raise "#{self.class.name.titleize} should #{verb}#{predicate.try(:humanize)} #{args.join(" ")}" unless self.send(method, *args)
    else
      super
    end
  end
  
private

  def third_personize(verb)
    case verb
    when /have/ then "has"
    when /be/ then "is"
    when /s$/ then verb
    else
      "#{verb}s"
    end
  end
  
end
