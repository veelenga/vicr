module Vicr
  class RunFile
    getter! :path

    def initialize(path, buffer = nil)
      @path = File.expand_path path
      buffer ? write buffer : File.exists?(@path) || create_new
    end

    def delete
      File.delete @path if File.exists? @path
    end

    def create_new
      File.new @path, "w"
    end

    def write(buffer : String)
      File.write @path, buffer
    end

    def lines
      File.read_lines @path
    end
  end
end
