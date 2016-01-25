require "colorize"

module Vicr
  class Runner
    def initialize
      settings = Settings.load
      @run_file = RunFile.new settings.run_file
      @editor = settings.editor
    end

    def start
      edit; run
      loop { next_action read_action }
    rescue e
      puts e.message.colorize :red
      exit 1
    end

    def next_action(action)
      case action
      when :run
        run
      when :edit
        edit; run
      when :new
        @run_file.create_new
        edit; run
      when :print
        print
      when :quit
        exit
      else
        # ignore
      end
    end

    def read_action
      puts "(r)un (e)dit (n)ew (p)rint (q)uit".colorize :yellow
      print ">> ".colorize(:red)
      action = STDIN.raw do |io|
        input = io.gets 1

        case input
        when "r"
          :run
        when "e", " ", "\r"
          :edit
        when "n"
          :new
        when "p"
          :print
        when "\e", "\u{3}", "\u{4}", "q", "Q"
          :quit
        else
          :unknown
        end
      end
      puts action.colorize :green; return action
    end

    def print
      @run_file.lines.each_with_index do |line, index|
        puts "#{(index + 1).colorize :magenta} #{line}"
      end
      puts
    end

    def edit
      @editor_args ||= Array(String).new.tap do |args|
        args.concat @editor.args.not_nil! if @editor.args
        args << @run_file.path
      end

      system(@editor.executable, @editor_args) ||
        raise "Unable to edit '#{@run_file.path}' using '#{@editor.executable}'"
    end

    def run
      @crystal_args ||= ["run", @run_file.path]
      system "crystal", @crystal_args
    end
  end
end
