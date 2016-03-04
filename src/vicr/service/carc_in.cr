module Vicr::Service::CarcIn
  extend self

  def raw(path : String)
    if md = path.match /carc.in\/.*\/.*\/(.*)/
      "https://carc.in/runs/#{md[1]}.cr"
    end
  end
end
