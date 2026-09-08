class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.11.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "60d5ef664faf6a2d0934450ae8e1a673395b0bd5d906d6376fe1efa1e2bd09df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.11.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "77cf6d3e9b93692239f257276bbc81d3833c4d18875e778f89184220c734342a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.11.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8472850ef8eea70aceeade53fa8af111a00fc2ec930e187d19b9d89d3f487252"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.11.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2eefefb10d9f8f5669653917b49bbc220f80b30f2534352dbb1dd4f23b678b36"
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
