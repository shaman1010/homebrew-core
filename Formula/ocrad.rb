class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftpmirror.gnu.org/ocrad/ocrad-0.26.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.26.tar.lz"
  sha256 "c383d37869baa0990d38d38836d4d567e9e2862aa0cd704868b62dafeac18e3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "035cc08529d27d2469c77adbe414ed30f4ca674efcb268c58a47d0d270b721fa" => :sierra
    sha256 "9acb5576ee58fe3d968649659c9f374277d145a2050ce62ecd70d6d675645efb" => :el_capitan
    sha256 "99dba4fcc35dcea80dcf70e783832a57578f36406aa9a465398cf511ff2bae6e" => :yosemite
    sha256 "ee28a84a3c13a281f601f92920201a00af54509201f62ffb9d84d0e554001c7d" => :mavericks
    sha256 "2e338636210625c15a91389b2d53b7464c05c38017d0fba37076e100794668e1" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
