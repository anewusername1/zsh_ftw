class MethodFinder
   def initialize( obj, *args )
     @obj = obj
     @args = args
   end
   def ==( val )
     MethodFinder.show( @obj, val, *@args )
   end

# Find all methods on [anObject] which, when called with [args] return [expectedResult]
  def self.find( anObject, expectedResult, *args, &block )
    $in_method_find = true
    eval 'class DummyOut; def write(*args); end; end;'
    stdout, stderr = $stdout, $stderr
    $stdout = $stderr = DummyOut.new
    # change this back to == if you become worried about speed or something
    res = anObject.methods.select { |name| anObject.method(name).arity <= args.size }.
             select { |name| begin anObject.megaClone.method( name ).call( *args, &block ) == expectedResult;
                             rescue Object; end }
    $stdout, $stderr = stdout, stderr
    $in_method_find = false
    res
  end

  # Pretty-prints the results of the previous method
  def self.show( anObject, expectedResult, *args, &block)
    find( anObject, expectedResult, *args, &block).each { |name|
      print "#{anObject.inspect}.#{name}"
      print "(" + args.map { |o| o.inspect }.join(", ") + ")" unless args.empty?
      puts " == #{expectedResult.inspect}"
    }
  end
end
