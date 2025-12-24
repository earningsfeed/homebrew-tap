class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.0/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d92e5805d1cac70455eaa68206de557a79e3b57a120139631f61723ac4395647"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.0/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bc2a9d94667b0f6494a135ed101e523726380b68539be32dc22811d0f76fcd45"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.0/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "351d0abedc7f42ee354f6686a89d87177f7023bd503beaa6ebc61944dcef3cc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.0/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a07e712766ed4de58edacef7f718d07995f5c9d8a23d58755955002771d26f4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "earningsfeed"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "earningsfeed"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "earningsfeed"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "earningsfeed"
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
