class Immutable < Formula
    desc "Setup development environment with Homebrew, asdf, Erlang, Elixir, Node.js, and more"
    homepage "https://github.com/macioa/immutablestack"
    url "file://#{File.expand_path("ImmutableStack-v0.3.210.tar.gz", __dir__)}"
    sha256 "af906426425135ab3313163d1457dbb1b295b904821d6577cd0e1a88ebb33fa5"
    license "Apache-2.0"
    version "0.0.0"
  
    depends_on "asdf"
    depends_on "node"
  
    def install
      bin.install "start_macos.sh"
      bin.install "dev_kit_macos.sh"
      bin.install "init_proj.js"
      bin.install "versions.sh"
      bin.install "gen_toolkit.sh"
      bin.install "genfile.js"
      bin.install "gen.js"
      bin.install "gentemplate.js"
      
      (bin/"immutable").write <<~EOS
        #!/bin/bash
        if [ "$1" == "-install" ]; then
          "$(brew --prefix)/bin/start_macos.sh"
        elif [ "$1" == "-devkit" ]; then
          "$(brew --prefix)/bin/dev_kit_macos.sh"
        elif [ "$1" == "-init" ]; then
           node "$(brew --prefix)/bin/init_proj.js" "$2"
          "$(brew --prefix)/bin/gen_toolkit.sh" "$2_umbrella"
        elif [ "$1" == "-genfile" ]; then
          node "$(brew --prefix)/bin/genfile.js" "$2"
        elif [ "$1" == "-gen" ]; then
          ts-node "$(brew --prefix)/bin/gen" "$2"
        elif [ "$1" == "-gentemplate" ]; then
          node "$(brew --prefix)/bin/gentemplate.js" "$2" "$3"
        else
          echo "
            Usage: 
              immutable -install                                # Install core (required)
              immutable -devkit                                 # Install external dev tools (optional)
              immutable -init _my_proj_name                     # Initialize a new project
              immutable -genfile _my_genname                    # Create a generator file
              immutable -gen _my_genfile_path                   # Run generator with generator file
              immutable -gentemplate _my_genname _my filepath   # Create a string literal template from existing code
          "
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