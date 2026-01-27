class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.1/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "fa50bab3bfd0b8888b8a2cb4f18365c1da4855ffdf5dc51ac310f92f7f5b7fae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.1/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "7c24f88d61f4e6bbb611abd9170b762b7ce15c8c16b24e17f34464538325c9bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.1/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "591b1127d1294899b85e393ed2fee2f8bbd7cd84cf3b681ca24a4dd51778f4a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.1/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fffd413d9adf29ac9459266b79ab299967051528acdb6336e0a7adff6c9ac11"
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
