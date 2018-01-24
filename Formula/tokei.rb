class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.1.tar.gz"
  sha256 "71c9be9ad04bc66501f5f54e74b5cf5e56fc1392ceead5525b743006145ac3a9"

  bottle do
    sha256 "85543eb65dc14c1218c8eb2e7013b7991b4082f560b5f6ad08324d1bb0823413" => :high_sierra
    sha256 "54c4979f14c8f857b700acee9879b806558a636519a874cf5db432399fcd0eef" => :sierra
    sha256 "9724829ea70c535be23139cc56716acbdb017024a270a7f2c3263c3ed3ee3585" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
