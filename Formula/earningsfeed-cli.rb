class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.8/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4065573d081617665479673fc7377ee45cf7bf745d21639da2dd104cf7c2c811"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.8/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ebd86cc852649470aeab2927705fcbfcba023d4c32314b9d52b554999c56f8d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.8/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7528b25b4430588534caff8ebb91791d0ea9df0fed3bfb4d51d8f3a58f2c2229"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.8/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9abd20a53d06e4deae44715f4d18514192294522bfa7f40c852f4f60ef27ffc4"
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
