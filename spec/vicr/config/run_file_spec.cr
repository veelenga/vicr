require "../../spec_helper"
require "tempfile"

def test_run_file
  tempfile = Tempfile.new "run_file"
  run_file = Vicr::RunFile.new tempfile.path
  begin
    yield run_file
  rescue e
    tempfile.close
    raise e
  end
end

module Vicr
  describe RunFile do
    describe "#path" do
      it "returns path to file" do
        test_run_file do |run_file|
          run_file.path.should_not be_nil
        end
      end
    end

    describe "#delete" do
      it "removes file" do
        test_run_file do |run_file|
          File.exists?(run_file.path).should be_true
          run_file.delete
          File.exists?(run_file.path).should be_false
        end
      end
    end

    describe "#create_new" do
      it "creates new file" do
        test_run_file do |run_file|
          run_file.delete
          File.exists?(run_file.path).should be_false
          run_file.create_new
          File.exists?(run_file.path).should be_true
        end
      end
    end

    describe "#write" do
      it "writes into file" do
        test_run_file do |run_file|
          run_file.write("test")
          run_file.lines.should eq ["test"]
        end
      end
    end

    describe "#lines" do
      it "returns empty string when file is empty" do
        test_run_file do |run_file|
          run_file.lines.should eq [] of String
        end
      end
    end
  end
end
