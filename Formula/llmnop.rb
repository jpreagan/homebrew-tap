class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.12.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "24c6e60bf7a48f55f6a369758016ec9aa2cb3cd4ed02d136ce45508b3a4950b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.12.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "48bff00e43e2fbe71a7f4f1b01d837d6662dff869987de373b5a6d484dac7ca5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.12.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5924f14d168e2dc74e6608441c901b277ed8f6843758821875202bab6e6ebfa0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.12.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dce9558255b0f7d6540d1e715c0c63ee74749619b270eeecd1d54bc7228a00ad"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "llmnop"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "llmnop"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "llmnop"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "llmnop"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
