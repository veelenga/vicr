require "colorize"

module Vicr
  class Runner
    def initialize(opts)
      settings = Settings.load
      @run_file = RunFile.new settings.run_file, opts[:buffer]?
      @editor = settings.editor
      @compiler = settings.compiler
    end

    def start
      edit; run
      loop { act next_action }
    end

    def act(action)
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
      end
    end

    def next_action
      puts "(r)un (e)dit (n)ew (p)rint (q)uit".colorize :yellow
      print ">> ".colorize(:red)

      action = :unknown
      while action == :unknown
        action = STDIN.raw do |io|
          case io.gets 1
          when "r", "\r"
            :run
          when "e", " "
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
      end
      puts action.colorize :green
      action
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
      @compiler_args ||= Array(String).new.tap do |args|
        args.concat @compiler.args_before.not_nil! if @compiler.args_before
        args << @run_file.path
        args.concat @compiler.args_after.not_nil! if @compiler.args_after
      end

      system(@compiler.executable, @compiler_args) ||
        raise "Unable to run '#{@run_file.path}' using '#{@compiler.executable}'"
    end
  end
end
