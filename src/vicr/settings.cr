require "yaml"

module Vicr
  class Settings
    PATH_TO_SETTINGS = File.expand_path "~/.vicr/vicr.yml"

    YAML.mapping({
      cr_file: String,
      editor:  Editor,
    })

    struct Editor
      YAML.mapping({
        executable:  String,
        args_before: {type: Array(String), nilable: true},
        args_after:  {type: Array(String), nilable: true},
      })
    end

    def self.load
      create unless File.exists? PATH_TO_SETTINGS
      Settings.from_yaml File.read PATH_TO_SETTINGS
    end

    def self.create
      File.open(PATH_TO_SETTINGS, "w") do |f|
        {
          cr_file: File.expand_path("~/.vicr/cr_file.cr"),
          editor:  {executable: "vim"},
        }.to_yaml f
      end
    end
  end
end
