class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.6/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "445f71f0d13c0d40f50b4cd1f4c1cfbc7ed4415ce57d03ae6d6954c10b714315"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.6/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2aa1e0b89c8572781f15f9c0ebc3ab1773e1fcf8a81b1689a5a429c628662a7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.6/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aaa75892b997bdad01dd76ec1ff719a530158e847b2a58891ec9c942d72f66a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.6/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89b3c3da42bb91595e374ce66aa6ca0321d0fdb7c7a72e8a27debfe303d6fb76"
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
