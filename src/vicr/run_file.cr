module Vicr
  class RunFile
    getter! :path

    def initialize(path, buffer = nil)
      @path = File.expand_path path
      buffer ? create_new buffer : File.exists?(path) || create_new
    end

    def delete
      File.delete @path if File.exists? @path
    end

    def create_new(buffer = nil : (Nil | String))
      buffer ? File.write(@path, buffer) : File.new(@path, "w")
    end

    def lines
      File.read_lines @path
    end
  end
end
