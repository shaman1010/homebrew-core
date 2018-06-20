class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.30.0.tar.gz"
  sha256 "7cc70781776e9824e2f08aa6a11b5cda96a86cf2df2e21b977969ddd8d630e7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffb38673f88cc9198bc7cb8dcdd513f1707d96d03c390f3db8417b38092b25e6" => :high_sierra
    sha256 "bb98ee836107b2dbb1fb254e2b0856fb0df2af5db41962b9e5bdd0aa623569ce" => :sierra
    sha256 "225c55670dafe71acc19666a4559df1cd19dc9f9a44faba4687499b29ef1639a" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
