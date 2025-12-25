class EarningsfeedCli < Formula
  desc "CLI for the EarningsFeed API - SEC filings, insider transactions, and institutional holdings"
  homepage "https://earningsfeed.com"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.7/earningsfeed-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a56c4b0d77725bf6f85b292dacbe7979b441577e4d9ffaa1398cc62e4743d0b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.7/earningsfeed-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3bd4516849b64226a7c87094bec86f76c066700f288d5dab8a5cdb9d44cd852a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.7/earningsfeed-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b51bf5599c5b1147639d0dcb28e065cf4c9eaa71230d57c260ed60a6e1414431"
    end
    if Hardware::CPU.intel?
      url "https://github.com/earningsfeed/earningsfeed-cli/releases/download/v0.1.7/earningsfeed-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f098d9cb39f280990395b4fb6056117346c13cfc340bb6e042b158a7fe0dcce0"
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
