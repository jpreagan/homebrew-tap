class Imsgd < Formula
  desc "macOS helper for exposing imsgkit message data"
  homepage "https://github.com/jpreagan/imsgkit"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.1.0/imsgd_0.1.0_darwin_amd64.tar.gz"
      sha256 "2aa03ca76e86ea439384f1d7e26a759c937c14536f4d888dd1645c69851bde32"

      def install
        bin.install "imsgd"
      end
    end

    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.1.0/imsgd_0.1.0_darwin_arm64.tar.gz"
      sha256 "e69877faf9eb94fbf6b2f21a19f7f4e8edbe32234682c2ea9d8efba274b0b4f6"

      def install
        bin.install "imsgd"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imsgd version")
  end
end
