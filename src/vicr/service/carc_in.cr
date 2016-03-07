module Vicr::Service::CarcIn
  extend self

  def raw(path : String)
    if md = path.match /(carc\.in|play\.crystal-lang\.org)\/.*\/.*\/(.*)/
      "https://carc.in/runs/#{md[2]}.cr"
    end
  end
end
