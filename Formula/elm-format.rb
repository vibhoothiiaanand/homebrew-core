require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal

  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.8.0",
      :revision => "f19ac28046d7e83ff95f845849c033cc616f1bd6"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82a105d7ebd9788a979a585fe144dd87cf47859024bfedb9682324ef645b7260" => :mojave
    sha256 "d63d07ef26edd91e1b10c4b1286dd271ac7f2958eb5e92aa78bb62ec49f4802a" => :high_sierra
    sha256 "0d803f1ba6449fc85db9edac0bf55f14c9358868b015559ec2836c799bdf9cb4" => :sierra
    sha256 "034a1da2a60646992a7571e1879f6ff31ebc43c3f43250689d4b6d6f1c12286d" => :el_capitan
    sha256 "964df8c9e60c3ab2968fa6d6304beee5d0eefd993001a35e26da279b54e2e543" => :yosemite
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    # GHC 8.4.1 compat
    # Reported upstream 21 Mar 2018 https://github.com/avh4/elm-format/issues/464
    (buildpath/"cabal.config").write <<~EOS
      allow-newer: elm-format:free, elm-format:optparse-applicative
      constraints: free < 6, optparse-applicative < 0.15
    EOS

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format-0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format-0.19", testpath/"Hello.elm", "--yes"
  end
end
