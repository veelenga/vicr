module Vicr
  class RunFile
    getter! :path

    def initialize(@path = path, buffer = nil)
      File.exists?(@path) ? File.new @path, "r" : create_new(buffer)
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
