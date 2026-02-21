class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.9.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "a4a0cdcf73360c2d7f80e4e21eb034d24bfff248d6ceb8f3d13a6937da446729"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.9.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "179f0a9217f25ad2a6fc82b2becf5a22a8c0a86052e5caf56d853c1d196e57d4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.9.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "782168bd43e37df267b6f80a3f4a86bcc7b0ab56723d517053e328995424feb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.9.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41a23ff6fa92bd08926fb7430c754a55e078f75af407ae6e521c05f90fdbc6bf"
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
