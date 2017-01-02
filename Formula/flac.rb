class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "http://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz"
  mirror "https://downloads.sourceforge.net/project/flac/flac-src/flac-1.3.2.tar.xz"
  sha256 "91cfc3ed61dc40f47f050a109b08610667d73477af6ef36dcad31c31a4a8d53f"

  bottle do
    cellar :any
    sha256 "8bab1666b01a12a20bd788397963ba4d02a5d4c855813cbed754782f7dd2d32d" => :sierra
    sha256 "ba87fb6e7919f334b04745d5c075f5ae12a5374b3b7edd0514cc62d9f8ad28c8" => :el_capitan
    sha256 "b5c4e452287e0aaf9355fd8f13849450edceca1b63d2401a0aa42d9c3344c143" => :yosemite
    sha256 "a9caf29aa44208d98d4f885ba78e6d6d3bf56725748007a1cb9e0339631e807e" => :mavericks
    sha256 "738f8ba2670b9eff4c0ff794813a86841934f6791ce393d9833f1cef56cb8e25" => :mountain_lion
  end

  head do
    url "https://git.xiph.org/flac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional

  fails_with :clang do
    build 500
    cause "Undefined symbols ___cpuid and ___cpuid_count"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-static
    ]

    args << "--disable-asm-optimizations" if build.universal? || Hardware::CPU.is_32_bit?
    args << "--without-ogg" if build.without? "libogg"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    raw_data = "pseudo audio data that stays the same \x00\xff\xda"
    (testpath/"in.raw").write raw_data
    # encode and decode
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=in.flac", "in.raw"
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed", "--output-name=out.raw", "in.flac"
    # diff input and output
    system "diff", "in.raw", "out.raw"
  end
end
