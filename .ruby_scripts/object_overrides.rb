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

  def request(options = {})
    url=app.url_for(options)
    app.get(url)
    puts app.html_document.root.to_s
  end
end

