class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.1.35.tar.gz"
  sha256 "14ac8ba195fb878ed62319cc581db31dfb8a0057ae374cd83c6b7b21fc39e113"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "762fd6ac9e937d5eb7c00ee99814b237732d78cb4b2cc901de8b8ff8b563f81d"
    sha256 cellar: :any,                 arm64_ventura:  "742fc7a10d4da1b51db3d4699b27361e6da899f44b2d09703b7b4c2f45bbb09c"
    sha256 cellar: :any,                 arm64_monterey: "1dedaf33913b32a8389c12bb6fcb52fd727207d423ffdbbd479fd59455e7b611"
    sha256 cellar: :any,                 sonoma:         "d345a4ed7fa6022cd6734b1d4fa5ca60fcd7bbf7d343fe4d853d79f60be956c5"
    sha256 cellar: :any,                 ventura:        "da6c9086a4868e29a9229d7688a31747525eaa5cd5c0af51332ffdb1324929a8"
    sha256 cellar: :any,                 monterey:       "6d69f4cf6e44f76b075bcef161a5fa71e1d464f4eb97e2f789965e1d1d94accd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34cd22f09a07b643ca95b23366fdd83c8f7c0e8a6c9c55299dcbedb52ae57280"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "python" => :test

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"uv", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
