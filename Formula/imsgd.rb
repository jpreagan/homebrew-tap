class Imsgd < Formula
  desc "macOS helper for exposing imsgkit message data"
  homepage "https://github.com/jpreagan/imsgkit"
  version "0.2.0"
  license "MIT"
  depends_on "sqlite-rsync"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.2.0/imsgd_0.2.0_darwin_amd64.tar.gz"
      sha256 "c3b2d0d53ccbf82a4d8a4e0386a373f7ae7d7d4529c1de87f6a8e93c9ae774e5"

      def install
        bin.install "imsgd"
      end
    end

    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.2.0/imsgd_0.2.0_darwin_arm64.tar.gz"
      sha256 "94b8a38e68afd09d1330332fb43e2bd4b3d091415d4dcf11b97761b8fa8bbba1"

      def install
        bin.install "imsgd"
      end
    end
  end

  service do
    run [opt_bin/"imsgd", "sync"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/imsgd.log"
    error_log_path var/"log/imsgd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imsgd version")
  end
end
