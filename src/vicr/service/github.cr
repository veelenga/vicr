require "http/client"
require "json"
require "levenshtein"

module Vicr::Service::Github
  extend self

  def raw(path : String)
    if md = path.match /github.com\/(.*)\/(.*)\/blob\/(.*)\/(.*)/
      user, repo, branch, file = md[1], md[2], md[3], md[4]
      "https://raw.githubusercontent.com/#{user}/#{repo}/#{branch}/#{file}"
    end
  end

  def gist_raw(path : String, language = nil : String)
    path, filename = path.split("#file-") + [nil]
    if path && (md = path.match /gist.github.com\/.*\/(.*)/)
      files = gist_files md[1]
      if filename
        files.map { |file| {url: file[:raw_url], dist: Levenshtein.distance file[:filename], filename} }
             .sort_by(&.[:dist].to_i)
             .first[:url] as String
      else
        (files.select { |file| file[:language] == language }.first? || files.first)[:raw_url]
      end
    end
  end

  private def gist(id : String)
    resp = HTTP::Client.get "https://api.github.com/gists/" + id
    return JSON.parse(resp.body) if resp.status_code == 200
    raise ArgumentError.new "Gist with id '#{id}' not found"
  end

  private def gist_files(id : String)
    gist_files = [] of Hash(Symbol, String)
    gist(id)["files"].each do |file, value|
      gist_files << {
        filename: file.to_s,
        language: value["language"].to_s,
        raw_url:  value["raw_url"].to_s,
      }
    end
    gist_files
  end
end
