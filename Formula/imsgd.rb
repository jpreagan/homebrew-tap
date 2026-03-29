class Imsgd < Formula
  desc "macOS helper for exposing imsgkit message data"
  homepage "https://github.com/jpreagan/imsgkit"
  version "0.3.0"
  license "MIT"
  depends_on "sqlite-rsync"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.3.0/imsgd_0.3.0_darwin_amd64.tar.gz"
      sha256 "fc20d6b19da7d85b9862c6353e41674b3b0617f438d17c7361cd56ef7100cb2b"

      def install
        bin.install "imsgd"
      end
    end

    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/imsgkit/releases/download/imsgd%2Fv0.3.0/imsgd_0.3.0_darwin_arm64.tar.gz"
      sha256 "7ac26e44a5ea8936374eeb13c7daa45f801351218f78dde86f5417b277cf8548"

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
