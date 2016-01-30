require "option_parser"
require "http/client"
require "json"

module Vicr
  class Cli
    def self.run(args = ARGV)
      Cli.new.run(args)
    end

    def run(args)
      opts = {} of Symbol => String

      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: vicr [arguments]"
        parser.on("-f PATH", "--file PATH", "File to load") do |path|
          opts[:buffer] = load_file path
        end
        parser.on("-v", "--version", "Show version") { puts VERSION; exit }
        parser.on("-h", "--help", "Show this help") { puts parser; exit }
      end

      Runner.new(opts).start
    rescue e
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
