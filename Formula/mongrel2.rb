class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.12.0/mongrel2-v1.12.0.tar.bz2"
  sha256 "054b87d94f5c2fb5311ad7979276ce12684f72bff476fdf943e1c485723e9f3c"
  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "67696f654ab1d878ac7c2a3fa254b0ee86c1d444578045997a971ca44189b2fe" => :high_sierra
    sha256 "293b0edc8bcc0b7e3a97748a6accbc5000916ed145fd467aeb809303438a207a" => :sierra
    sha256 "7a6880cbc814b084a3ac91e379b7a720438951e31a18119c232f976fded229c3" => :el_capitan
    sha256 "0b2926fe3d79ab934e95f0e5c067e8bb23b6900b99255482defee9388a0dee07" => :yosemite
    sha256 "dd07092a2384c243fcd8c54ed67f2a728f3da698276540fc1c9b201eb3c5cbbb" => :mavericks
  end

  depends_on "mbedtls"
  depends_on "zeromq"

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.deparallelize

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end
