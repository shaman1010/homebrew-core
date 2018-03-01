require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.7.2.tgz"
  sha256 "51df9e82e8068dfbcb028c27202454f77da183b37eec9cb0eb9a61191d2c142b"

  bottle do
    sha256 "12026623057984d1bc6a04ede7292a4f58cee93c9b7e10d36d7c6d895b62d85a" => :high_sierra
    sha256 "3e811c4147320e00bab3ad8a2e89ab7ab02bb93b6d89db85d30531968bd56fd8" => :sierra
    sha256 "ea73e90ece02d9aef702cc41874b456ea154e822cb3d212b11676fcdc455ab7a" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
