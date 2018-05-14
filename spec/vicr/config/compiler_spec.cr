require "../../spec_helper"

module Vicr::Config
  describe Compiler do
    context "yaml mapping" do
      it "maps properties" do
        compiler = Compiler.from_yaml({
          executable:  "test",
          args_before: ["1", "2"],
          args_after:  ["3"],
        }.to_yaml)

        compiler.executable.should eq "test"
        compiler.args_before.should eq ["1", "2"]
        compiler.args_after.should eq ["3"]
      end

      it "allows args_before to be nil" do
        compiler = Compiler.from_yaml({
          executable: "test",
          args_after: [""],
        }.to_yaml)
        compiler.args_before.should be nil
      end

      it "allows args_after to be nil" do
        compiler = Compiler.from_yaml({
          executable:  "test",
          args_before: [""],
        }.to_yaml)
        compiler.args_after.should be nil
      end

      it "requires executable" do
        expect_raises(YAML::ParseException) {
          Compiler.from_yaml({args_before: [""]}.to_yaml)
        }
      end
    end
  end
end
