class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.6.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "a4474043ebeb08535b3bef7f0cad5d531da089a3fe903852ab823f10709704c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.6.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "177c1ee10d179f4607cee98f59dd0fa4c5a113bac995dde58150bd1ee8a5f0df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.6.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "046e71a50cbfede1a3d2c7cdd15c93c1842bf90e04bf7e2dd7c3a9f5f5b8aa84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.6.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea52b2a6c331af39f8c7caea3d50e93d04c04ac1fc01082bf66b46194df1d5e8"
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
