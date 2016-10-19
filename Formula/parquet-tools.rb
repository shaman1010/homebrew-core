class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      :tag => "apache-parquet-1.9.0",
      :revision => "38262e2c80015d0935dad20f8e18f2d6f9fbd03c"
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38775c26308bfa9cde712927d60d5f89daf54fbef837ba8639db13c4abe0be07" => :sierra
    sha256 "f1382310a6cfd278b0a545c944e32cc6a486b3885ef1f023f4290e0bde4be7bf" => :el_capitan
    sha256 "1780f8fa81ef90becc15d5e6cbbe6994f639a51429347f9c223599518a9d049d" => :yosemite
    sha256 "72c7af52e61a9f93ae80dd0c51f42ff09fc7024b985e785e3b79f866720e4d20" => :mavericks
  end

  depends_on "maven" => :build

  def install
    ENV.java_cache
    cd "parquet-tools" do
      system "mvn", "clean", "package", "-Plocal"
      libexec.install "target/parquet-tools-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-#{version}.jar", "parquet-tools"
    end
  end

  test do
    system "#{bin}/parquet-tools", "cat", "-h"
  end
end
