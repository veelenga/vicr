require "yaml"

module Vicr::Config
  struct Editor
    YAML.mapping({
      executable: String,
      args:       {type: Array(String), nilable: true},
    })
  end
end
