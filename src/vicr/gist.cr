require "http/client"
require "json"

module Vicr
  class Gist
    API_PATH = "https://api.github.com/gists/"

    def self.get(id : String)
      resp = HTTP::Client.get API_PATH + id
      if resp.status_code == 200
        JSON.parse(resp.body)
      else
        raise ArgumentError.new "Gist with id '#{id}' not found"
      end
    end

    def self.get_file(id : String, filename : String)
      resp = Gist.get(id)
      begin
        resp["files"].as_h[filename] as Hash(String, JSON::Type)
      rescue
        raise ArgumentError.new "File '#{filename}' not found for gist '#{id}'"
      end
    end
  end
end
