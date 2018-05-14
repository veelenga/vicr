require "../../spec_helper"

module Vicr::Config
  describe Editor do
    context "yaml mapping" do
      it "maps properties" do
        editor = Editor.from_yaml({
          executable: "test",
          args:       ["1", "2"],
        }.to_yaml)
        editor.executable.should eq "test"
        editor.args.should eq ["1", "2"]
      end

      it "requires executable" do
        expect_raises(YAML::ParseException) {
          Editor.from_yaml({args: [""]}.to_yaml)
        }
      end

      it "allows args to be nil" do
        editor = Editor.from_yaml({executable: "test"}.to_yaml)
        editor.args.should be_nil
      end
    end
  end
end
