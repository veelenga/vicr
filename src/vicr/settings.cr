require "yaml"

module Vicr
  class Settings
    DIR = File.expand_path "~/.vicr"

    YAML.mapping({
      run_file: String,
      editor:  Editor,
    })

    struct Editor
      YAML.mapping({
        executable:  String,
        args: {type: Array(String), nilable: true},
      })
    end

    def self.load
      create unless File.exists? settings_filepath
      Settings.from_yaml File.read settings_filepath
    end

    def self.create
      Dir.mkdir_p DIR unless Dir.exists? DIR

      File.new(settings_filepath, "w")
      File.open(settings_filepath, "w") do |f|
        {
          run_file: DIR + "/run.cr",
          editor:  {executable: "vim"},
        }.to_yaml f
      end
    end

    def self.settings_filepath
      DIR + "/init.yml"
    end
  end
end
