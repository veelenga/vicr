require "option_parser"
require "http/client"

module Vicr
  class Cli
    def self.run(args = ARGV)
      Cli.new.run(args)
    end

    def run(args)
      opts = {} of Symbol => String

      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: vicr [arguments]"
        parser.on("-h", "--help", "Show this help") { puts parser; exit }
        parser.on("-v", "--version", "Show version") { puts VERSION; exit }
        parser.on("-f PATH", "--file PATH", "File to load") do |path|
          buffer = load_file path
          opts[:buffer] = buffer if buffer
        end
      end

      Runner.new(opts).start
    rescue e
      puts e.message.colorize :red
    end

    private def load_file(path)
      return File.read path if File.exists? path
      return load_http_file path if path.starts_with? "http"
      raise "Unable to load file '#{path}'"
    end

    private def load_http_file(http_path)
       resp = HTTP::Client.get http_path
       resp.body if resp.status_code == 200
    end
  end
end
