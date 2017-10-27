class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v24.tar.gz"
  sha256 "511dc45d12962af9c31c3068ce6bca4b832a6263946b27befea49a48cf019110"
  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "61d85801587ee6d3158407ae65cd0bece03a08b2e8f99d9e7568b7ddb3b2daee" => :high_sierra
    sha256 "606057791d4785165f78ae964bfa990b005d5f0cc3e51f19f64438c29b2670f5" => :sierra
    sha256 "16a9ac152429a736db62dc0a2ac34f1b4d70c11b3de10f856bece78acf20a9a1" => :el_capitan
    sha256 "de711fb6eb1c6ac0093ad182dd820c9debdb5d08ce03430de6462fbf9568c5e3" => :yosemite
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "giflib"
  depends_on "libexif"

  def install
    system "make", "config.h"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
