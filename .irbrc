#$VERBOSE=nil
require 'rubygems'
IRB.conf[:AUTO_INDENT] = false
IRB.conf[:USE_READLINE] = true
Dir[File.expand_path('~/.ruby_scripts/*', File.dirname(__FILE__))].each {|f| require f}
