class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.9/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f1d1df932c1523dac860fe08c24a81d4c2fb3586c4e4b0ebdb035d6618a2c6b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.9/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ef9520c5b9b1bcecf4f593fbc0325136624a959c4c9f9e622f45338071e8a5b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.9/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ac0c3355a2aac33c4d2bd64e3271fb31057d0b4a393127aaaf174cb2221ee64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.9/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "71a8bc141096004e28a534b409ab4f176712d7230f0987f386d82458d7152ae8"
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
