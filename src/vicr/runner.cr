require "colorize"

module Vicr
  class Runner
    def initialize(@editor = "vim")
      @cr_file = create_cr_file
    end

    def start
      loop do
        system(@editor, [@cr_file.path])
        system("crystal", ["run", @cr_file.path])

        execute_action read_action
      end
    end

    def execute_action(action)
      case action
      when :quit
        exit
      when :new
        delete_cr_file; @cr_file = create_cr_file
      when :print
        print_cr_file_with_lines; execute_action read_action
      when :edit
        # do nothing
      else
        raise ArgumentError.new "Unknown action: #{action}"
      end
    end

    def read_action
      puts "(e)dit (n)ew (p)rint (q)uit".colorize(:yellow)
      print ">> ".colorize(:red)
      action = STDIN.raw do |io|
        input = io.gets 1

        case input
        when "n"
          :new
        when "p"
          :print
        when "\e", "\u{3}", "q", "Q"
          :quit
        else
          :edit
        end
      end
      puts action.colorize(:green); return action
    end

    private def print_cr_file_with_lines
      lines = File.read_lines(@cr_file.path)
      lines.each_with_index do |line, index|
        print "#{index + 1} ".colorize(:magenta)
        puts line
      end
      puts
    end

    private def delete_cr_file
      File.delete @cr_file.path if File.exists? @cr_file.path
    end

    private def create_cr_file
      File.new CR_FILE_PATH, "w"
    end
  end
end
