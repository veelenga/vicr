require "../../spec_helper"

module Vicr::Service
  describe Github do
    describe ".raw" do
      it "returns path to raw file on github" do
        Github.raw("https://github.com/user/repo/blob/master/file.cr")
              .should eq "https://raw.githubusercontent.com/user/repo/master/file.cr"
      end

      it "returns nil if this is not github path" do
        Github.raw("https://example.com/user/repo/blob/master/file.cr")
              .should eq nil
      end
    end
  end
end
