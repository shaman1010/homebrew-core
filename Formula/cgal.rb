class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases/CGAL-4.8.1/CGAL-4.8.1.tar.xz"
  sha256 "fa2036e0a53cc54eee3dffe4763028e9aec831672c8259fa376d3c29e8f781b0"

  bottle do
    cellar :any
    sha256 "10d807979225870180b7a77a54923e451dce8bd0b0fc5bacdd1a3c074769045d" => :el_capitan
    sha256 "c23e7870b3b9d8f152f2a2cf39df0a399b3fd419e2bd0c246768722dcfc31ad5" => :yosemite
    sha256 "ba56ab4ee49f038a1cadf7dd8e3c03b0ecd1cd1a531d608ae360adfb03d0410a" => :mavericks
  end

  option :cxx11
  option "with-qt5", "Build ImageIO and QT5 compoments of CGAL"
  option "with-eigen", "Build with Eigen3 support"
  option "with-lapack", "Build with LAPACK support"

  deprecated_option "imaging" => "with-qt5"
  deprecated_option "with-imaging" => "with-qt5"
  deprecated_option "with-eigen3" => "with-eigen"

  depends_on "cmake" => :build
  depends_on "mpfr"

  depends_on "qt5" => :optional
  depends_on "eigen" => :optional

  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "gmp"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %W[
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib
    ]

    if build.without? "qt5"
      args << "-DWITH_CGAL_Qt5=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    else
      args << "-DWITH_CGAL_Qt5=ON" << "-DWITH_CGAL_ImageIO=ON"
    end

    if build.with? "eigen"
      args << "-DWITH_Eigen3=ON"
    else
      args << "-DWITH_Eigen3=OFF"
    end

    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    else
      args << "-DWITH_LAPACK=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    # http://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<-EOS.undent
      #include <CGAL/basic.h>
      #include <CGAL/Coercion_traits.h>
      #include <CGAL/IO/io.h>
      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
          typedef CGAL::Coercion_traits<A,B> CT;
          CGAL_static_assertion((CT::Are_explicit_interoperable::value));
          typename CT::Cast cast;
          return cast(a)*cast(b);
      }
      int main(){
          std::cout<< binary_func(double(3), int(5)) << std::endl;
          std::cout<< binary_func(int(3), double(5)) << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lCGAL",
                    "surprise.cpp", "-o", "test"
    assert_equal "15\n15", shell_output("./test").chomp
  end
end
