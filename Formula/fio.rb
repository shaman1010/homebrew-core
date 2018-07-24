class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.8.tar.gz"
  sha256 "3eccc9eb2ccf9d910ab391c5d639565e0f6bb4050620d161f26c36c6ff83454f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f503975275271286ff82bf7c6c0ec73f4074da041124ecc7b3f3adab14114957" => :high_sierra
    sha256 "53d88093acde915c4bd2333ad05d93e6a67c58264f2990bbb61e1bac1df059d3" => :sierra
    sha256 "2681e8a23ef5562648b883dc52b3027aa3e5a8f814248277c69541e5e639f9b1" => :el_capitan
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
