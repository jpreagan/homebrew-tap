class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.10.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "58b30841e5ee23a4b35e47665bb9dae7b1aebc764bae8bc7f89d4c49879a4171"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.10.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "a8ce3bb55984b12e36b3d262c2c7489d9d0f57cda6ec6ca1684c15d5454fb4ff"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.10.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5cdde6e086e5b4a35ad7129ccbc8886df079eea047a5133be51a5119136f16a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.10.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "164d56d30e1be4ff47a34dae42a7374e4aa87fd8c46af8f82b291aac48dd1c55"
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
    bin.install "llmnop" if OS.mac? && Hardware::CPU.arm?
    bin.install "llmnop" if OS.mac? && Hardware::CPU.intel?
    bin.install "llmnop" if OS.linux? && Hardware::CPU.arm?
    bin.install "llmnop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
