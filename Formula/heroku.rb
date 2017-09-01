require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.11.tgz"
  sha256 "5bf273c0b3042be4d9e37d9605a277f4f343c4b47bb9fc26199b2374a7bcb704"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34347e909a8ae9f75c3ce5d14bdc56605bc64739efb187eb43ef3a007497b6c0" => :sierra
    sha256 "5dd931999f290fcace884e1daeda1fc7f652a31dd1bb624411ccb4ca14a340a1" => :el_capitan
    sha256 "09ac15a91644633ece7e776602bfd5a63b987aa8befc38c3cb242fa348f3e099" => :yosemite
  end

  depends_on "node"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
