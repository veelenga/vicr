require "yaml"
require "../config/*"

module Vicr::Config
  class Settings
    DIR = File.expand_path("~/.vicr", home: true)

    include YAML::Serializable

    property editor : Editor = editor_default
    property compiler : Compiler = compiler_default

    def run_file
      DIR + "/run.cr"
    end

    def self.load
      settings = File.exists?(settings_filepath) ? File.read(settings_filepath) : "{}"
      Settings.from_yaml settings
    end

    def self.settings_filepath
      DIR + "/init.yaml"
    end

    def self.editor_default
      Editor.from_yaml({executable: "vim"}.to_yaml)
    end

    def self.compiler_default
      Compiler.from_yaml({executable: "crystal", args_before: %w(run --no-debug)}.to_yaml)
    end
  end
end
