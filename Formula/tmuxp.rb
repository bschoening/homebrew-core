class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a8/f6/eb9d09f3362e2439f50fc20553e584b0edc75ea8e32c58d4dacce0757c1c/tmuxp-1.13.3.tar.gz"
  sha256 "bd8dab943152671c199febdabc8a913eeb177df9245419f91ad9336293649af7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c5eac52774be02521c79f0efbf067b69b73ef52607611e2f121105b1768d993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe2116ec61e0bbb3ee79a863f28c6aa53367b648a6c9c583fd36581058f4dc5f"
    sha256 cellar: :any_skip_relocation, monterey:       "5068145a3bacefd056416fe77905069bd599408185f29f13e49d4691c5e5be81"
    sha256 cellar: :any_skip_relocation, big_sur:        "666cf00c3f5fbd8d729ec8539e79679458ebeb749dbbccfe474f8bdff799cb12"
    sha256 cellar: :any_skip_relocation, catalina:       "f28485ff921fa2383d8711f87df65528d9c77cc9fd2db78fa878b8be17822ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3095d9b27173dca9ba8803249d1fd3c238960e9190b870c71b789cd7e95b3da"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/dd/0f/7d461d60f7fa613f50c15c1d92506e06fc59b2858386180de969e4236a62/libtmux-0.14.2.tar.gz"
    sha256 "38ee348a119c4f60caa9cefc66f15c5d0d46b8cabb3e59dcf22162f8773f8a48"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
