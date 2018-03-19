class Termbox < Formula
  desc "Library for writing text-based user interfaces"
  homepage "https://code.google.com/p/termbox/"
  url "https://github.com/nsf/termbox/archive/v1.1.2.tar.gz"
  sha256 "61c9940b42b3ac44bf0cba67eacba75e3c02088b8c695149528c77def04d69b1"

  head "https://github.com/nsf/termbox.git"

  bottle do
    cellar :any
    sha256 "bee4c92ab6ab8183ff2c58f040dbb770a8857f683ec43936ae2c4e40c47c7dd6" => :high_sierra
    sha256 "a8fc298b60c21807660df3aa3a16f8e51c9cf9da9955132374c85f69edec3713" => :sierra
    sha256 "b5f1039afbbcbcb37f30fda97b0bebb6e4fa774c6ada2abc67cc487661a5dd5c" => :el_capitan
    sha256 "95d8a2fd081cccba637b292374670510e2822f55cd1bcb0eb7ce279ceb26f03f" => :yosemite
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <termbox.h>
      int main() {
        // we can't test other functions because the CI test runs in a
        // non-interactive shell
        tb_set_clear_attributes(42, 42);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltermbox", "-o", "test"
    system "./test"
  end
end
