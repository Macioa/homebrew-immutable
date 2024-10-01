class Immutable < Formula
    desc "Setup development environment with Homebrew, asdf, Erlang, Elixir, Node.js, and more"
    homepage "https://github.com/macioa/immutablestack"
    url "file://#{File.expand_path("ImmutableStack-v0.1.50.tar.gz", __dir__)}"
    # sha256 "88b621cffba66e524a54dfa21b890e36f39acf9f39c5f2c8b9f6f68df23c8048"
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
          node "$(brew --prefix)/bin/gen" "$2"
        else
          echo "
            Usage: 
              immutable -install                # Install core (required)
              immutable -devkit                 # Install external dev tools (optional)
              immutable -init _my_proj_name     # Initialize a new project
              immutable -genfile _my_genname    # Create a generator file
              immutable -gen _my_genfile_path   # Run generator with generator file
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