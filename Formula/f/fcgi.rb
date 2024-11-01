class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.2.tar.gz"
  sha256 "1fe83501edfc3a7ec96bb1e69db3fd5ea1730135bd73ab152186fd0b437013bc"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a79a999a6f844c409d74bfe3a565c087a34efa16531a9a51bf68c9b7cd946e1c"
    sha256 cellar: :any,                 arm64_sonoma:   "01edfb9feb557c8a45a559064590c132cf84a1448c3eafdaf581cd5871e30d30"
    sha256 cellar: :any,                 arm64_ventura:  "687f04ecaf81ae2c95d0e9cfa6a2502f848e596de4f6e2ebb83e8f507aa7717f"
    sha256 cellar: :any,                 arm64_monterey: "5434ce533ae7898eaabbf035d9a03b6b232913d66f5fb687981954d618fc15f4"
    sha256 cellar: :any,                 arm64_big_sur:  "f690a0cd985561930532baa0676c10f954f5c4d3500a8ec40733a28debfd0656"
    sha256 cellar: :any,                 sonoma:         "cc69bf2ec90b23b2ebfe4775c93cf2c499878da19340136d092d63e5d2af8433"
    sha256 cellar: :any,                 ventura:        "84aac5009dfb2d2c434cddca973f6e7c8d89f5791d121a173e92ebb745342e50"
    sha256 cellar: :any,                 monterey:       "4e5296dd2cc2e2f9c65296166f8bd372f2d831f235a8595cd54b295167846bcb"
    sha256 cellar: :any,                 big_sur:        "62ab01d728067324cc5466d20d28e6a6920514c0a1f379df290cbc3b79cb442d"
    sha256 cellar: :any,                 catalina:       "3905f7f3dec32a296b831f224a4f2cc75089c60b8a0137ce0b25e37466ffba8a"
    sha256 cellar: :any,                 mojave:         "a43c52588cc652fcc1d9be4d89393212875732349bd4dbdda4068f985db10628"
    sha256 cellar: :any,                 high_sierra:    "3ee3183f46dd8f38eee932f685e8d6a52fd0c0c2a1797bb25d62ad973b1405ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a2286c8c9debc8d9d2a49269e30acd519d404537e4663cc17bc9f3ad35c25c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.c").write <<~C
      #include "fcgi_stdio.h"
      #include <stdlib.h>
      int count = 0;
      int main(void){
        while (FCGI_Accept() >= 0){
        printf("Request number %d running on host %s", ++count, getenv("SERVER_HOSTNAME"));}}
    C
    system ENV.cc, "testfile.c", "-L#{lib}", "-lfcgi", "-o", "testfile"
    assert_match "Request number 1 running on host", shell_output("./testfile")
  end
end
