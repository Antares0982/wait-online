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
    if [ ! -h ${extra_search_directory}/site-packages ]; then ln -s ${pyenv}/${using_python.sitePackages} ${extra_search_directory}/site-packages; fi
  '';
}
