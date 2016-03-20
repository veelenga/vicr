require "yaml"

module Vicr::Config
  class Settings
    DIR = File.expand_path "~/.vicr"

    YAML.mapping({
      run_file: {
        type: String, default: DIR + "/run.cr",
      },
      editor: {
        type: Editor, default: Editor.from_yaml({
        executalbe: "vim",
      }.to_yaml),
      },
      compiler: {
        type: Compiler, default: Compiler.from_yaml({
        executable:  "crystal",
        args_before: ["run", "--release"],
      }.to_yaml),
      },
    })

    def self.load
      settings = File.exists?(settings_filepath) ? File.read(settings_filepath) : ""
      Settings.from_yaml settings
    end

    def self.settings_filepath
      DIR + "/init.yml"
    end
  end
end
