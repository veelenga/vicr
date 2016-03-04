require "../../spec_helper"

module Vicr::Service
  describe CarcIn do
    describe ".raw" do
      it "returns path to raw file on carc.in" do
        CarcIn.raw("https://carc.in/#/r/rlc")
              .should eq "https://carc.in/runs/rlc.cr"
      end

      it "returns nil if this is not carc.in path" do
        CarcIn.raw("https://github.com/test/test.cr").should be_nil
      end
    end
  end
end
