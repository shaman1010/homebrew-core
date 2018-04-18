class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_6/libtorrent-rasterbar-1.1.6.tar.gz"
  sha256 "b7c74d004bd121bd6e9f8975ee1fec3c95c74044c6a6250f6b07f259f55121ef"

  bottle do
    cellar :any
    sha256 "8cd79bfdf6c716deffae8a9fc7ece2232d0437de5ab968906ab50e70fafbbd28" => :high_sierra
    sha256 "3cf7fc064312c4d23ed85849740a645de44d859a99022d55fd6a2891a2c9fcbf" => :sierra
    sha256 "9751d3576a7eeefabef787bafe1ac74e646c36123e33e5559b9cb53d4ee21ab5" => :el_capitan
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@2" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python@2"

  # Fix "error: no member named 'prior' in namespace 'boost'"
  # Upstream issue from 18 Apr 2018 "Boost 1.67.0 build failure"
  # See https://github.com/arvidn/libtorrent/issues/2947
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/22e74f4/libtorrent-rasterbar/boost-1.67.diff"
    sha256 "65e9f05f69bdd439f967e127fd07475c77b2f7885c50457d36b170ed5e6a3bb9"
  end

  def install
    ENV.cxx11
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python@2"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python-mt"
    end

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
