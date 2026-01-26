class Llmnop < Formula
  desc "A command-line tool for benchmarking the performance of LLM inference endpoints."
  homepage "https://github.com/jpreagan/llmnop"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.0/llmnop-aarch64-apple-darwin.tar.xz"
      sha256 "d5166164a1f1c5388f577ce60f561a09fd5d99fc063a9b8426760dba8abdaa27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.0/llmnop-x86_64-apple-darwin.tar.xz"
      sha256 "e5e0871efbafb66e7a5284cd3fa42eee0ed3ebf25293202b05dee82c40e98a81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.0/llmnop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d84e7299ee9cf664c1ad0fafb32d9a565a6e2d87bb08f430c799a8dc4a15472"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jpreagan/llmnop/releases/download/v0.7.0/llmnop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0193f8294c8960cf9108f1c8ff8488438e2497f8db702aef1a9e766fc999c80"
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
