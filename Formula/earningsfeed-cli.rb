class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.5/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b0a1fb7d295c8dadd11afcedf6ef5d85d9db69b792acb875a6b131603dd688a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.5/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b0d8dce25587f93e0785164c73c3a31dc9b9f5107400b2224272ad796cafbc5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.5/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd802245311b024f4c71b4242c420990b8ba0a5a9f6eb0bb524d6600dd5ddce8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.5/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52c65533dfd6d5a807ebb43bcad0b290507e8f3fd81e079a8e0d853503cf1041"
    end
  end
  license "MIT"

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
    bin.install "earningsfeed" if OS.mac? && Hardware::CPU.arm?
    bin.install "earningsfeed" if OS.mac? && Hardware::CPU.intel?
    bin.install "earningsfeed" if OS.linux? && Hardware::CPU.arm?
    bin.install "earningsfeed" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
