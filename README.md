# dotfiles
bootstrap and single source of development environment configuration

## TODOs
* finish help
* add dotfiles to PATH during bootstrap?
* some day think of using scoop instead of choco

## Repository structure

* _bootstrap/_ - scripts to bootstrap powershell on various environments

* _packages/_ - list of tools to install and how to configre them
    * _packages.txt_ - list of packages to install
    * _packageName/_ - configuration files for a packages with name _packageName_

## Notes

* Scripts here create file _$HOME/.environment.json_ with various environment variables definitions,
those are being read by _$PROFILE_ on powershell startup

