require "option_parser"
require "http/client"
require "json"

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
        parser.on("-c", "--clear", "Clear current buffer") { |c| clear = true }
        parser.on("-d", "--debug", "Debug output") { debug = true }
        parser.on("-v", "--version", "Show version") { puts VERSION; exit }
        parser.on("-h", "--help", "Show this help") { puts parser; exit }
        parser.unknown_args do |args, after_dash|
          path ||= args.first if args.size == 1
        end
      end

      opts = {} of Symbol => String
      opts[:buffer] = load_file path.not_nil! if path
      opts[:buffer] = "" if clear

      Runner.new(opts).start
    rescue e
      e.inspect_with_backtrace STDERR if debug
      puts e.message.colorize :red
    end

    private def load_file(path : String)
      buffer = File.read path if File.exists? path
      buffer ||= load_http_file path if path.starts_with? "http"
      buffer ? buffer : raise "Unable to load file '#{path}'"
    end

    private def load_http_file(path : String)
      raw = Github.raw(path) || Github.gist_raw(path, "Crystal") || path
      resp = HTTP::Client.get raw
      resp.status_code == 200 ? resp.body : nil
    end
  end
end
