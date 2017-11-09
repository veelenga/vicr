require "yaml"
require "../config/*"

module Vicr::Config
  class Settings
    DIR = File.expand_path "~/.vicr"

    YAML.mapping(
      run_file: {
        type: String, default: DIR + "/run.cr",
      },
      editor: {
        type: Editor, default: editor_default,
      },
      compiler: {
        type: Compiler, default: compiler_default,
      },
    )

    def self.load
      settings = File.exists?(settings_filepath) ? File.read(settings_filepath) : "{}"
      Settings.from_yaml settings
    end

    def self.settings_filepath
      DIR + "/init.yml"
    end

    private def editor_default
      Editor.from_yaml({executable: "vim"}.to_yaml)
    end

    private def compiler_default
      Compiler.from_yaml({executable: "crystal", args_before: %w(run --no-debug)}.to_yaml)
    end
  end
end
