class Object
  def what?(*a)
    MethodFinder.new(self, *a) unless $in_method_find
  end

  def megaClone
    begin self.clone; rescue; self; end
  end

  def local_methods
    (methods - Object.instance_methods).sort
  end

  #def request(options = {})
  #  url=app.url_for(options)
  #  app.get(url)
  #  puts app.html_document.root.to_s
  #end

  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end

  def to_clipboard
    `echo '#{self.inspect.to_string}' |pbcopy`
  end

  def from_clipboard
    eval(`pbpaste`.chomp)
  end
end

