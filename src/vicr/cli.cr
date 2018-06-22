require "option_parser"
require "http/client"
require "json"
require "./service/*"

module Vicr
  class Cli
    def self.run(args = ARGV)
      Cli.new.run(args)
    end

    def run(args)
      path, debug, clear = nil, false, false

      OptionParser.parse(args) do |parser|
        parser.banner = <<-USAGE
        Usage: vicr [switches] [arguments] or
               vicr [path to file to load]
        USAGE
        parser.on("-f PATH", "--file PATH", "File to load") { |p| path = p }
        parser.on("-c", "--clear", "Clear current buffer") { clear = true }
        parser.on("-d", "--debug", "Debug output") { debug = true }
        parser.on("-v", "--version", "Show version") { puts VERSION; exit }
        parser.on("-h", "--help", "Show this help") { puts parser; exit }
        parser.unknown_args do |unknown_args|
          path ||= unknown_args.first if unknown_args.size == 1
        end
      end

      opts = {} of Symbol => String
      opts[:buffer] = Buffer.load(path.not_nil!) if path
      opts[:buffer] = "" if clear

      Runner.new(opts).start
    rescue e
      e.inspect_with_backtrace STDERR if debug
      puts e.message.colorize :red
    end
  end
end
