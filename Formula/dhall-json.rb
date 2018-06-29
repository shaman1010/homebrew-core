require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.1/dhall-json-1.2.1.tar.gz"
  sha256 "999cd25e03d9c859a7df53b535ca59a1a2cdc1b728162c87d23f3b08fc45c87d"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74e2dd9c2f0bdff9e55d1c86899eae20fc50b9954c95bce8e642cdfd7bffa849" => :high_sierra
    sha256 "6b7244634241561a14db50d53813a8425ec7a750a772c00686cd4064d7357e60" => :sierra
    sha256 "207ee57bd4cf4c2bd9f5d0eeeb45dc24c59d509c0287711bd17f5a6b995b404e" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
