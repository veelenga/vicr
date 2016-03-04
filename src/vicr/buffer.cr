require "./service/*"

module Vicr
  module Buffer
    extend self
    include Service

    def load(path : String)
      buffer = File.read path if File.exists? path
      buffer ||= load_http_file path if path.starts_with? "http"
      buffer || raise "Unable to resolve '#{path}'"
    end

    private def load_http_file(path : String)
      raw = Github.raw(path) || Github.gist_raw(path, "Crystal") || CarcIn.raw(path) || path
      resp = HTTP::Client.get raw
      resp.status_code == 200 ? resp.body : nil
    end
  end
end
