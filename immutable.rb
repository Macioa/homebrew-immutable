class Immutable < Formula
    desc "Setup development environment with Homebrew, asdf, Erlang, Elixir, Node.js, and more"
    homepage "https://github.com/macioa/immutablestack"
    url "file://#{File.expand_path("ImmutableStack-v0.0.0.tar.gz", __dir__)}"
    sha256 "9b55b3810507268b596e65f6202b76b04385ab82954b35d867d73f9ea0cd6889"
    license "Apache-2.0"
    version "0.0.0"
  
    depends_on "asdf"
    depends_on "node"
  
    def install
      bin.install "start_macos.sh"
      bin.install "dev_kit_macos.sh"
      bin.install "init_proj.sh"
      bin.install "versions.sh"
      (bin/"immutable").write <<~EOS
        #!/bin/bash
        if [ "$1" == "-install" ]; then
          "$(brew --prefix)/bin/start_macos.sh"
        elif [ "$1" == "-devkit" ]; then
          "$(brew --prefix)/bin/dev_kit_macos.sh"
        elif [ "$1" == "-init" ]; then
          "$(brew --prefix)/bin/init_proj.sh" "$2"
        else
          echo "Usage: immutable -install"
        fi
      EOS
    end
  
    def post_install
      # No post-install actions needed
    end
  
    test do
      system "#{bin}/immutable", "-install"
    end
  end