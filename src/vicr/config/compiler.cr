require "yaml"

module Vicr::Config
  struct Compiler
    YAML.mapping({
      executable:  String,
      args_before: {type: Array(String), nilable: true},
      args_after:  {type: Array(String), nilable: true},
    })
  end
end
