let
  pkgs = import <nixpkgs> { };
  # define version
  using_python = pkgs.python312;
  # import required python packages
  required_python_packages = import ./py_requirements.nix;
  #
  extra_search_directory = ".extra-symlink-search-path";
  pyenv = using_python.withPackages required_python_packages;
in
pkgs.mkShell {
  packages = [
    pyenv
    pkgs.systemd
  ];
  shellHook = ''
    if [ ! -d ${extra_search_directory} ]; then mkdir ${extra_search_directory}; fi
    symlink_extra_path(){
      actual_link_path=$(readlink -f ${extra_search_directory}/$1)
      if [ $actual_link_path != $2 ]; then
        rm ${extra_search_directory}/$1 > /dev/null 2>&1
      fi
      if [ ! -h ${extra_search_directory}/$1 ]; then ln -s $2 ${extra_search_directory}/$1; fi
    }
    symlink_extra_path site-packages ${pyenv}/${using_python.sitePackages}
  '';
}
