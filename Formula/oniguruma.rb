class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.3/onig-6.1.3.tar.gz"
  sha256 "480c850cd7c7f2fcaad0942b4a488e2af01fbb8e65375d34908f558b432725cf"

  bottle do
    cellar :any
    sha256 "c55bd8c274b1dae813839190a01ad7ab53edc28c93a8c066dadfaa755b3d29f5" => :sierra
    sha256 "7bf28f6bca4a8ec2cd6f3450c26a29e917db8ceddde456338a11acbdd08ae1bf" => :el_capitan
    sha256 "5c061ca46832304e3a5ec0c2edd18a57ab001a43d3f62a074733e5a08abdd7db" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
