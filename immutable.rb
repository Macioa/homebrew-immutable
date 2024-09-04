class Immutable < Formula
    desc "Setup development environment with Homebrew, asdf, Erlang, Elixir, Node.js, and more"
    homepage "https://github.com/macioa/immutablestack"
    url "file://#{File.expand_path("ImmutableStack-v0.0.2.tar.gz", __dir__)}"
    sha256 "10ba75446880eebbf919c11a62ef508bf968ee24fa0005e773e2674c69af6599"
    license "Apache-2.0"
    version "0.0.0"
  
    depends_on "asdf"
    depends_on "node"
  
    def install
      bin.install "start_macos.sh"
      bin.install "dev_kit_macos.sh"
      bin.install "init_proj.sh"
      bin.install "versions.sh"
      bin.install "gen_toolkit.sh"
      bin.install "templates/init/dev/DB.DOCKERFILE"
      bin.install "templates/init/dev/CLIENT.DOCKERFILE"
      bin.install "templates/init/dev/SERVER.DOCKERFILE"

      (bin/"immutable").write <<~EOS
        #!/bin/bash
        if [ "$1" == "-install" ]; then
          "$(brew --prefix)/bin/start_macos.sh"
        elif [ "$1" == "-devkit" ]; then
          "$(brew --prefix)/bin/dev_kit_macos.sh"
        elif [ "$1" == "-init" ]; then
          "$(brew --prefix)/bin/init_proj.sh" "$2"
          "$(brew --prefix)/bin/gen_toolkit.sh" "$2_umbrella"
          mkdir -p "$2_umbrella/docker/dev"
          cp "$(brew --prefix)/bin/DB.DOCKERFILE" "$2_umbrella/docker/dev"
          cp "$(brew --prefix)/bin/CLIENT.DOCKERFILE" "$2_umbrella/docker/dev"
          cp "$(brew --prefix)/bin/SERVER.DOCKERFILE" "$2_umbrella/docker/dev"
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