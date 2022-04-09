require "yaml"

module Vicr::Config
  struct Editor
    include YAML::Serializable

    property executable : String
    property args : Array(String)?
  end
end
