require "yaml"

module Vicr::Config
  struct Compiler
    include YAML::Serializable

    property executable : String
    property args_before : Array(String)?
    property args_after : Array(String)?
  end
end
