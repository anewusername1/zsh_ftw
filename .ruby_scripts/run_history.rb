# Adds shell-style history display and replay to irb.  The magic happens in
# the h, h!, and hw methods.
#
# == Authors
#
# * Ben Bleything <ben@bleything.net>
#
# == Copyright
#
# Copyright (c) 2007 Ben Bleything
#
# This code released under the terms of the BSD license.
#
# == Version
#
#  $Id: history.rb 50 2007-07-30 18:55:09Z ben $
#


# Lists the last how_many lines of history (defaults to 50).  Aliased to h.
def history( how_many = 50 )
    history_size = Readline::HISTORY.size

    # no lines, get out of here
    puts "No history" and return if history_size == 0

    start_index = 0

    # not enough lines, only show what we have
    if history_size <= how_many
        how_many  = history_size - 1
        end_index = how_many
    else
        end_index = history_size - 1 # -1 to adjust for array offset
        start_index = end_index - how_many 
    end

    start_index.upto( end_index ) {|i| print_line i}
    nil
end
alias :h  :history


# replay lines from history.  Aliased to h!
#
# h! by itself will replay the most recent line.  You can also pass in a
# range, array, or any mixture of the three.
#
# We subtract 2 from HISTORY.size because -1 is the command we just issued.
def history_do( *lines )
    lines = [Readline::HISTORY.size - 2] if lines.empty?

    to_eval = get_lines( lines )

    to_eval.each {|l| Readline::HISTORY << l}

    IRB.CurrentContext.workspace.evaluate self, to_eval.join(';')
end
alias :h! :history_do


# writes history to a named file.  This is useful if you want to show somebody
# something you did in irb, or for rapid prototyping.  Aliased to hw.
#
# Uses similar calling semantics to h!, that is, you can pass in fixnums,
# ranges, arrays, or any combination thereof.
def history_write( filename, *lines )
    File.open( filename, 'w' ) do |f|
        get_lines( lines ).each do |l|
            f.puts l
        end
    end
end
alias :hw :history_write


private

# simple getter to fetch from Readline
def get_line(line_number)
    Readline::HISTORY[line_number]
end


# the code what powers the line fetcherating.  Accepts an array and iterates
# over each entry, fetching that line from the history and placing it into a
# temporary array which is ultimately returned.
def get_lines( lines )
    out = []

    lines.each do |line|
        case line
        when Fixnum
            out << get_line( line )
        when Range
            line.to_a.each do |l|
                out << get_line( l )
            end
        end
    end

    return out
end


# prints out the contents of the line from history, along with a line number,
# if desired.
def print_line(line_number, show_line_numbers = true)
    print "[%04d] " % line_number if show_line_numbers
    puts get_line(line_number)
end

