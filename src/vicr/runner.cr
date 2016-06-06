require "colorize"
require "./config/*"

module Vicr
  class Runner
    include Config

    @editor : Editor
    @compiler : Compiler

    def initialize(opts)
      settings = Settings.load

      @editor = settings.editor
      @compiler = settings.compiler
      @run_file = RunFile.new settings.run_file, opts[:buffer]?

      @editor_args = Array(String).new
      @editor_args.concat @editor.args.not_nil! if @editor.args
      @editor_args << @run_file.path

      @compiler_args = Array(String).new
      @compiler_args.concat @compiler.args_before.not_nil! if @compiler.args_before
      @compiler_args << @run_file.path
      @compiler_args.concat @compiler.args_after.not_nil! if @compiler.args_after
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
      when :quit
        exit
      end
    end

    def next_action
      puts "(r)un (e)dit (n)ew (q)uit".colorize :yellow
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

    def edit
      system(@editor.executable, @editor_args) ||
        raise "Unable to edit '#{@run_file.path}' using '#{@editor.executable}'"
    end

    def run
      system(@compiler.executable, @compiler_args)
    end
  end
end
