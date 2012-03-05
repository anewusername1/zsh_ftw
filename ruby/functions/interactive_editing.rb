# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
require 'tempfile'
class InteractiveEditor
  DEBIAN_SENSIBLE_EDITOR = '/usr/bin/sensible-editor'
  MACOSX_OPEN_CMD = 'open'
  XDG_OPEN = '/usr/bin/xdg-open'

  def self.sensible_editor
    return ENV['VISUAL'] if ENV['VISUAL']
    return ENV['EDITOR'] if ENV['EDITOR']
    return MACOSX_OPEN_CMD if Platform::IMPL == :macosx
    if Platform::IMPL == :linux
      if File.executable?(XDG_OPEN)
        return XDG_OPEN
      end
      if File.executable?(DEBIAN_SENSIBLE_EDITOR)
        return DEBIAN_SENSIBLE_EDITOR
      end
    end
    raise 'Could not determine what editor to use. Please specify.'
  end

  attr_accessor :editor
  def initialize(editor = :vim)
    @editor = editor.to_s
    case @editor
    when 'mate'
      @editor = 'mate -w'
    when 'vim'
      @editor = 'vim -c ":set ft=ruby"'
    when 'mvim'
      @editor = 'mvim -fc ":set ft=ruby"'
    when 'subl'
      @editor = 'subl -w'
    end
  end

  def edit_interactively(rerun, path=nil)
    unless @file
      if(!path.nil? && !path.empty?)
        @file = File.new("#{path}/irb_tempfile.#{Time.now.to_i}.rb", 'w')
      else
        @file = Tempfile.new('irb_tempfile')
      end
    end
    raise "command `#{@editor.split.first}` not found" if(system("which '#{@editor.split.first}'") == false)
    system("#{@editor} #{@file.path}") unless(rerun == true)
    lines = File.read(@file.path).gsub("\r", "\n")
    lines.split("\n").each { |l| Readline::HISTORY << l } unless(rerun == true) # update history
    puts 'Running the following:', '--------------'
    puts lines, '--------------', ''
    Object.class_eval(lines)
    rescue Exception => error
      # puts @file.path
      puts error
  end
end

module InteractiveEditing
  def edit_interactively(editor = InteractiveEditor.sensible_editor, rerun = false)
    unless IRB.conf[:interactive_editors] && IRB.conf[:interactive_editors][editor]
      IRB.conf[:interactive_editors] ||= {}
      IRB.conf[:interactive_editors][editor] = InteractiveEditor.new(editor)
    end
    IRB.conf[:interactive_editors][editor].edit_interactively(rerun, '/Users/tracey/temp/irb')
  end

  def rerun
    raise 'run a command first, such as "vi" or "mvim"' if(IRB.conf[:last_run_command] == nil)
    edit_interactively(IRB.conf[:last_run_command], true)
  end

  def handling_jruby_bug(&block)
    if RUBY_PLATFORM =~ /java/
      puts 'JRuby IRB has a bug which prevents successful IRB vi/emacs editing.'
      puts 'The JRuby team is aware of this and working on it. But it might be unfixable.'
      puts '(http://jira.codehaus.org/browse/JRUBY-2049)'
    else
      yield
    end
  end

  def vi
    IRB.conf[:last_run_command] = :vim
    handling_jruby_bug {edit_interactively(:vim)}
  end

  def mvim
    IRB.conf[:last_run_command] = :mvim
    handling_jruby_bug {edit_interactively(:mvim)}
  end

  def subl
    IRB.conf[:last_run_command] = :subl
    handling_jruby_bug {edit_interactively(:subl)}
  end

  def mate
    IRB.conf[:last_run_command] = :mate
    handling_jruby_bug {edit_interactively(:mate)}
  end

  # TODO: Hardcore Emacs users use emacsclient or gnuclient to open documents in
  # their existing sessions, rather than starting a brand new Emacs process.
  def emacs
    IRB.conf[:last_run_command] = :emacs
    handling_jruby_bug {edit_interactively(:emacs)}
  end
end

# Since we only intend to use this from the IRB command line, I see no reason to
# extend the entire Object class with this module when we can just extend the
# IRB main object.
self.extend InteractiveEditing if Object.const_defined? :IRB


