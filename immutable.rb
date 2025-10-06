class Immutable < Formula
    desc "Setup development environment with Homebrew, asdf, Erlang, Elixir, Node.js, and more"
    homepage "https://github.com/macioa/immutablestack"
    url "file://#{File.expand_path("ImmutableStack-v0.911.0.tar.gz", __dir__)}"
    sha256 "67def1221d8a5f19a693b5018f511887b95b2dac922b8493aba41b10d679aba1"
    license "Apache-2.0"
    version "v0.911.0"
  
    depends_on "asdf"
    depends_on "node"
  
    def install
      bin.install "start_macos.sh"
      bin.install "start.js"
      bin.install "dev_kit_macos.sh"
      bin.install "init_proj.js"
      bin.install "versions.sh"
      bin.install "gen_toolkit.sh"
      bin.install "genfile.js"
      bin.install "gen.js"
      bin.install "gentemplate.js"
      bin.install "links.js"
      bin.install "settings.js"
      bin.install "repair.js"
      bin.install "channel.js"
      
      (bin/"immutable").write <<~EOS
        #!/bin/bash
        if [ "$1" == "-install" ]; then
          node "$(brew --prefix)/bin/start.js"
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
        elif [ "$1" == "-links" ]; then
          node "$(brew --prefix)/bin/links.js"
        elif [ "$1" == "-settings" ]; then
          node "$(brew --prefix)/bin/settings.js" "$@"
        elif [ "$1" == "-repair" ]; then
          node "$(brew --prefix)/bin/repair.js" "$@"
        elif [ "$1" == "-gen_channel" ]; then
          node "$(brew --prefix)/bin/channel.js" "$2"
        else
          echo "
            Usage: 
              immutable -install                                # Install core (required)
              immutable -devkit                                 # Install external dev tools (optional)
              immutable -init _my_proj_name                     # Initialize a new project
              immutable -genfile _my_genname                    # Create a generator file
              immutable -gen _my_genfile_path                   # Run generator with generator file
              immutable -gen_channel _my_channel_name           # Create a channel
              immutable -repair _my_broken_file_path            # Repair a file using AI (see docs for details)
              immutable -gentemplate _my_genname _my filepath   # Create a string literal template from existing code
              immutable -settings my_key: my_value              # Save a key:value to settings
              immutable -settings -clear                        # Clear local settings
              immutable -links                                  # Quick links to common files and directories              
          "
        fi
      EOS
    end
  
    def post_install
      system "#{bin}/immutable", "-install"
    end
  
    test do
      system "#{bin}/immutable", "-genfile test"
    end
  end